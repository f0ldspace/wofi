#!/usr/bin/env bash

notify-send "Speedtest" "Testing internet speed..."

if ! command -v speedtest-cli &>/dev/null; then
  notify-send "Speedtest" "speedtest-cli not installed"
  exit 1
fi

result=$(speedtest-cli --simple 2>&1)

if [ $? -ne 0 ]; then
  notify-send "Speedtest" "Test failed: $result"
  exit 1
fi

ping=$(echo "$result" | grep "Ping:" | awk '{print $2, $3}')
down=$(echo "$result" | grep "Download:" | awk '{print $2, $3}')
up=$(echo "$result" | grep "Upload:" | awk '{print $2, $3}')

notify-send "Speedtest Results" "Ping: $ping
Down: $down
Up: $up"
