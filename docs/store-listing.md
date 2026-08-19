# Chrome Web Store listing copy

Paste into the Developer Dashboard fields. The detailed description is plain
text (the store renders no markdown), so it is written to read well unstyled.

## Item name (45 char limit)

LDS Key Companion

## Summary (132 char limit)

Adds the musical key beside every Camelot code on LiveDJService — 8A / Am, 10B / D. No more translating in your head.

## Category

Suggested: "Workflow & Planning" (alternative: "Tools")

## Detailed description

Live DJ Service (LDS) labels every track with a Camelot code and nothing else.
If you think in musical keys — or your other gear does — that means translating
in your head, on every row, while you dig.

LDS Key Companion puts the key right next to the code:

    8A / Am        10B / D        3B / Db

That's it. No settings to configure, no account, no workflow to learn. Open the
site and the keys are simply there.

WHERE IT WORKS

The key appears anywhere LDS shows a Camelot code — search results, crate and
folder listings, and download history — including rows that load as you scroll.

NOTATION

Keys use standard Mixed In Key spellings, the same ones you already see in
Mixed In Key, Serato, and Rekordbox: flats throughout (Db, Eb, Ab, Bb) with F#
as the one sharp, minor keys on the A wheel and major on the B wheel. So 8A
reads as Am, 8B as C, 12A as Dbm.

PRIVACY

The extension reads the key codes already displayed on the page and writes the
matching key beside them. That is the entire behavior. It collects nothing,
stores nothing, sends nothing anywhere, and requests no permissions beyond
running on livedjservice.com. There is no analytics, no account, and no network
request of any kind.

The full source is public, so you can verify every word of that:
https://github.com/anthonyd43/livedjservice-key-companion

Not affiliated with, endorsed by, or sponsored by LiveDJService.com.

## Privacy tab answers

Single purpose description:
This extension has one function: on livedjservice.com track listings, it reads
the Camelot key code already displayed for each track (for example 8A) and shows
the equivalent musical key beside it (8A / Am). Camelot codes and musical keys
are two notations for the same thing, so this is purely a display convenience for
DJs who read keys rather than Camelot numbers. The extension does nothing else —
no downloading, no account interaction, no modification of site behavior.

Host permission justification:
The extension needs to run a content script on livedjservice.com because that is
the only site whose track listings display Camelot codes, and the codes must be
read from the rendered page in order to annotate them in place. The script reads
the text of elements containing a Camelot code and appends the corresponding
musical key next to it. No data is collected, stored, or transmitted, and no
other site is accessed. The match pattern is limited to livedjservice.com
precisely because no broader access is needed.

Are you using remote code?
NO. Select "No, I am not using remote code." Verified: content.js contains no
eval(), no new Function(), no dynamic import(), no fetch/XHR, no injected script
tags, and no external URLs. All code ships inside the package.

Data usage:
Check nothing. Certify that the extension does not collect or use user data.
