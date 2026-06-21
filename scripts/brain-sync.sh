#!/usr/bin/env bash
# Brain sync — commit + push vault after memory updates. Safe no-op if unchanged.
set -euo pipefail

VAULT="/Users/aashumotlani/awesomepg/docs"
LOCK="$VAULT/.auto-sync.lock"
cd "$VAULT"

if [[ -f "$LOCK" ]]; then
  exit 0
fi
touch "$LOCK"
trap 'rm -f "$LOCK"' EXIT

git add .

if git diff --cached --quiet; then
  exit 0
fi

git commit -m "brain: auto memory sync"

if git remote get-url origin >/dev/null 2>&1; then
  git push origin HEAD
  echo "[brain-sync] Committed and pushed"
else
  echo "[brain-sync] Committed (no origin remote configured)"
fi
