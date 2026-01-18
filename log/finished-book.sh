#!/usr/bin/env bash

BOOK_LOG="$HOME/blog/_data/reading-2026.csv"

date=$(echo "$(date +%Y-%m-%d)" | wofi --dmenu --prompt "Date")
[ -z "$date" ] && exit 0

title=$(echo "" | wofi --dmenu --prompt "Title")
[ -z "$title" ] && exit 0

rating=$(printf '%s\n' 10 9 8 7 6 5 4 3 2 1 | wofi --dmenu --prompt "Rating")
[ -z "$rating" ] && exit 0

category=$(printf '%s\n' Religion Technology Politics Sci-fi Finance | wofi --dmenu --prompt "Category")
[ -z "$category" ] && exit 0

case "$category" in
Religion)
  subcategory=$(printf '%s\n' Buddhism Christianity Catholic "" | wofi --dmenu --prompt "Subcategory")
  ;;
Technology)
  subcategory=$(printf '%s\n' AI Crypto "" | wofi --dmenu --prompt "Subcategory")
  ;;
Politics)
  subcategory=$(printf '%s\n' Rationalist Capitalism Altruism "" | wofi --dmenu --prompt "Subcategory")
  ;;
*)
  subcategory=$(echo "" | wofi --dmenu --prompt "Subcategory")
  ;;
esac
[ -z "$subcategory" ] && subcategory=""

type=$(printf '%s\n' Non-Fiction Fiction | wofi --dmenu --prompt "Type")
[ -z "$type" ] && exit 0

format=$(printf '%s\n' Audiobook Digital Physical | wofi --dmenu --prompt "Format")
[ -z "$format" ] && exit 0

review=$(echo "" | wofi --dmenu --prompt "Review")

echo "$date,\"$title\",$rating,$category,$subcategory,$type,$format,\"$review\"" >>"$BOOK_LOG"
notify-send "Book logged" "$title" 2>/dev/null || true
