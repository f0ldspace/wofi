#!/usr/bin/env bash

SCRIPTS_DIR="$HOME/wofi"

list_scripts() {
  for script in "$SCRIPTS_DIR"/*.sh; do
    [ -f "$script" ] || continue
    name=$(basename "$script" .sh)
    [ "$name" = "launcher" ] && continue
    echo "$name"
  done
}

selected=$(list_scripts | wofi --dmenu --prompt "Run")

[ -z "$selected" ] && exit 0

script="$SCRIPTS_DIR/$selected.sh"
[ -x "$script" ] && exec "$script"
