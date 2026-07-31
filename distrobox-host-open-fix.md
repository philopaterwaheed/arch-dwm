# Fixing "xdg-open does nothing" inside distrobox containers

Written for this machine: CachyOS host (KDE / xdg-desktop-portal, dbus-broker),
distrobox 1.8.2.5 on the **docker** backend, container `dev` (archlinux).

## The symptom

Inside the container, any tool that wants to log you in through a browser
(`gh auth login`, `aws sso login`, `gcloud auth login`, `vercel`, `wrangler`,
`supabase login`, and so on) silently fails to open one:

```console
[dev]$ xdg-open https://example.com
[dev]$ echo $?
127
```

No error message, no browser, exit code 127. `host-spawn` looks absent or
broken in the same way.

## The root cause

distrobox does not ship a real `xdg-open` in the container. It installs a
symlink:

```
/usr/local/bin/xdg-open -> /usr/bin/distrobox-host-exec
```

`distrobox-host-exec` runs the command on the host through `host-spawn`, and
`host-spawn` does that by calling the **`org.freedesktop.Flatpak`** D-Bus
service on your session bus.

That service is shipped by the **flatpak** package
(`/usr/share/dbus-1/services/org.freedesktop.Flatpak.service`, which activates
`/usr/lib/flatpak-session-helper`). This host does not have flatpak installed,
so the bus name does not exist — not even as an activatable name. `host-spawn`
then exits 127 and prints nothing, which makes it look like it is missing when
it is actually installed and running fine.

Confirm the diagnosis at any time:

```bash
# On the host: is the service flatpak provides present? Expect "b false".
busctl --user call org.freedesktop.DBus /org/freedesktop/DBus \
    org.freedesktop.DBus NameHasOwner s org.freedesktop.Flatpak

# From the container: is the desktop portal present? Expect "b true".
distrobox enter dev -- busctl --user call org.freedesktop.DBus /org/freedesktop/DBus \
    org.freedesktop.DBus NameHasOwner s org.freedesktop.portal.Desktop
```

The second one is the way out. distrobox already shares the host session bus
(`/run/user/1000/bus`) with the container, and the host's **xdg-desktop-portal**
is sitting on it. Its `org.freedesktop.portal.OpenURI` interface opens URLs and
files on the host desktop, needs no flatpak, and needs no changes on the host.

## The fix

The installer lives at `~/.local/bin/distrobox-host-open-fix.sh`. Run it on the
**host**:

```bash
distrobox-host-open-fix.sh            # every distrobox container
distrobox-host-open-fix.sh dev        # just this one
distrobox-host-open-fix.sh --test dev # fix, then open a test page
```

It is idempotent, so re-run it whenever you like. Inside each container it
installs:

| Path | Purpose |
| --- | --- |
| `/usr/local/bin/distrobox-host-open` | the shim that calls the host portal |
| `/usr/local/bin/xdg-open` | symlink to the shim, replacing distrobox's |
| `/usr/local/bin/xdg-email` | symlink, for `mailto:` |
| `/usr/local/bin/{x-www-browser,www-browser,sensible-browser}` | symlinks, for tools that look for these instead |
| `/etc/profile.d/99-distrobox-host-open.sh` | sets `BROWSER` if unset |

`/usr/local/bin` comes before `/usr/bin` in the container's `PATH`, so these
win. The shim tries the portal first and falls back to `host-spawn`, so it will
quietly start using the native path if you ever install flatpak on the host.

This survives container restarts. `distrobox-init` only recreates its own
symlink when no `xdg-open` exists at all
(`if [ "${init}" -eq 0 ] && ! command -v xdg-open`, around line 1864 of
`/usr/bin/distrobox-init`), and ours is found first. It does **not** survive
`distrobox rm` + recreate — see "New containers" below.

## Verify

```bash
distrobox enter dev -- bash -lc 'xdg-open https://example.com; echo "exit=$?"'
distrobox enter dev -- bash -lc 'python3 -c "import webbrowser; print(webbrowser.open(\"https://example.org\"))"'
distrobox enter dev -- bash -lc 'echo "BROWSER=$BROWSER"'
```

Expect `exit=0`, `True`, `BROWSER=/usr/local/bin/distrobox-host-open`, and a
browser tab on the host for each of the first two.

## Doing it by hand

If you are on another machine without the script, this is the whole fix:

```bash
distrobox enter <container>
sudo tee /usr/local/bin/distrobox-host-open > /dev/null << 'EOF'
#!/bin/sh
set -eu
: "${XDG_RUNTIME_DIR:=/run/user/$(id -u)}"
: "${DBUS_SESSION_BUS_ADDRESS:=unix:path=${XDG_RUNTIME_DIR}/bus}"
export DBUS_SESSION_BUS_ADDRESS
case $1 in
    *://* | mailto:* | tel:*) uri=$1 ;;
    /*) uri=file://$1 ;;
    *) uri=file://$(pwd)/$1 ;;
esac
exec gdbus call --session \
    --dest org.freedesktop.portal.Desktop \
    --object-path /org/freedesktop/portal/desktop \
    --method org.freedesktop.portal.OpenURI.OpenURI \
    "" "$uri" "{}" > /dev/null
EOF
sudo chmod +x /usr/local/bin/distrobox-host-open
sudo ln -sfn /usr/local/bin/distrobox-host-open /usr/local/bin/xdg-open
```

Requires `gdbus` in the container (Arch: `pacman -S glib2`; Debian/Ubuntu:
`apt install libglib2.0-bin`). The full installer adds percent-encoding for
paths with spaces, a `python3`/`dbus` fallback when `gdbus` is missing, and the
browser aliases.

## New containers

`distrobox rm` wipes the container filesystem, so a recreated container needs
the fix again. Either re-run `distrobox-host-open-fix.sh <name>` after creating
it, or apply it automatically to every new container by creating
`~/.config/distrobox/distrobox.conf`:

```ini
container_init_hook="/home/philosan/.local/bin/distrobox-host-open-fix.sh --install"
```

The hook runs as root inside the container at creation time, which is exactly
what `--install` expects. Per-container equivalent:

```bash
distrobox create --name foo --image archlinux \
    --init-hooks '/home/philosan/.local/bin/distrobox-host-open-fix.sh --install'
```

## Optional: restore `host-spawn` itself

The portal fix only covers opening URLs and files. If you also want
`distrobox-host-exec <any host command>` to work — running host binaries from
inside the container, host `flatpak`, etc. — install flatpak on the **host**:

```bash
sudo pacman -S flatpak
systemctl --user daemon-reload   # or just log out and back in
```

That package provides `org.freedesktop.Flatpak.service` and
`flatpak-session-helper`, which is the D-Bus service `host-spawn` has been
looking for. Verify:

```bash
busctl --user call org.freedesktop.DBus /org/freedesktop/DBus \
    org.freedesktop.DBus NameHasOwner s org.freedesktop.Flatpak   # b true
distrobox enter dev -- host-spawn echo hello-from-host
```

You can keep the shim installed alongside this; it prefers the portal, which
works either way.

## Reverting

```bash
distrobox enter dev -- sudo rm -f \
    /usr/local/bin/distrobox-host-open \
    /usr/local/bin/xdg-email \
    /usr/local/bin/x-www-browser \
    /usr/local/bin/www-browser \
    /usr/local/bin/sensible-browser \
    /etc/profile.d/99-distrobox-host-open.sh
distrobox enter dev -- sudo ln -sfn /usr/bin/distrobox-host-exec /usr/local/bin/xdg-open
```

## Known limits

- **File paths must exist on the host at the same path.** Only the URI string
  is sent over the bus; the host opens it. `$HOME` is shared, so anything under
  `/home/philosan` is fine. Container-only paths (`/usr/...` inside the image,
  and `/tmp` if not shared) will not resolve the way you expect.
- **The host picks the application**, using the host's default handlers — not
  the container's `.desktop` files.
- **A running graphical session is required.** Over plain SSH with no session
  bus there is no portal to talk to, and the shim will say so instead of
  failing silently.
- The container's `/usr/bin/flatpak -> distrobox-host-exec` symlink is still
  broken; it needs flatpak on the host, per the section above.
