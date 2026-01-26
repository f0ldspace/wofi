#!/usr/bin/env bash

WIKI_DIR="$HOME/wiki"

query=$(echo "" | wofi --dmenu --prompt "Search wiki")
[ -z "$query" ] && exit 0

results=$(grep -Frli "$query" "$WIKI_DIR"/*.md 2>/dev/null | while read -r file; do
  fname=$(basename "$file" .md)
  match=$(grep -Fi -m1 "$query" "$file" | head -c 60)
  printf "%s | %s\n" "$fname" "$match"
done)

[ -z "$results" ] && notify-send "Wiki" "No results for \"$query\"" && exit 0

selected=$(echo "$results" | wofi --dmenu --prompt "Results" --matching fuzzy)
[ -z "$selected" ] && exit 0

filename=$(echo "$selected" | cut -d'|' -f1 | xargs)

if [ -f "$WIKI_DIR/$filename.md" ]; then
  alacritty -e trinity "$WIKI_DIR/$filename.md" &
  sleep 0.3
  niri msg action set-column-width -- "30%"
fi
