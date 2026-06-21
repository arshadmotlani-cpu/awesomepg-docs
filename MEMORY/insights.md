# Memory — Insights

> **Append-only** learnings and observations. Lessons, patterns, and "why" notes.

**Rule:** Never delete entries. Link to [[DECISIONS]], [[BUGS]], or domain hubs when relevant.

---

## 2026-06-22

- **Nested Git repos:** App repo (`awesomepg`) and docs vault (`docs/.git`) can coexist; parent may show `docs/` as modified — use separate GitHub remote for vault sync
- **Obsidian vault marker:** Opening `docs/` in Obsidian creates `.obsidian/` (gitignored); absence of `.obsidian/` means vault not yet opened there
- **Wiki-link basenames:** Moving `FEATURES.md` → `PROJECT/features.md` changes link target to `[[features]]` — verify with `npm run docs:links` in app repo

## 2026-06-21

- **RSC serialization:** Passing `Date` objects from server components to `'use client'` children crashes pages — always serialize at boundary ([[DECISIONS#Client Date serialization]])
- **Half-open ranges:** Last occupied day = `upper(stay_range) - 1`; pro-ration uses day after move-out as exclusive end
- **Deposit refund timing:** Residents attempted meter upload before vacate date because UI didn't cap journey stages — fixed in `vacatingJourney.ts`
- **Bed assignment drift:** Bed map and residents list used different SQL predicates until `occupancySsot.ts` alignment (`88a16e8`)
- **Checkout-month rent gap:** Filing vacating notice for partial month (e.g. 5 July) didn't generate 1–5 July rent until `vacatingCheckoutBilling.ts`

---

## How to append

```markdown
## YYYY-MM-DD
- **Topic:** Insight in one or two sentences. Link a domain hub (e.g. [[Vacating]]) if applicable.
```

---

## Related

[[mistakes]] · [[decisions]] · [[DECISIONS]] · [[AI_CONTEXT]]
