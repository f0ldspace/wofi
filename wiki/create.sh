#!/usr/bin/env bash

WIKI_DIR="$HOME/wiki"

title=$(echo "" | wofi --dmenu --prompt "Note title")
[ -z "$title" ] && exit 0

date=$(date +%Y-%m-%d)

# Sanitize filename (remove special chars, replace spaces with dashes)
slug=$(echo "$title" | tr ' ' '-' | tr -cd '[:alnum:]-_')
filename="${date}-${slug}"
filepath="$WIKI_DIR/$filename.md"

# Don't overwrite existing files
if [ -f "$filepath" ]; then
  notify-send "Note exists" "$filename.md already exists" 2>/dev/null
  alacritty -e trinity "$filepath" &
  sleep 0.3
  niri msg action set-column-width -- "30%"
  exit 0
fi

# Create with title and date
printf "# %s\n\n**%s**\n\n" "$title" "$date" >"$filepath"
alacritty -e trinity "$filepath" &
sleep 0.3
niri msg action set-column-width -- "30%"
