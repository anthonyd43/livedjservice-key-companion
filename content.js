(() => {
  "use strict";

  // Mixed In Key spellings: flats except F#, minor keys on the A wheel.
  const CAMELOT_TO_KEY = {
    "1A": "Abm", "2A": "Ebm", "3A": "Bbm", "4A": "Fm",
    "5A": "Cm", "6A": "Gm", "7A": "Dm", "8A": "Am",
    "9A": "Em", "10A": "Bm", "11A": "F#m", "12A": "Dbm",
    "1B": "B", "2B": "F#", "3B": "Db", "4B": "Ab",
    "5B": "Eb", "6B": "Bb", "7B": "F", "8B": "C",
    "9B": "G", "10B": "D", "11B": "A", "12B": "E"
  };

  const CAMELOT_RE = /^(1[0-2]|[1-9])[AB]$/;
  const MARKER = "data-ldjs-key";

  function annotate(root) {
    const walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, {
      acceptNode(node) {
        return CAMELOT_RE.test(node.nodeValue.trim())
          ? NodeFilter.FILTER_ACCEPT
          : NodeFilter.FILTER_REJECT;
      }
    });

    const matches = [];
    for (let node; (node = walker.nextNode()); ) matches.push(node);

    for (const node of matches) {
      const cell = node.parentElement;
      // Only annotate leaf cells whose entire content is the Camelot code, so
      // BPM values, durations, and titles containing digits are never touched.
      if (!cell || cell.childElementCount !== 0 || cell.hasAttribute(MARKER)) continue;

      const key = CAMELOT_TO_KEY[node.nodeValue.trim()];
      if (!key) continue;

      cell.setAttribute(MARKER, "");
      const span = document.createElement("span");
      span.className = "ldjs-key";
      span.textContent = key;
      cell.appendChild(span);
    }
  }

  let scanScheduled = false;
  function scheduleScan() {
    if (scanScheduled) return;
    scanScheduled = true;
    requestAnimationFrame(() => {
      scanScheduled = false;
      annotate(document.body);
    });
  }

  annotate(document.body);
  new MutationObserver(scheduleScan).observe(document.body, {
    childList: true,
    subtree: true
  });
})();
