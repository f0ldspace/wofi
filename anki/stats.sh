#!/usr/bin/env bash

ANKI_API="http://localhost:8765"

if ! curl -s --connect-timeout 2 "$ANKI_API" -X POST \
  -d '{"action": "version", "version": 6}' | grep -q result; then
  notify-send "Anki" "AnkiConnect not available. Is Anki running?"
  exit 1
fi

reviewed=$(curl -s "$ANKI_API" -X POST \
  -d '{"action": "getNumCardsReviewedToday", "version": 6}' | jq -r '.result // 0')

stats=$(curl -s "$ANKI_API" -X POST \
  -d '{"action": "getCollectionStatsHTML", "version": 6}' | jq -r '.result // ""')

total=$(curl -s "$ANKI_API" -X POST \
  -d '{"action": "findCards", "version": 6, "params": {"query": "deck:*"}}' | jq '.result | length')

due=$(curl -s "$ANKI_API" -X POST \
  -d '{"action": "findCards", "version": 6, "params": {"query": "is:due"}}' | jq '.result | length')

new=$(curl -s "$ANKI_API" -X POST \
  -d '{"action": "findCards", "version": 6, "params": {"query": "is:new"}}' | jq '.result | length')

echo -e "Reviewed today: $reviewed\nDue now: $due\nNew cards: $new\nTotal cards: $total" |
  wofi --dmenu --prompt "Anki Stats" --cache-file /dev/null
