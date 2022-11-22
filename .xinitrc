
xrandr --output HDMI-1 --off
sudo code --user-data-dir="~/.vscode-root"&
exec ~/.fehbg&
exec xcompmgr& 
exec xrdb -merge ~/.Xresources&
while true; do
 . /home/philosan/.bar
    sleep 4s
done &
exec dwm 



