#!/bin/bash
LAYOUT=$(setxkbmap -query | grep layout)
LAYOUT="${LAYOUT// /}"
echo "$LAYOUT"
US="layout:us"
echo "$US"
if [ $LAYOUT == $US ]
then
setxkbmap -layout ara
else
setxkbmap -layout us
fi
