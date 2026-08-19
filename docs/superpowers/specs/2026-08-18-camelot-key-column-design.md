# LDS Key Companion — Design

**Date:** 2026-08-18
**Status:** Approved

## Purpose

LiveDJService.com lists track keys only as Camelot codes (`1A`–`12B`). This Chrome
extension displays the corresponding musical key beside every Camelot code so the
key column reads e.g. `1B  B`, `8A  Am`.

## Decisions (confirmed with user)

- **Key format:** short form (`Am`, `Ab`, `F#m`) — compact, DJ-software style.
- **Notation:** Mixed In Key spellings (`Db`, `Eb`, `Ab`, `Bb` flats; `F#` sharp; `12A → Dbm`).
- **Scope:** every page on livedjservice.com where a Camelot code appears
  (search results, folder listings, download history).

## Approach

Pattern-matching content script (chosen over exact-selector script and a
Tampermonkey userscript). The site is login-gated and its DOM couldn't be
inspected, so the extension finds Camelot codes by their text pattern rather
than site-specific selectors — robust to redesigns, covers all pages.

## Architecture

- **Manifest V3**, plain JavaScript, no build step. Content script + stylesheet
  run only on `livedjservice.com`. No extra permissions, no popup/options page.
- `content.js` holds a fixed 24-entry Camelot→key table.
- On load, a TreeWalker finds leaf elements whose trimmed text matches
  `^(1[0-2]|[1-9])[AB]$` and appends a styled `<span class="ldjs-key">` with the
  key. Annotated elements get a `data-ldjs-key` marker so nothing is
  double-labeled.
- A **MutationObserver** on `document.body` re-runs the scan (debounced via
  `requestAnimationFrame`) when the SPA inserts new rows.
- `content.css` styles the span: slightly dimmed (inherits color, reduced
  opacity, smaller size), fixed-width slot so columns stay aligned. Works in the
  site's light and dark themes because it inherits the surrounding text color.

## Camelot → key table

| Camelot | Key | Camelot | Key |
|---|---|---|---|
| 1A | Abm | 1B | B |
| 2A | Ebm | 2B | F# |
| 3A | Bbm | 3B | Db |
| 4A | Fm | 4B | Ab |
| 5A | Cm | 5B | Eb |
| 6A | Gm | 6B | Bb |
| 7A | Dm | 7B | F |
| 8A | Am | 8B | C |
| 9A | Em | 9B | G |
| 10A | Bm | 10B | D |
| 11A | F#m | 11B | A |
| 12A | Dbm | 12B | E |

## Error handling

There is no I/O and no user input; the only failure mode is a non-matching page,
which is a no-op. The marker attribute prevents duplicate annotation; the regex
requires an exact full-cell match, so BPM values, durations, and track titles are
never annotated.

## Testing

- Local HTML fixture (`test/fixture.html`) mimicking the track list, including a
  row inserted dynamically after load, exercised in a browser: verifies correct
  key mapping, no double-annotation, and MutationObserver behavior.
- Final smoke check on the live site after loading the unpacked extension.

## Deliverables

`manifest.json`, `content.js`, `content.css`, `test/fixture.html`, `README.md`
(load-unpacked instructions) in `~/Repositories/livedjservice-key-companion`.
