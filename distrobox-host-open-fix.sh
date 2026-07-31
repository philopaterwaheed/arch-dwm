#!/usr/bin/env bash
#
# distrobox-host-open-fix.sh
#
# Fixes "xdg-open does nothing inside a distrobox container", which breaks any
# CLI tool that tries to open a browser to log you in.
#
# distrobox links xdg-open to distrobox-host-exec, which runs host commands via
# host-spawn, which speaks to the org.freedesktop.Flatpak D-Bus service. That
# service is shipped by flatpak. On a host without flatpak the name is not on
# the session bus, so every call exits 127 with no message at all.
#
# The host's xdg-desktop-portal already listens on the session bus that
# distrobox shares with the container, so this installs an xdg-open that asks
# the portal to open things instead.
#
# Usage, on the host:
#     distrobox-host-open-fix.sh                 # fix every distrobox container
#     distrobox-host-open-fix.sh dev other       # fix only these containers
#     distrobox-host-open-fix.sh --test dev      # fix, then open a test page
#
# Usage, inside a container as root (also valid as a distrobox init hook):
#     distrobox-host-open-fix.sh --install

set -euo pipefail

readonly SHIM=/usr/local/bin/distrobox-host-open
readonly PROFILE_D=/etc/profile.d/99-distrobox-host-open.sh
# Names that tools reach for when they want to show you a web page.
readonly ALIASES=(xdg-open xdg-email x-www-browser www-browser sensible-browser)

log() { printf '\033[1m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m==> warning:\033[0m %s\n' "$*" >&2; }
die() {
	printf '\033[1;31m==> error:\033[0m %s\n' "$*" >&2
	exit 1
}

write_shim() {
	mkdir -p "$(dirname "$SHIM")"
	cat > "$SHIM" << 'SHIM_EOF'
#!/bin/sh
# Open URIs and files on the host desktop from inside a distrobox container.
#
# Installed by distrobox-host-open-fix.sh, replacing distrobox's own xdg-open
# symlink. distrobox routes xdg-open through host-spawn, which needs the
# org.freedesktop.Flatpak D-Bus service that only exists when the host has
# flatpak installed. This talks to the host's xdg-desktop-portal instead, which
# is reachable on the session bus distrobox already shares with the container.

set -eu

self=${0##*/}

: "${XDG_RUNTIME_DIR:=/run/user/$(id -u)}"
: "${DBUS_SESSION_BUS_ADDRESS:=unix:path=${XDG_RUNTIME_DIR}/bus}"
export DBUS_SESSION_BUS_ADDRESS

# Percent-encode one byte at a time so paths with spaces or UTF-8 survive.
encode() {
	LC_ALL=C awk -v s="$1" 'BEGIN {
		for (i = 0; i < 256; i++) enc[sprintf("%c", i)] = sprintf("%%%02X", i)
		out = ""
		n = length(s)
		for (i = 1; i <= n; i++) {
			c = substr(s, i, 1)
			out = out ((c ~ /[A-Za-z0-9._~\/-]/) ? c : enc[c])
		}
		print out
	}'
}

to_uri() {
	arg=$1
	scheme=${arg%%:*}
	if [ "$scheme" != "$arg" ]; then
		case $scheme in
		"" | *[!A-Za-z0-9+.-]*) ;;
		[A-Za-z]*)
			printf '%s' "$arg"
			return
			;;
		esac
	fi
	case $arg in
	/*) abs=$arg ;;
	*) abs=$(pwd)/$arg ;;
	esac
	printf 'file://%s' "$(encode "$abs")"
}

portal_open() {
	if command -v gdbus > /dev/null 2>&1; then
		gdbus call --session \
			--dest org.freedesktop.portal.Desktop \
			--object-path /org/freedesktop/portal/desktop \
			--method org.freedesktop.portal.OpenURI.OpenURI \
			"" "$1" "{}" > /dev/null 2>&1
		return $?
	fi
	if command -v python3 > /dev/null 2>&1; then
		python3 - "$1" > /dev/null 2>&1 << 'PY'
import sys

import dbus

bus = dbus.SessionBus()
obj = bus.get_object("org.freedesktop.portal.Desktop", "/org/freedesktop/portal/desktop")
dbus.Interface(obj, "org.freedesktop.portal.OpenURI").OpenURI("", sys.argv[1], {})
PY
		return $?
	fi
	return 1
}

# Only useful once the host has flatpak, but costs nothing to try last.
host_spawn_open() {
	command -v host-spawn > /dev/null 2>&1 || return 1
	host-spawn xdg-open "$1" > /dev/null 2>&1
}

if [ "$#" -eq 0 ]; then
	printf 'usage: %s {file|URL}\n' "$self" >&2
	exit 1
fi

status=0
for arg do
	case $arg in
	-h | --help)
		printf 'usage: %s {file|URL}\n' "$self"
		exit 0
		;;
	--version)
		printf '%s (distrobox portal shim)\n' "$self"
		exit 0
		;;
	--*) continue ;;
	esac

	uri=$(to_uri "$arg")
	portal_open "$uri" && continue
	host_spawn_open "$uri" && continue

	printf '%s: could not hand "%s" to the host desktop.\n' "$self" "$arg" >&2
	printf '%s: is %s reachable on %s?\n' \
		"$self" org.freedesktop.portal.Desktop "$DBUS_SESSION_BUS_ADDRESS" >&2
	status=4
done

exit $status
SHIM_EOF
	chmod 0755 "$SHIM"
}

link_aliases() {
	local name target
	for name in "${ALIASES[@]}"; do
		target=/usr/local/bin/$name
		# distrobox ships xdg-open as a symlink to distrobox-host-exec; anything
		# else already there is the user's own and should be left alone.
		if [ -e "$target" ] && [ ! -L "$target" ]; then
			warn "$target exists and is not a symlink, leaving it alone"
			continue
		fi
		ln -sfn "$SHIM" "$target"
	done
}

write_profile() {
	cat > "$PROFILE_D" << 'PROFILE_EOF'
# Point tools that read $BROWSER at the host desktop.
# Installed by distrobox-host-open-fix.sh.
if [ -x /usr/local/bin/distrobox-host-open ] && [ -z "${BROWSER:-}" ]; then
	BROWSER=/usr/local/bin/distrobox-host-open
	export BROWSER
fi
PROFILE_EOF
	chmod 0644 "$PROFILE_D"
}

install_in_container() {
	[ "$(id -u)" -eq 0 ] || die "--install must run as root inside the container"

	write_shim
	link_aliases
	write_profile

	log "installed $SHIM"
	log "linked: ${ALIASES[*]}"
	log "installed $PROFILE_D"
}

# Checks, as the normal container user, that the host's portal is reachable.
verify_container() {
	local name=$1 owner
	owner=$(distrobox enter "$name" -- gdbus call --session \
		--dest org.freedesktop.DBus \
		--object-path /org/freedesktop/DBus \
		--method org.freedesktop.DBus.NameHasOwner \
		org.freedesktop.portal.Desktop 2> /dev/null || true)
	case $owner in
	*true*) log "$name: host xdg-desktop-portal is reachable" ;;
	*) warn "$name: cannot reach org.freedesktop.portal.Desktop. Check that xdg-desktop-portal is running on the host and that DBUS_SESSION_BUS_ADDRESS is set in the container." ;;
	esac
}

fix_container() {
	local name=$1 script=$2

	log "fixing container: $name"
	if distrobox enter "$name" -- test -r "$script" > /dev/null 2>&1; then
		distrobox enter "$name" -- sudo -n "$script" --install
	else
		# $HOME is not shared with this container, so feed the script over stdin.
		distrobox enter "$name" -- sudo -n bash -s -- --install < "$script"
	fi
	verify_container "$name"
}

main() {
	local script test=0
	script=$(readlink -f "$0")

	local -a containers=()
	for arg in "$@"; do
		case $arg in
		--install)
			install_in_container
			return 0
			;;
		--test) test=1 ;;
		-h | --help)
			sed -n '3,30p' "$script"
			return 0
			;;
		-*) die "unknown option: $arg" ;;
		*) containers+=("$arg") ;;
		esac
	done

	command -v distrobox > /dev/null 2>&1 || die "distrobox is not installed"

	if [ ${#containers[@]} -eq 0 ]; then
		mapfile -t containers < <(distrobox list --no-color 2> /dev/null |
			awk -F'|' 'NR > 1 && NF > 1 { gsub(/ /, "", $2); if ($2 != "") print $2 }')
		[ ${#containers[@]} -gt 0 ] || die "no distrobox containers found"
	fi

	for name in "${containers[@]}"; do
		fix_container "$name" "$script"
	done

	if [ "$test" -eq 1 ]; then
		log "opening https://example.com from ${containers[0]}"
		distrobox enter "${containers[0]}" -- xdg-open https://example.com
	fi

	log "done"
}

main "$@"
