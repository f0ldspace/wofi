#!/usr/bin/env bash

JOPLIN="/home/f0ld/.npm-global/bin/joplin"

title=$(echo "" | wofi --dmenu --prompt "Todo name")
[ -z "$title" ] && exit 0

extra=$(echo "" | wofi --dmenu --prompt "Extra?")

$JOPLIN mktodo "$title" || exit 1
[ -n "$extra" ] && $JOPLIN set "$title" body "$extra"

notify-send "Todo added" "$title"
