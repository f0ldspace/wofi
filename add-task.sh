#!/usr/bin/env bash

task=$(echo "" | wofi --dmenu --prompt "Task (*label +project due !pri)")
[ -z "$task" ] && exit 0

if cria --quick "$task" 2>/dev/null; then
    notify-send "Task added" "$task" 2>/dev/null || true
else
    notify-send "Failed" "Could not add task" 2>/dev/null || true
fi
