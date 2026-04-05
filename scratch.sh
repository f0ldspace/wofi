#!/usr/bin/env bash

DAILY="$HOME/.local/share/Cryptomator/mnt/wall/wall/daily/$(date +/%Y/%B/%Y-%m-%d).md"

text=$(echo "" | wofi --dmenu --prompt "Scratch")
[ -z "$text" ] && exit 0

timestamp=$(date +%H:%M)

[ -f "$DAILY" ] && [ -n "$(tail -c 1 "$DAILY")" ] && printf '\n' >>"$DAILY"
echo "- **${timestamp}** // ${text}" >>"$DAILY"

notify-send "Scratched" "$text"
