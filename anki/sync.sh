#!/usr/bin/env bash

ANKI_API="http://localhost:8765"

if ! curl -s --connect-timeout 2 "$ANKI_API" -X POST \
  -d '{"action": "version", "version": 6}' | grep -q result; then
  notify-send "Anki" "AnkiConnect not available. Is Anki running?"
  exit 1
fi

response=$(curl -s "$ANKI_API" -X POST \
  -d '{"action": "sync", "version": 6}')

#if echo "$response" | jq -e '.error == null' >/dev/null 2>&1; then
#  notify-send "Anki" "Sync complete"
#else
#  error=$(echo "$response" | jq -r '.error // "Unknown error"')
#  notify-send "Anki" "Sync failed: $error"
#fi
