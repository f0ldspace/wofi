#!/usr/bin/env bash

SCRIPTS_DIR="$HOME/wofi"

list_entries() {
  for script in "$SCRIPTS_DIR"/*.sh; do
    [ -f "$script" ] || continue
    name=$(basename "$script" .sh)
    [ "$name" = "launcher" ] && continue
    echo "$name"
  done

  for dir in "$SCRIPTS_DIR"/*/; do
    [ -d "$dir" ] || continue
    dirname=$(basename "$dir")
    [[ "$dirname" == .* ]] && continue
    echo "$dirname/"
  done

  echo "================================================"

  for dir in "$SCRIPTS_DIR"/*/; do
    [ -d "$dir" ] || continue
    dirname=$(basename "$dir")
    [[ "$dirname" == .* ]] && continue
    for script in "$dir"*.sh; do
      [ -f "$script" ] || continue
      echo "$dirname/$(basename "$script" .sh)"
    done
  done
}

list_category_scripts() {
  local category="$1"
  for script in "$SCRIPTS_DIR/$category"/*.sh; do
    [ -f "$script" ] || continue
    basename "$script" .sh
  done
}

selected=$(list_entries | wofi --dmenu --prompt "Run")

[ -z "$selected" ] && exit 0

[[ "$selected" == ────* ]] && exit 0

if [[ "$selected" == */ ]]; then
  category="${selected%/}"
  script_name=$(list_category_scripts "$category" | wofi --dmenu --prompt "$category")
  [ -z "$script_name" ] && exit 0
  script="$SCRIPTS_DIR/$category/$script_name.sh"
elif [[ "$selected" == */* ]]; then
  script="$SCRIPTS_DIR/$selected.sh"
else
  script="$SCRIPTS_DIR/$selected.sh"
fi

[ -x "$script" ] && exec "$script"
