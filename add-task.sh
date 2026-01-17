#!/usr/bin/env bash

JOPLIN="/home/f0ld/.npm-global/bin/joplin"

title=$(echo "" | wofi --dmenu --prompt "Todo name")
[ -z "$title" ] && exit 0

$JOPLIN mktodo "$title" || exit 1

extra=$(echo "" | wofi --dmenu --prompt "Extra?")
[ -n "$extra" ] && $JOPLIN set "$title" body "$extra"

notify-send "Todo added" "$title"
