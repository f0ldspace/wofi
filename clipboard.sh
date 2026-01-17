#!/usr/bin/env bash
# NOTE:, needs gpaste, GNOME

selected=$(gpaste-client history --oneline | cut -d':' -f2- | nl -v0 -w1 -s': ' | wofi --dmenu --prompt "Clipboard")
[ -n "$selected" ] && gpaste-client select "$(echo "$selected" | cut -d':' -f1)"
