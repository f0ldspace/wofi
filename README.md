# wofi scripts

Personal collection of wofi scripts for quick actions. Run `launcher.sh` to browse and execute them.

## What's here

**Root scripts:**
- `scratch` - quick append to joplin scratch note
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

**joplin/** - note management
- `add-note` - new note
- `open` - open a note
- `rmnote` - delete a note

**log/** - personal tracking
- `day-summary` - quick daily summary
- `finished-book` - log a book you finished
- `work-log` - daily wellness log (sleep, caffeine, stress, etc)

**tools/** - random utilities
- `satty` - screenshot tool
- `speedtest` - test internet speed
- `stats-update` - update stats

## Requirements

- wofi
- jq
- curl
- notify-send
- For anki scripts: Anki with AnkiConnect addon
- For joplin scripts: Joplin CLI + API token in `joplin-token`
- For fatebook: API key in `~/.config/fatebook/api_key`
