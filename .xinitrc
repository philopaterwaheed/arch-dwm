xidlehook --not-when-audio --not-when-fullscreen --timer 600 "slock&  loginctl suspend" - &
xrandr --output HDMI-1 --auto
exec ~/.fehbg&
exec xcompmgr& 
exec xrdb -merge ~/.Xresources&
/home/philosan/.bar&
exec dwm 
##########



