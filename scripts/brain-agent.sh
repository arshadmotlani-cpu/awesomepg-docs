#!/usr/bin/env bash
# IDE Activity Intelligence Agent — development journal engine for /docs vault.
# Pipeline: detect → classify → MEMORY → changelog → git commit → push
set -euo pipefail

VAULT="/Users/aashumotlani/awesomepg/docs"
LOCK_FILE="$VAULT/.brain.lock"
CLASSIFY="$VAULT/scripts/brain-classify.sh"
STATE_FILE="$VAULT/.brain-last-classify"
cd "$VAULT"

echo "🧠 Brain Agent (Intelligence Layer)..."

if [[ -f "$LOCK_FILE" ]]; then
  echo "Agent already running..."
  exit 0
fi

touch "$LOCK_FILE"
trap 'rm -f "$LOCK_FILE"' EXIT

# STEP 1 — Detect change (must have real diff or untracked content)
if git diff --quiet 2>/dev/null && git diff --cached --quiet 2>/dev/null; then
  if [[ -z "$(git status --porcelain 2>/dev/null || true)" ]]; then
    echo "No changes detected."
    exit 0
  fi
fi

# STEP 2–4 — Classify + MEMORY + changelog
if [[ -x "$CLASSIFY" ]]; then
  if ! "$CLASSIFY"; then
    echo "[agent] Classifier reported no actionable changes."
    exit 0
  fi
fi

# STEP 5 — Git sync
git add -A
git reset -q HEAD -- .brain.lock .auto-sync.lock .brain-last-classify 2>/dev/null || true

if git diff --cached --quiet; then
  echo "No staged changes after intelligence pass."
  exit 0
fi

MSG="brain: memory sync"
if [[ -f "$STATE_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$STATE_FILE"
fi

git commit -m "$MSG"

if git remote get-url origin >/dev/null 2>&1; then
  git push origin HEAD
  echo "✅ Intelligence sync complete → GitHub ($MSG)"
else
  echo "⚠️  No origin remote — committed locally ($MSG)"
  echo "    Add remote: git remote add origin <url>"
  exit 0
fi
