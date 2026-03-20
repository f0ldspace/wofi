#!/usr/bin/env bash

DAILY="$HOME/wiki/daily/$(date +%Y-%m-%d).md"

text=$(echo "" | wofi --dmenu --prompt "Scratch")
[ -z "$text" ] && exit 0

timestamp=$(date +%H:%M)

echo "- **${timestamp}** // ${text}" >>"$DAILY"

notify-send "Scratched" "$text"
