#!/usr/bin/env bash

DAILY_FILE="$HOME/personal/daily-2026.md"

note=$(echo "" | wofi --dmenu --prompt "Note")
[ -z "$note" ] && exit 0

mkdir -p "$(dirname "$DAILY_FILE")"
echo "- $(date +%Y-%m-%d): $note" >>"$DAILY_FILE"
notify-send "Note added" "Saved to scratch.md" 2>/dev/null || true
