#!/bin/bash
# Convert a screenshot to Chrome Web Store spec: 1280x800, 24-bit, no alpha.
#
# Usage: tools/make-store-screenshot.sh <input-image> [output-dir]
#
# Produces two options so you can pick whichever looks better:
#   *-fit.png   whole screenshot, scaled to fit, side bars in the site's dark grey
#   *-fill.png  scaled to full width and centre-cropped to 800px (fills the frame)

set -euo pipefail

IN="${1:?usage: make-store-screenshot.sh <input-image> [output-dir]}"
OUTDIR="${2:-$(dirname "$IN")}"
BASE="$(basename "${IN%.*}")"
PAD_COLOR="16151A" # matches the LDS dark background

[ -f "$IN" ] || { echo "No such file: $IN" >&2; exit 1; }
mkdir -p "$OUTDIR"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# --- fit: preserve the entire screenshot, pad the sides ---
cp "$IN" "$TMP/fit.png"
sips --resampleHeight 800 "$TMP/fit.png" >/dev/null
sips --padToHeightWidth 800 1280 --padColor "$PAD_COLOR" "$TMP/fit.png" >/dev/null

# --- fill: full width, centre-cropped vertically ---
cp "$IN" "$TMP/fill.png"
sips --resampleWidth 1280 "$TMP/fill.png" >/dev/null
sips --cropToHeightWidth 800 1280 "$TMP/fill.png" >/dev/null

# Strip the alpha channel (macOS screenshots carry one; the store rejects it).
# Round-tripping through JPEG is the only reliable way to do this with sips.
for v in fit fill; do
  sips -s format jpeg -s formatOptions best "$TMP/$v.png" --out "$TMP/$v.jpg" >/dev/null
  sips -s format png "$TMP/$v.jpg" --out "$OUTDIR/$BASE-$v.png" >/dev/null
  rm -f "$TMP/$v.jpg"
done

# --- verify against the store's requirements ---
FAIL=0
for v in fit fill; do
  F="$OUTDIR/$BASE-$v.png"
  W=$(sips -g pixelWidth "$F" | awk '/pixelWidth/{print $2}')
  H=$(sips -g pixelHeight "$F" | awk '/pixelHeight/{print $2}')
  A=$(sips -g hasAlpha "$F" | awk '/hasAlpha/{print $2}')
  D=$(sips -g bitsPerSample "$F" | awk '/bitsPerSample/{print $2}')
  S=$(sips -g samplesPerPixel "$F" | awk '/samplesPerPixel/{print $2}')
  if [ "$W" = 1280 ] && [ "$H" = 800 ] && [ "$A" = "no" ] && [ "$D" = 8 ] && [ "$S" = 3 ]; then
    echo "OK   $F  ${W}x${H}, ${D}-bit x${S} channels, alpha: $A"
  else
    echo "FAIL $F  ${W}x${H}, ${D}-bit x${S} channels, alpha: $A"
    FAIL=1
  fi
done
exit $FAIL
