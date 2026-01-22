#!/usr/bin/env bash

JOPLIN="/home/f0ld/.npm-global/bin/joplin"
TOKEN="9c682d3ff36c405466d6f6c6c9e013c40081178a5e059334a31e64545d43dc390cd9e205fd779c59adc4df3cef88e0c34b8b983875cccc517f014c012e2b8361"
API="http://localhost:41184"

entries=$(curl -s "$API/notes?fields=id,title&limit=100&token=$TOKEN" | jq -r '.items[] | "\(.id)\t\(.title)"')
titles=$(echo "$entries" | cut -f2)

selected=$(echo "$titles" | wofi --dmenu --prompt "Joplin" --matching fuzzy)
[ -z "$selected" ] && exit 0

note_id=$(echo "$entries" | grep -F $'\t'"$selected" | head -1 | cut -f1)

tmp=$(mktemp --suffix=.md)
curl -s "$API/notes/$note_id?fields=body&token=$TOKEN" | jq -r '.body' >"$tmp"

alacritty -e trinity "$tmp"

curl -s -X PUT "$API/notes/$note_id?token=$TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"body\": $(jq -Rs . <"$tmp")}"

rm "$tmp"
$JOPLIN sync &
