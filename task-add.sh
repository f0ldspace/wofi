#!/usr/bin/env bash

description=$(echo "" | wofi --dmenu --prompt "Task")
[ -z "$description" ] && exit 0

project=$(echo "" | wofi --dmenu --prompt "Project (optional)")

due=$(echo "" | wofi --dmenu --prompt "Due (optional)")

cmd=(task add "$description")
[ -n "$project" ] && cmd+=(project:"$project")
[ -n "$due" ] && cmd+=(due:"$due")
"${cmd[@]}"

notify-send "Task added" "$description"

task sync

notify-send "Taskwarrior" "Sync completed"
