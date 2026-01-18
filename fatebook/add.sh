#!/usr/bin/env bash

API_KEY_FILE="$HOME/.config/fatebook/api_key"

if [ ! -f "$API_KEY_FILE" ]; then
  notify-send "Fatebook Error" "API key not found. Create $API_KEY_FILE with your key from fatebook.io/api-setup"
  exit 1
fi

API_KEY=$(cat "$API_KEY_FILE")

title=$(echo "" | wofi --dmenu --prompt "Prediction")
[ -z "$title" ] && exit 0

probability=$(echo "" | wofi --dmenu --prompt "Probability (0-100)")
[ -z "$probability" ] && exit 0

if ! [[ "$probability" =~ ^[0-9]+$ ]] || [ "$probability" -lt 0 ] || [ "$probability" -gt 100 ]; then
  notify-send "Fatebook Error" "Probability must be 0-100"
  exit 1
fi

forecast=$(awk "BEGIN {printf \"%.2f\", $probability / 100}")

default_date=$(date -d "+30 days" +%Y-%m-%d)
resolve_date=$(echo "$default_date" | wofi --dmenu --prompt "Resolve by (YYYY-MM-DD)")
[ -z "$resolve_date" ] && exit 0

urlencode() {
  local string="$1"
  local strlen=${#string}
  local encoded=""
  local pos c o
  for ((pos = 0; pos < strlen; pos++)); do
    c=${string:$pos:1}
    case "$c" in
      [-_.~a-zA-Z0-9]) o="$c" ;;
      *) printf -v o '%%%02X' "'$c" ;;
    esac
    encoded+="$o"
  done
  echo "$encoded"
}

encoded_title=$(urlencode "$title")
url="https://fatebook.io/api/v0/createQuestion?apiKey=${API_KEY}&title=${encoded_title}&resolveBy=${resolve_date}&forecast=${forecast}"

response=$(curl -s -X POST "$url")

if echo "$response" | grep -q '"url"'; then
  notify-send "Prediction added" "$title @ ${probability}%"
else
  notify-send "Fatebook Error" "Failed to create prediction"
fi
