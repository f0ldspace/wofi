#!/usr/bin/env bash
cd ~/blog && nix-shell --run "./stats-update.sh"
notify-send "Stats have been updated"
cd ~/blog && git add _data/ && git commit -m "bump" && git push
notify-send "Stats have been pushed to remote"
