#!/bin/bash
rm -rf bg.png
wget $1 #gets the file name 
bg=$"/$(basename "$1")" # gets the after the slash 
bg="${bg:1}" #gets the file name
mv $bg bg.png
