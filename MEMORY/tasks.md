# Memory — Tasks

> **Append-only** actionable items. Move completed items to a `## Done` section — do not delete.

**Rule:** Tasks are actionable. Strategic items belong in [[ideas]].

---

## Active

## 2026-06-22

- [ ] Add GitHub remote to docs vault and push `main`
- [ ] Open Obsidian on `/Users/aashumotlani/awesomepg/docs` — confirm `TEST_OBSIDIAN_CONNECTION.md` visible
- [ ] Optional: run `./scripts/watch-auto-sync.sh` for background vault sync
- [ ] Resolve parent repo vs docs vault tracking (submodule or ignore `docs/` in app repo)

## 2026-06-21

- [ ] Verify `d4c01c6` vacating/ops fixes in production (Mohd approve flow, Harish settlement)
- [ ] Consolidate duplicate admin vacating/deposit/refund entry points → [[Operations]] only
- [ ] Approve pending move-outs from operations queue
- [ ] Complete in-progress checkout settlements
- [ ] Reduce legacy route bookmarks (`/admin/requests`, `/admin/collections`)

---

## Done

## 2026-06-21

- [x] Create second brain docs (12 core files + domain hubs)
- [x] Pre-commit doc sync hook in app repo
- [x] Fix `/admin/vacating` Date serialization crash (`d4c01c6`)
- [x] Checkout-month rent sync on vacating notice (`369bddb`)
- [x] Bed assignment SSOT alignment (`88a16e8`)
- [x] Initialize docs vault Git + auto-sync scripts

---

## How to append

```markdown
## YYYY-MM-DD
- [ ] Task description (link [[Operations]] or route if admin action)
```

---

## Related

[[active_memory]] · [[CURRENT_STATE]] · [[ideas]] · [[START_HERE]]
