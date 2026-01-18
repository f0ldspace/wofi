#!/usr/bin/env bash

JOPLIN="/home/f0ld/.npm-global/bin/joplin"

entries=$($JOPLIN ls -l | awk '{id=$1; $1=""; $2=""; $3=""; title=substr($0,4); gsub(/^[ \t]+/, "", title); print id " | " title}')

selected=$(echo "$entries" | wofi --dmenu --prompt "Joplin" --matching fuzzy)
[ -z "$selected" ] && exit 0

note_id=$(echo "$selected" | cut -d'|' -f1 | xargs)

EDITOR=trinity alacritty -e $JOPLIN edit "$note_id"
$JOPLIN sync
