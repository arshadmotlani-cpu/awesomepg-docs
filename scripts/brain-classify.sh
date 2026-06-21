#!/usr/bin/env bash
# Heuristic classifier — append agent-detected entries to MEMORY/ (no overwrites).
set -euo pipefail

VAULT="/Users/aashumotlani/awesomepg/docs"
cd "$VAULT"

TS="$(date -u +%Y-%m-%d)"
TS_FULL="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

CHANGED=()
while IFS= read -r line; do
  [[ -n "$line" ]] && CHANGED+=("$line")
done < <(git status --porcelain 2>/dev/null | awk '{print $2}' || true)

if [[ ${#CHANGED[@]} -eq 0 ]]; then
  exit 0
fi

classify_file() {
  local f="$1"
  case "$f" in
    MEMORY/tasks.md|*tasks*) echo "task" ;;
    MEMORY/ideas.md|*ideas*) echo "idea" ;;
    MEMORY/decisions.md|*decisions*|DECISIONS.md|SYSTEM/CURRENT_STATE.md) echo "decision" ;;
    MEMORY/insights.md|*insights*) echo "insight" ;;
    MEMORY/bugs.md|BUGS.md|*bugs*) echo "bug" ;;
    MEMORY/mistakes.md|*mistakes*) echo "mistake" ;;
    MEMORY/changelog.md|CHANGELOG.md) echo "changelog" ;;
    MEMORY/active_memory.md) echo "active" ;;
    *) echo "vault-update" ;;
  esac
}

DOMINANT="vault-update"
for f in "${CHANGED[@]}"; do
  case "$f" in
    scripts/*|.brain.lock|.auto-sync.lock|.git/*) continue ;;
  esac
  c="$(classify_file "$f")"
  if [[ "$c" != "vault-update" && "$c" != "active" && "$c" != "changelog" ]]; then
    DOMINANT="$c"
    break
  fi
  if [[ "$c" == "active" || "$c" == "changelog" ]]; then
    DOMINANT="$c"
  fi
done

memory_target() {
  case "$1" in
    task) echo "MEMORY/tasks.md" ;;
    idea) echo "MEMORY/ideas.md" ;;
    decision) echo "MEMORY/decisions.md" ;;
    insight) echo "MEMORY/insights.md" ;;
    bug) echo "MEMORY/bugs.md" ;;
    mistake) echo "MEMORY/mistakes.md" ;;
    *) echo "MEMORY/changelog.md" ;;
  esac
}

TARGET="$(memory_target "$DOMINANT")"
FILE_LIST=""
for f in "${CHANGED[@]}"; do
  case "$f" in
    scripts/brain-*|.brain.lock) continue ;;
  esac
  FILE_LIST="${FILE_LIST}- \`${f}\`"$'\n'
done

ENTRY="## ${TS} (agent · ${TS_FULL})

- **Type:** ${DOMINANT}
- **Files:**
${FILE_LIST}"

AGENT_MARKER="<!-- AGENT_${TS_FULL} -->"
if [[ -f "$TARGET" ]] && ! grep -qF "$AGENT_MARKER" "$TARGET" 2>/dev/null; then
  {
    echo ""
    echo "$AGENT_MARKER"
    echo "$ENTRY"
  } >> "$TARGET"
fi

CHANGELOG="MEMORY/changelog.md"
CL_MARKER="<!-- AGENT_LOG_${TS_FULL} -->"
if [[ -f "$CHANGELOG" ]] && ! grep -qF "$CL_MARKER" "$CHANGELOG" 2>/dev/null; then
  {
    echo ""
    echo "$CL_MARKER"
    echo "- **${TS_FULL}** — agent classified \`${DOMINANT}\` (${#CHANGED[@]} file(s))"
  } >> "$CHANGELOG"
fi

ACTIVE="MEMORY/active_memory.md"
STATUS_START="<!-- AGENT_STATUS_START -->"
STATUS_END="<!-- AGENT_STATUS_END -->"
if [[ -f "$ACTIVE" ]]; then
  STATUS_BLOCK="${STATUS_START}
## Agent status

> **Last run:** ${TS_FULL}  
> **Classification:** ${DOMINANT}  
> **Files touched:** ${#CHANGED[@]}

${STATUS_END}"
  if grep -qF "$STATUS_START" "$ACTIVE"; then
    # Replace status block (bash 3.2 safe via temp file)
    awk -v start="$STATUS_START" -v end="$STATUS_END" -v block="$STATUS_BLOCK" '
      BEGIN { inblock=0; done=0 }
      index($0, start) { if (!done) { print block; done=1 }; inblock=1; next }
      index($0, end) { inblock=0; next }
      !inblock { print }
    ' "$ACTIVE" > "$ACTIVE.tmp" && mv "$ACTIVE.tmp" "$ACTIVE"
  else
    {
      echo ""
      echo "$STATUS_BLOCK"
    } >> "$ACTIVE"
  fi
fi

echo "[brain-classify] ${DOMINANT} → ${TARGET} (${#CHANGED[@]} files)"
