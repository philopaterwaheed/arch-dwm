#! /bin/bash
bash /home/philosan/dwm/.bar &
# Terminate if picom is already running

export XDG_CURRENT_DESKTOP='dwm'

# Enable power management
xfce4-power-manager &

# Fix problems with Java apps
wmname "LG3D"
export _JAVA_AWT_WM_NONREPARENTING=1


# polkit agent
if [[ ! `pidof xfce-polkit` ]]; then
	/usr/lib/xfce-polkit/xfce-polkit &
fi

/home/philosan/dwm/scripts/dwm_dunst
/home/philosan/dwm/scripts/fehbg
/home/philosan/dwm/scripts/dwm_picom


xsettingsd --config= /home/philosan/dwm/scripts/xsettingsd &
