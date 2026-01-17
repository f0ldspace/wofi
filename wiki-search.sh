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
    # trim preview if too long
    preview="${preview:0:60}"
    printf "%s | %s\n" "$filename" "$preview"
  done
}

selected=$(generate_entries | wofi --dmenu --prompt "Wiki" --matching fuzzy)

[ -z "$selected" ] && exit 0

filename=$(echo "$selected" | cut -d'|' -f1 | xargs)

# NOTE: change for other editors
if [ -f "$WIKI_DIR/$filename.md" ]; then
  alacritty -e trinity "$WIKI_DIR/$filename.md"
fi
