#!/usr/bin/env bash

JOPLIN="/home/f0ld/.npm-global/bin/joplin"
TOKEN="9c682d3ff36c405466d6f6c6c9e013c40081178a5e059334a31e64545d43dc390cd9e205fd779c59adc4df3cef88e0c34b8b983875cccc517f014c012e2b8361"
API="http://localhost:41184"

FOLDER_ID=$(curl -s "$API/search?query=scratch&type=folder&fields=id&token=$TOKEN" | jq -r '.items[0].id')

title=$(echo "" | wofi --dmenu --prompt "Todo name")
[ -z "$title" ] && exit 0

extra=$(echo "" | wofi --dmenu --prompt "Extra?")

curl -s -X POST "$API/notes?token=$TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"title\": \"$title\", \"body\": \"$extra\", \"is_todo\": 0, \"parent_id\": \"$FOLDER_ID\"}"

notify-send "Todo added" "$title"
$JOPLIN sync
notify-send "Joplin" "Changes synced to remote"
