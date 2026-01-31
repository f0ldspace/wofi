#!/usr/bin/env bash

JOPLIN="/home/f0ld/.npm-global/bin/joplin"
TOKEN="9c682d3ff36c405466d6f6c6c9e013c40081178a5e059334a31e64545d43dc390cd9e205fd779c59adc4df3cef88e0c34b8b983875cccc517f014c012e2b8361"
API="http://localhost:41184"

text=$(echo "" | wofi --dmenu --prompt "Append to scratch")
[ -z "$text" ] && exit 0

note_id=$(curl -s "$API/search?query=scratch%20notebook:scratch&type=note&fields=id&token=$TOKEN" | jq -r '.items[0].id')

if [ -z "$note_id" ] || [ "$note_id" = "null" ]; then
  notify-send "Joplin" "Could not find scratch note"
  exit 1
fi

body=$(curl -s "$API/notes/$note_id?fields=body&token=$TOKEN" | jq -r '.body')
new_body="${body}
${text}"

curl -s -X PUT "$API/notes/$note_id?token=$TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"body\": $(echo "$new_body" | jq -Rs .)}"

notify-send "Joplin" "Appended to scratch"
$JOPLIN sync &
