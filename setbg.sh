#!/bin/bash
rm -rf bg.png
wget $1
bg=$"/$(basename "$1")"
echo "$hdd"
bg="${bg:1}"
mv $bg bg.png


