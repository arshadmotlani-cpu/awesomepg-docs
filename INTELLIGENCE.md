# IDE Activity Intelligence Layer

> **Vault-only:** `/Users/aashumotlani/awesomepg/docs`  
> Development journal engine — filesystem changes → MEMORY → Git → GitHub

---

## Pipeline

```
File change (docs/ only)
        ↓
brain-watch.sh (fswatch)
        ↓
brain-agent.sh
        ↓
brain-classify.sh (intelligence engine)
        ↓
MEMORY/ append + changelog + conditional active_memory
        ↓
git commit (brain: <type> update) + push
```

---

## Classification types

| Type | MEMORY target | Commit example |
|------|---------------|----------------|
| TASK | `MEMORY/tasks.md` | `brain: task update` |
| FEATURE | `MEMORY/ideas.md` | `brain: feature update` |
| BUG | `MEMORY/bugs.md` | `brain: bug fix` |
| REFACTOR | `MEMORY/insights.md` | `brain: refactor update` |
| DECISION | `MEMORY/decisions.md` | `brain: decision update` |
| INSIGHT | `MEMORY/insights.md` | `brain: insight update` |

Every run appends a structured entry to **`MEMORY/changelog.md`**.

---

## active_memory updates

**Current Focus / Blockers / Priorities** are NOT auto-rewritten.

The agent only adds a **review delta** when these files change:

- `SYSTEM/CURRENT_STATE.md`
- `PROJECT/roadmap.md`
- `START_HERE.md`
- `BUGS.md`
- `MEMORY/active_memory.md` (user edit)

---

## Commands

```bash
# Live development journal (background)
./scripts/brain-watch.sh

# One-shot after edits
./scripts/brain-agent.sh
```

---

## Hard limits

- Tracks **filesystem changes in /docs only**
- Does NOT track Cursor UI, keystrokes, or OS activity
- Heuristic classification (not LLM semantic parsing)
- Append-only — never deletes MEMORY history

---

## Related

[[active_memory]] · [[changelog]] · [[START_HERE]] · `.cursor/rules.md`
