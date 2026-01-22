#!/usr/bin/env bash

WIKI_DIR="$HOME/wiki"

generate_entries() {
  for file in "$WIKI_DIR"/*.md; do
    [ -f "$file" ] || continue
    filename=$(basename "$file" .md)
    preview=$(awk '
            /^---$/ { in_front++; next }
            in_front == 1 { next }
            /^[^#]/ && NF { gsub(/^[ \t]+|[ \t]+$/, ""); print; exit }
            /^#/ { gsub(/^#+[ \t]*/, ""); print; exit }
        ' "$file")
    preview="${preview:0:60}"
    printf "%s | %s\n" "$filename" "$preview"
  done
}

entries=$(generate_entries)
selected=$(echo "$entries" | wofi --dmenu --prompt "Wiki" --matching fuzzy)

[ -z "$selected" ] && exit 0

filename=$(echo "$selected" | cut -d'|' -f1 | xargs)

# If selection matches an existing file, open it
if [ -f "$WIKI_DIR/$filename.md" ]; then
  alacritty -e trinity "$WIKI_DIR/$filename.md"
  exit 0
fi

# Otherwise treat input as a deep search query
query="$selected"
results=$(grep -rli "$query" "$WIKI_DIR"/*.md 2>/dev/null | while read -r file; do
  fname=$(basename "$file" .md)
  match=$(grep -i -m1 "$query" "$file" | head -c 60)
  printf "%s | %s\n" "$fname" "$match"
done)

[ -z "$results" ] && exit 0

selected=$(echo "$results" | wofi --dmenu --prompt "Results" --matching fuzzy)

[ -z "$selected" ] && exit 0

filename=$(echo "$selected" | cut -d'|' -f1 | xargs)

if [ -f "$WIKI_DIR/$filename.md" ]; then
  alacritty -e trinity "$WIKI_DIR/$filename.md"
fi
