#!/usr/bin/env bash

TOKEN="9c682d3ff36c405466d6f6c6c9e013c40081178a5e059334a31e64545d43dc390cd9e205fd779c59adc4df3cef88e0c34b8b983875cccc517f014c012e2b8361"
API="http://localhost:41184"

FOLDER_ID=$(curl -s "$API/search?query=scratch&type=folder&fields=id&token=$TOKEN" | jq -r '.items[0].id')

entries=$(curl -s "$API/folders/$FOLDER_ID/notes?fields=id,title&limit=100&token=$TOKEN" | jq -r '.items[] | "\(.id)\t\(.title)"')
titles=$(echo "$entries" | cut -f2)

selected=$(echo "$titles" | wofi --dmenu --prompt "Delete note" --matching fuzzy)
[ -z "$selected" ] && exit 0

note_id=$(echo "$entries" | grep -F $'\t'"$selected" | head -1 | cut -f1)

curl -s -X DELETE "$API/notes/$note_id?token=$TOKEN"

notify-send "Joplin" "Deleted: $selected"
