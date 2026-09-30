#!/bin/bash
# Usage: screenshot.sh [-s]   (-s = select area/window)
dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"
img="$dir/$(date +%Y-%m-%d-%H-%M-%S).png"

if [ "$1" = "-s" ]; then
	scrot -s -f "$img"
else
	scrot "$img"
fi || exit 1

xclip -selection clipboard -t image/png -i "$img"
notify-send -i "$img" "Screenshot" "Saved and copied: $img"
