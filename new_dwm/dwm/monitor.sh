#!/bin/bash
MON="d"
E="enabled"
D="disabled"
if xrandr --listactivemonitors | grep -q "HDMI"; then MON="enabled"; else MON="disabled"; fi
echo "$MON"
if [ $MON == $D ] 
then
xrandr --output HDMI-1 --auto --right-of DP-1;
elif [ MON==$E ] 
then 
xrandr --output HDMI-1 --off;
else 
echo "d";
fi
#xrandr --output HDMI-1 --right-of DP-1
