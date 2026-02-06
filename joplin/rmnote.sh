#!/usr/bin/env bash

JOPLIN="/home/f0ld/.npm-global/bin/joplin"
TOKEN=$(cat ~/wofi/joplin-token)
API="http://localhost:41184"

FOLDER_ID=$(curl -s "$API/search?query=scratch&type=folder&fields=id&token=$TOKEN" | jq -r '.items[0].id')

entries=$(curl -s "$API/folders/$FOLDER_ID/notes?fields=id,title&limit=100&token=$TOKEN" | jq -r '.items[] | "\(.id)\t\(.title)"')
titles=$(echo "$entries" | cut -f2)

selected=$(echo "$titles" | wofi --dmenu --prompt "Delete note" --matching fuzzy)
[ -z "$selected" ] && exit 0

note_id=$(echo "$entries" | grep -F $'\t'"$selected" | head -1 | cut -f1)

curl -s -X DELETE "$API/notes/$note_id?token=$TOKEN"

$JOPLIN sync
notify-send "Joplin" "Changes synced to remote"
