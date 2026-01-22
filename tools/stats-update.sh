#!/usr/bin/env bash
cd ~/blog && nix-shell --run "./anki.sh && ./anki-all.sh && ./wakapi.sh && python _scripts/generate-fatebook-stats.py"
