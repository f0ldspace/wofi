#!/usr/bin/env bash

API_KEY_FILE="$HOME/.config/fatebook/api_key"

if ! command -v jq &>/dev/null; then
  notify-send "Fatebook Error" "jq is required. Install it first."
  exit 1
fi

if [ ! -f "$API_KEY_FILE" ]; then
  notify-send "Fatebook Error" "API key not found. Create $API_KEY_FILE with your key from fatebook.io/api-setup"
  exit 1
fi

API_KEY=$(cat "$API_KEY_FILE")

tmpfile=$(mktemp)
trap "rm -f $tmpfile" EXIT

curl -s "https://fatebook.io/api/v0/getQuestions?apiKey=${API_KEY}&unresolved=true" > "$tmpfile"

if ! jq -e '.items' "$tmpfile" &>/dev/null; then
  notify-send "Fatebook Error" "Failed to fetch predictions"
  exit 1
fi

count=$(jq '.items | length' "$tmpfile")

if [ "$count" -eq 0 ]; then
  notify-send "Fatebook" "No unresolved predictions"
  exit 0
fi

mapfile -t ids < <(jq -r '.items[].id' "$tmpfile")
mapfile -t displays < <(jq -r '.items[] | "\(.title) [\(([.forecasts[] | .forecast // empty | tonumber] | last // 0) * 100 | floor)%] - \(.resolveBy | split("T")[0])"' "$tmpfile")

menu=""
for i in "${!displays[@]}"; do
  menu+="${displays[$i]}"$'\n'
done

selected=$(echo -n "$menu" | wofi --dmenu --prompt "Resolve prediction")
[ -z "$selected" ] && exit 0

question_id=""
for i in "${!displays[@]}"; do
  if [ "${displays[$i]}" = "$selected" ]; then
    question_id="${ids[$i]}"
    break
  fi
done

if [ -z "$question_id" ]; then
  notify-send "Fatebook Error" "Could not find question ID"
  exit 1
fi

resolution=$(printf "YES\nNO\nAMBIGUOUS" | wofi --dmenu --prompt "Resolution")
[ -z "$resolution" ] && exit 0

http_code=$(curl -s -o /dev/null -w "%{http_code}" -X POST "https://fatebook.io/api/v0/resolveQuestion" \
  -H "Content-Type: application/json" \
  -d "{\"apiKey\":\"${API_KEY}\",\"questionId\":\"${question_id}\",\"resolution\":\"${resolution}\",\"questionType\":\"BINARY\"}")

if [ "$http_code" = "200" ]; then
  notify-send "Resolved" "${selected%% \[*} -> $resolution"
else
  notify-send "Fatebook Error" "Failed to resolve (HTTP $http_code)"
fi
