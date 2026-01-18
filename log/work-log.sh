#!/usr/bin/env bash

WORK_LOG="$HOME/work/work-2026.csv"

date=$(echo "$(date +%Y-%m-%d)" | wofi --dmenu --prompt "Date")
[ -z "$date" ] && exit 0

rating=$(printf '%s\n' 10 9 8 7 6 5 4 3 2 1 | wofi --dmenu --prompt "Rating")
[ -z "$rating" ] && exit 0

sleep=$(printf '%s\n' Great Good Bad Terrible | wofi --dmenu --prompt "Sleep")
[ -z "$sleep" ] && exit 0

caffeine=$(printf '%s\n' 50 100 150 200 | wofi --dmenu --prompt "Caffeine")
[ -z "$caffeine" ] && exit 0

diet=$(printf '%s\n' junk ok good great | wofi --dmenu --prompt "Diet")
[ -z "$diet" ] && exit 0

exercise=$(printf '%s\n' 0 10 15 30 60 | wofi --dmenu --prompt "Exercise")
[ -z "$exercise" ] && exit 0

exercise_type=$(printf '%s\n' weights hiking running boxing n/a | wofi --dmenu --prompt "Exercise Type")
[ -z "$exercise_type" ] && exit 0

stress=$(printf '%s\n' 0 1 2 3 4 5 6 7 8 9 10 | wofi --dmenu --prompt "Stress")
[ -z "$stress" ] && exit 0

outdoors=$(printf '%s\n' 0 5 10 15 30 45 60 | wofi --dmenu --prompt "Outdoors")
[ -z "$outdoors" ] && exit 0

focus=$(printf '%s\n' scattered shallow good deep | wofi --dmenu --prompt "focus")
[ -z "$focus" ] && exit 0

social=$(printf '%s\n' none some lots maximum | wofi --dmenu --prompt "Social")
[ -z "$social" ] && exit 0

echo "$date,$rating,$sleep,$caffeine,$diet,$exercise,$exercise_type,$stress,$outdoors,$focus,$social" >>"$WORK_LOG"
notify-send "Book logged" "$date" 2>/dev/null || true
