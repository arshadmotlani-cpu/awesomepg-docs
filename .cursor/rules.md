# 🧠 CURSOR MEMORY ENGINE RULES

> Vault path: `/Users/aashumotlani/awesomepg/docs`  
> GitHub: https://github.com/arshadmotlani-cpu/awesomepg-docs

These rules apply to **every edit** inside this vault (Cursor, ChatGPT, Claude, you).

---

## 1. Always classify changes

Before writing anything, determine:

| Type | File |
|------|------|
| **TASK** → actionable work | [[tasks]] |
| **IDEA** → concept or thought | [[ideas]] |
| **DECISION** → final choice made | [[decisions]] (+ [[DECISIONS]] if ADR) |
| **INSIGHT** → learning or discovery | [[insights]] |
| **BUG** → problem or error | [[bugs]] (+ [[BUGS]] if tracked issue) |
| **CHANGELOG** → system / vault update | [[changelog]] (+ [[CHANGELOG]] if app ship) |

Also update [[mistakes]] when something went wrong and was fixed.

---

## 2. Write to MEMORY only (no random dumping)

All new information must go into:

```
/docs/MEMORY/
```

Never store raw unstructured notes in **SYSTEM/** or **PROJECT/** unless explicitly updating stable system truth (features, workflows, current state).

---

## 3. Append-only system

Never overwrite history.

Always:

- append new entries under `## YYYY-MM-DD` headings
- preserve past state

---

## 4. Update ACTIVE MEMORY after every meaningful edit

[[active_memory]] must always contain:

- **current focus**
- **active tasks** (or link [[tasks]])
- **current blockers**
- **latest decisions** (or link [[decisions]])

---

## 5. Auto-log rule

After any file edit, **if change is meaningful**:

1. Write entry to the correct MEMORY file
2. Update [[active_memory]]
3. Add line to [[changelog]]

---

## 6. Git sync rule

After memory update:

```bash
cd /Users/aashumotlani/awesomepg/docs
./scripts/brain-sync.sh
```

This stages changes, commits with `brain: auto memory sync`, and pushes if `origin` exists. Skips commit when nothing changed.

---

## 7. Safety rule

Do **NOT**:

- delete memory history
- overwrite past decisions
- merge unrelated concepts into one entry
- force-push Git history

---

## Live sync options

| Mode | Command |
|------|---------|
| Manual (recommended after edits) | `./scripts/brain-sync.sh` |
| Background watcher | `./scripts/brain-watch.sh` (requires `fswatch`) |

---

## Read order for AI

[[START_HERE]] → [[AI_CONTEXT]] → [[active_memory]] → domain hub as needed

---

## END RULES
