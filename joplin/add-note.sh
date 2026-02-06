#!/usr/bin/env bash

JOPLIN="/home/f0ld/.npm-global/bin/joplin"
TOKEN=$(cat ~/wofi/joplin-token)
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
