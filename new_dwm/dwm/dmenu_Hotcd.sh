#!/bin/bash
HOT_DIRS=("$HOME/Dev/" "$HOME/Hdd/downloads/" "$HOME/Downloads" "$HOME/Pics/") # the most visited dirictories in the system
HOT_DIRSLS=("$HOME/Hdd/" "$HOME/HDD1/" "$HOME/" ) # the most visited dirictories in the system using ls

FOUND=$(find "${HOT_DIRS[@]}" -type d ! -name '.*')
LSED=$(find "${HOT_DIRSLS[@]}" -maxdepth 1 -type d ! -name '.*')
DIR=$(echo -e "$FOUND\n$LSED"|dmenu)
if [[ -n "$DIR" ]]; then
st -e bash --rcfile <(echo ". ~/.bashrc; cd $DIR")
fi

