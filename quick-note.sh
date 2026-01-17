#!/usr/bin/env bash

SCRATCH_FILE="$HOME/wiki/scratch.md"

note=$(echo "" | wofi --dmenu --prompt "Note")
[ -z "$note" ] && exit 0

mkdir -p "$(dirname "$SCRATCH_FILE")"
echo "- $note" >> "$SCRATCH_FILE"
notify-send "Note added" "Saved to scratch.md" 2>/dev/null || true
