#!/bin/bash
HOT_DIRS=("$HOME/Dev/" "$HOME/Hdd/downloads/" "$HOME/Downloads" "$HOME/Pics/") # the most visited dirictories in the system
DIR=$(find "${HOT_DIRS[@]}" -type d ! -name '.*' |dmenu)
if [[ -n "$DIR" ]]; then
st -e bash --rcfile <(echo ". ~/.bashrc; cd $DIR")
fi

