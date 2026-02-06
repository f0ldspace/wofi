#!/usr/bin/env bash

# Uses wttr.in for weather data - no API key needed
# Set your default location here or leave empty to auto-detect
DEFAULT_LOCATION=""

location=$(echo "$DEFAULT_LOCATION" | wofi --dmenu --prompt "Location")
[ -z "$location" ] && location="$DEFAULT_LOCATION"

notify-send "Weather" "Fetching weather data..."

# Get compact weather data
weather=$(curl -sf "wttr.in/${location}?format=%l:+%c+%C+%t+(%f)+%h+humidity+%w+wind" 2>/dev/null)

if [ -z "$weather" ]; then
  notify-send "Weather" "Failed to fetch weather data"
  exit 1
fi

# Get forecast summary
forecast=$(curl -sf "wttr.in/${location}?format=%l\n\nNow:+%c+%t+(%f)\nCondition:+%C\nHumidity:+%h\nWind:+%w\nPrecip:+%p\n\nToday:+%S+sunrise,+%s+sunset" 2>/dev/null)

notify-send "Weather" "$forecast" -t 15000
