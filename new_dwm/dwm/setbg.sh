#!/bin/bash
sudo rm -rf bg.png
sudo wget $1 #gets the file name 
bg=$"/$(basename "$1")" # gets the after the slash 
bg="${bg:1}" #gets the file name
sudo mv $bg bg.png
