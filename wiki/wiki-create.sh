#!/usr/bin/env bash

WIKI_DIR="$HOME/wiki"

name=$(echo "" | wofi --dmenu --prompt "New note name")
[ -z "$name" ] && exit 0

# Sanitize filename (remove special chars, replace spaces with dashes)
filename=$(echo "$name" | tr ' ' '-' | tr -cd '[:alnum:]-_')
filepath="$WIKI_DIR/$filename.md"

# Don't overwrite existing files
if [ -f "$filepath" ]; then
    notify-send "Note exists" "$filename.md already exists" 2>/dev/null
    alacritty -e trinity "$filepath"
    exit 0
fi

# Create with title header
echo "# $name" > "$filepath"
alacritty -e trinity "$filepath"
