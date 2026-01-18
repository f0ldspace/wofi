#!/usr/bin/env bash

SCRIPTS_DIR="$HOME/wofi"

list_entries() {
  # Top-level scripts (uncategorized)
  for script in "$SCRIPTS_DIR"/*.sh; do
    [ -f "$script" ] || continue
    name=$(basename "$script" .sh)
    [ "$name" = "launcher" ] && continue
    echo "$name"
  done

  # Subdirectories (categories)
  for dir in "$SCRIPTS_DIR"/*/; do
    [ -d "$dir" ] || continue
    # Skip hidden directories
    dirname=$(basename "$dir")
    [[ "$dirname" == .* ]] && continue
    echo "$dirname/"
  done
}

list_category_scripts() {
  local category="$1"
  for script in "$SCRIPTS_DIR/$category"/*.sh; do
    [ -f "$script" ] || continue
    basename "$script" .sh
  done
}

# First level: show root scripts and categories
selected=$(list_entries | sort | wofi --dmenu --prompt "Run")
[ -z "$selected" ] && exit 0

# Check if it's a category (ends with /)
if [[ "$selected" == */ ]]; then
  category="${selected%/}"
  # Second level: show scripts in category
  script_name=$(list_category_scripts "$category" | wofi --dmenu --prompt "$category")
  [ -z "$script_name" ] && exit 0
  script="$SCRIPTS_DIR/$category/$script_name.sh"
else
  # Root-level script
  script="$SCRIPTS_DIR/$selected.sh"
fi

[ -x "$script" ] && exec "$script"
