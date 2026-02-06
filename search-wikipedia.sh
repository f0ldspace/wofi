#!/usr/bin/env bash

WIKI_API="https://en.wikipedia.org/w/api.php"
RESULT_LIMIT=15

query=$(echo "" | wofi --dmenu --prompt "Wikipedia")
[ -z "$query" ] && exit 0

encoded=$(printf '%s' "$query" | jq -sRr @uri)
response=$(curl -s "$WIKI_API?action=opensearch&search=$encoded&limit=$RESULT_LIMIT&format=json")

if [ -z "$response" ]; then
  notify-send "Wikipedia" "Search failed — check your network"
  exit 1
fi

titles=$(printf '%s' "$response" | jq -r '.[1][]')

if [ -z "$titles" ]; then
  notify-send "Wikipedia" "No results for \"$query\""
  exit 0
fi

selected=$(printf '%s\n' "$titles" | wofi --dmenu --prompt "Results" --matching fuzzy --cache-file /dev/null)
[ -z "$selected" ] && exit 0

url=$(printf '%s' "$response" | jq -r --arg title "$selected" '
  [.[1], .[3]] | transpose[] | select(.[0] == $title) | .[1]
')

if [ -z "$url" ]; then
  notify-send "Wikipedia" "Could not resolve URL"
  exit 1
fi

wike --url "$url" &
