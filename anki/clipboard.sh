#!/usr/bin/env bash

ANKI_API="http://localhost:8765"

if ! curl -s --connect-timeout 2 "$ANKI_API" -X POST \
  -d '{"action": "version", "version": 6}' | grep -q result; then
  notify-send "Anki" "AnkiConnect not available. Is Anki running?"
  exit 1
fi

if command -v wl-paste &>/dev/null; then
  clipboard=$(wl-paste 2>/dev/null)
else
  clipboard=$(xclip -selection clipboard -o 2>/dev/null)
fi

decks=$(curl -s "$ANKI_API" -X POST \
  -d '{"action": "deckNames", "version": 6}' | jq -r '.result[]')

deck=$(echo "$decks" | wofi --dmenu --prompt "Deck" --matching fuzzy)
[ -z "$deck" ] && exit 0

front=$(echo "$clipboard" | wofi --dmenu --prompt "Front (from clipboard)")
[ -z "$front" ] && exit 0

back=$(echo "" | wofi --dmenu --prompt "Back")
[ -z "$back" ] && exit 0

front_escaped=$(printf '%s' "$front" | jq -Rs .)
back_escaped=$(printf '%s' "$back" | jq -Rs .)
deck_escaped=$(printf '%s' "$deck" | jq -Rs .)

response=$(curl -s "$ANKI_API" -X POST -d "{
  \"action\": \"addNote\",
  \"version\": 6,
  \"params\": {
    \"note\": {
      \"deckName\": $deck_escaped,
      \"modelName\": \"Basic\",
      \"fields\": {\"Front\": $front_escaped, \"Back\": $back_escaped},
      \"options\": {\"allowDuplicate\": false}
    }
  }
}")
