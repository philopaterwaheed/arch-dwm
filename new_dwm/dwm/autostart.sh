#! /bin/bash
bash /home/philosan/dwm/.bar &
# Terminate if picom is already running
killall -q picom

# Wait until the processes have been shut down
while pgrep -u $UID -x picom >/dev/null; do sleep 1; done
# Launch picom
picom --config /home/philosan/.config/picom/picom.conf&
export XDG_CURRENT_DESKTOP='dwm'

# Enable power management
xfce4-power-manager &

# Fix problems with Java apps
wmname "LG3D"
export _JAVA_AWT_WM_NONREPARENTING=1



/home/philosan/dwm/scripts/dwm_dunst
/home/philosan/dwm/scripts/fehbg


xsettingsd --config= /home/philosan/dwm/scripts/xsettingsd &
