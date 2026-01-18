#!/usr/bin/env bash

SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"

selected=$(ls -t "$SCREENSHOTS_DIR" 2>/dev/null | wofi --dmenu --prompt "Screenshot" --matching fuzzy)

[ -z "$selected" ] && exit 0

satty --filename "$SCREENSHOTS_DIR/$selected"
