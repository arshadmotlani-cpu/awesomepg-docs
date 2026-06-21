#!/usr/bin/env bash
# Autonomous Memory Agent — classify → MEMORY/ → commit → push
set -euo pipefail

VAULT="/Users/aashumotlani/awesomepg/docs"
LOCK_FILE="$VAULT/.brain.lock"
CLASSIFY="$VAULT/scripts/brain-classify.sh"
cd "$VAULT"

echo "🧠 Brain Agent Triggered..."

if [[ -f "$LOCK_FILE" ]]; then
  echo "Agent already running..."
  exit 0
fi

touch "$LOCK_FILE"
trap 'rm -f "$LOCK_FILE"' EXIT

# 1. Detect changes (before staging)
CHANGED_FILES="$(git status --porcelain || true)"

if [[ -z "$CHANGED_FILES" ]]; then
  echo "No changes detected."
  exit 0
fi

# 2. Classify and append to MEMORY/ (heuristic — no destructive edits)
if [[ -x "$CLASSIFY" ]]; then
  "$CLASSIFY" || true
fi

# 3. Stage all changes (including classifier appends)
git add .

if git diff --cached --quiet; then
  echo "No staged changes after classification."
  exit 0
fi

# 4. Commit message from content type (filename heuristic)
MSG="brain: auto memory update"

if echo "$CHANGED_FILES" | grep -qE 'MEMORY/tasks|tasks\.md'; then
  MSG="brain: task update"
elif echo "$CHANGED_FILES" | grep -qE 'MEMORY/ideas|ideas\.md'; then
  MSG="brain: idea update"
elif echo "$CHANGED_FILES" | grep -qE 'MEMORY/decisions|decisions\.md|DECISIONS\.md|CURRENT_STATE'; then
  MSG="brain: decision update"
elif echo "$CHANGED_FILES" | grep -qE 'MEMORY/insights|insights\.md'; then
  MSG="brain: insight update"
elif echo "$CHANGED_FILES" | grep -qE 'MEMORY/bugs|BUGS\.md|bugs\.md'; then
  MSG="brain: bug update"
elif echo "$CHANGED_FILES" | grep -qE 'MEMORY/mistakes|mistakes\.md'; then
  MSG="brain: mistake update"
elif echo "$CHANGED_FILES" | grep -qE 'MEMORY/changelog|CHANGELOG\.md'; then
  MSG="brain: changelog update"
elif echo "$CHANGED_FILES" | grep -qE 'MEMORY/active_memory|active_memory\.md'; then
  MSG="brain: active memory update"
fi

# 5. Commit safely
git commit -m "$MSG"

# 6. Push only if remote exists
if git remote get-url origin >/dev/null 2>&1; then
  git push origin HEAD
else
  echo "No origin remote — committed locally only."
fi

echo "✅ Brain sync complete ($MSG)"
