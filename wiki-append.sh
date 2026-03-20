#!/usr/bin/env bash

WIKI_DIR="$HOME/wiki"

entries=""
while IFS= read -r -d '' f; do
  [ -f "$f" ] || continue
  relpath="${f#$WIKI_DIR/}"
  title=$(grep -m1 '^# ' "$f" | sed 's/^# //')
  [ -z "$title" ] && title="$relpath"
  entries+="$relpath	$title"$'\n'
done < <(find "$WIKI_DIR" -type f -name '*.md' -print0 | sort -z)

titles=$(echo -n "$entries" | cut -f2)

selected=$(echo "$titles" | wofi --dmenu --prompt "Wiki note" --matching fuzzy)
[ -z "$selected" ] && exit 0

filepath=$(echo -n "$entries" | grep -F $'\t'"$selected" | head -1 | cut -f1)
filepath="$WIKI_DIR/$filepath"

if [ ! -f "$filepath" ]; then
  notify-send "Wiki" "Note not found"
  exit 1
fi

text=$(echo "" | wofi --dmenu --prompt "Append text")
[ -z "$text" ] && exit 0

echo "" >>"$filepath"
echo "## $text" >>"$filepath"

notify-send "Wiki" "Appended to $selected"
