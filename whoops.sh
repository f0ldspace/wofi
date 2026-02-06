#!/usr/bin/env bash

count=$(echo "1" | wofi --dmenu --prompt "Delete how many recent entries?")
[ -z "$count" ] && exit 0

if ! [[ "$count" =~ ^[1-9][0-9]*$ ]]; then
  notify-send "Whoops" "Invalid number: $count"
  exit 1
fi

deleted=0
cliphist list | head -n "$count" | while IFS= read -r line; do
  echo "$line" | cliphist delete
  ((deleted++))
done

notify-send "Whoops" "Deleted $count clipboard entries"
