# Camelot Key Companion for LiveDJService

Chrome extension that shows the musical key next to every Camelot code on
[livedjservice.com](https://livedjservice.com) — the key column reads `1B B`,
`8A Am`, `12A Dbm`, etc. Uses Mixed In Key spellings (flats except `F#`).

Works on every page with a track list (search results, folder listings,
download history), including rows loaded by infinite scroll. Everything runs
locally in your browser; no data is sent anywhere.

## Install (load unpacked)

1. Open `chrome://extensions` in Chrome.
2. Turn on **Developer mode** (top right).
3. Click **Load unpacked** and select this folder.
4. Reload any open livedjservice.com tabs.

## How it works

A content script matches leaf elements whose entire text is a Camelot code
(`1A`–`12B`) and appends a dimmed `<span>` with the corresponding key. A
`MutationObserver` re-scans when the site inserts new rows. Because it matches
by text pattern rather than site markup, it keeps working across site
redesigns.

## Test

Open `test/fixture.html` over HTTP (e.g. `python3 -m http.server`) — it mimics
the track list, includes decoy values (`13A`, a title containing `12B`), and
inserts a row dynamically to exercise the observer.
