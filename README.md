# wofi scripts

Personal collection of wofi scripts for quick actions. Run `launcher.sh` to browse and execute them.

## What's here

**Root scripts:**
- `rng` - fate decision maker with history and presets
- `scratch` - quick append to scratch note
- `task-add` - add a task
- `tweet` - post a tweet
- `wakapi-start` - start wakapi time tracking
- `wakapi-stop` - stop wakapi time tracking
- `whoops` - delete clipboard history entries
- `wiki-append` - add text to a wiki note
- `wiki-create` - create a new wiki page

**anki/** - flashcard stuff via AnkiConnect
- `add` - create a card
- `clipboard` - create card with clipboard as back
- `due` - check due cards
- `stats` - view stats
- `sync` - sync anki

**fatebook/** - prediction tracking
- `add` - make a prediction
- `list` - view predictions

**log/** - personal tracking
- `day-summary` - quick daily summary
- `finished-book` - log a book you finished
- `work-log` - daily wellness log (sleep, caffeine, stress, etc)

**tools/** - random utilities
- `satty` - browse and edit recent screenshots with satty
- `speedtest` - test internet speed using speedtest-cli
- `stats-update` - update blog stats and push changes
- `weather` - fetch weather data using wttr.in

## Requirements

- wofi
- jq
- curl
- notify-send
- cliphist (for whoops script)
- For anki scripts: Anki with AnkiConnect addon
- For fatebook: API key in `~/.config/fatebook/api_key`

---

*README.md written by Mistral Vibe* (devstral-2)
