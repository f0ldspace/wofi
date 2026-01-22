#!/usr/bin/env bash

JOPLIN="/home/f0ld/.npm-global/bin/joplin"
TOKEN="9c682d3ff36c405466d6f6c6c9e013c40081178a5e059334a31e64545d43dc390cd9e205fd779c59adc4df3cef88e0c34b8b983875cccc517f014c012e2b8361"
API="http://localhost:41184"

# Get scratch folder ID
FOLDER_ID=$(curl -s "$API/search?query=scratch&type=folder&fields=id&token=$TOKEN" | jq -r '.items[0].id')

[ -z "$FOLDER_ID" ] || [ "$FOLDER_ID" = "null" ] && notify-send "Joplin" "Folder 'scratch' not found" && exit 1

# Fetch all incomplete todos from folder (with pagination)
entries=""
page=1
while true; do
  response=$(curl -s "$API/folders/$FOLDER_ID/notes?fields=id,title,is_todo,todo_completed&limit=100&page=$page&token=$TOKEN")

  # Filter incomplete todos and append
  page_entries=$(echo "$response" | jq -r '.items[] | select(.is_todo == 1 and .todo_completed == 0) | "\(.id)\t\(.title)"')
  [ -n "$page_entries" ] && entries="$entries$page_entries"$'\n'

  # Check if more pages
  has_more=$(echo "$response" | jq -r '.has_more')
  [ "$has_more" != "true" ] && break
  ((page++))
done

entries=$(echo "$entries" | sed '/^$/d')

[ -z "$entries" ] && notify-send "Joplin" "No incomplete todos" && exit 0

titles=$(echo "$entries" | cut -f2)

selected=$(echo "$titles" | wofi --dmenu --prompt "Complete TODO" --matching fuzzy)
[ -z "$selected" ] && exit 0

note_id=$(echo "$entries" | grep -F $'\t'"$selected" | head -1 | cut -f1)

# Mark as complete (timestamp in ms)
curl -s -X PUT "$API/notes/$note_id?token=$TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"todo_completed\": $(date +%s)000}"

notify-send "Joplin" "Completed: $selected"

$JOPLIN sync &
