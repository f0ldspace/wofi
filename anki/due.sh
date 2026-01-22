#!/usr/bin/env bash

ANKI_API="http://localhost:8765"

# Check AnkiConnect is reachable
if ! curl -s --connect-timeout 2 "$ANKI_API" -X POST \
  -d '{"action": "version", "version": 6}' | grep -q result; then
  notify-send "Anki" "AnkiConnect not available. Is Anki running?"
  exit 1
fi

# Get all deck names
decks=$(curl -s "$ANKI_API" -X POST \
  -d '{"action": "deckNames", "version": 6}' | jq -r '.result[]')

# Build list with due counts
output=""
total_due=0

while IFS= read -r deck; do
  [ -z "$deck" ] && continue

  # Escape deck name for query
  escaped_deck=$(printf '%s' "$deck" | sed 's/"/\\"/g')

  # Get due count for this deck
  due=$(curl -s "$ANKI_API" -X POST \
    -d "{\"action\": \"findCards\", \"version\": 6, \"params\": {\"query\": \"deck:\\\"$escaped_deck\\\" is:due\"}}" | jq '.result | length')

  total_due=$((total_due + due))

  if [ "$due" -gt 0 ]; then
    output+="$deck: $due due\n"
  fi
done <<< "$decks"

# Add total at top
if [ -z "$output" ]; then
  output="No cards due!"
else
  output="TOTAL: $total_due due\n---\n$output"
fi

# Display in wofi
echo -e "$output" | wofi --dmenu --prompt "Due Cards" --cache-file /dev/null
