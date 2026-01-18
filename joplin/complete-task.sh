#!/usr/bin/env bash

JOPLIN="/home/f0ld/.npm-global/bin/joplin"

entries=$($JOPLIN ls -l -t t | grep '\[ \]' | awk '{id=$1; $1=""; $2=""; $3=""; $4=""; title=substr($0,5); gsub(/^[ \t]+/, "", title); print id " | " title}')

[ -z "$entries" ] && notify-send "Joplin" "No incomplete todos" && exit 0

selected=$(echo "$entries" | wofi --dmenu --prompt "Complete TODO" --matching fuzzy)
[ -z "$selected" ] && exit 0

note_id=$(echo "$selected" | cut -d'|' -f1 | xargs)

$JOPLIN done "$note_id"
$JOPLIN sync
