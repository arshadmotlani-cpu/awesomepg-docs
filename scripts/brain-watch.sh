#!/usr/bin/env bash
# Watch vault and run brain-sync on every change (Mac: requires fswatch).
set -euo pipefail

VAULT="/Users/aashumotlani/awesomepg/docs"
SYNC="$VAULT/scripts/brain-sync.sh"

if ! command -v fswatch >/dev/null 2>&1; then
  echo "[brain-watch] fswatch not found. Install: brew install fswatch" >&2
  exit 1
fi

chmod +x "$SYNC"
echo "[brain-watch] Watching $VAULT (Ctrl+C to stop)"

fswatch -0 -l 2 \
  --exclude '\.git/' \
  --exclude '\.obsidian/' \
  --exclude '\.auto-sync\.lock' \
  "$VAULT" | while IFS= read -r -d '' _; do
  "$SYNC" || true
done
