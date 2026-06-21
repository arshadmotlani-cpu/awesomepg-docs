# Memory — Bugs

> **Append-only** problem and error log (operational memory).  
> Tracked issues with IDs and fixes: [[BUGS]] (formal bug registry).

**Rule:** Never delete entries. Link resolved items to [[BUGS#Resolved]] and [[mistakes]].

---

## Open

## 2026-06-22

- **OPS-UX-01** — Duplicate vacating/deposit/refund CTAs across admin UI → use [[Operations]] only ([[BUGS#OPS-UX-01]])
- **OPS-UX-02** — Legacy route bookmarks still in use → see [[ROUTES#Legacy redirects]]
- **RES-LIST-01** — `listResidentsForAdmin` LIMIT 200 may omit older residents in ops timeline
- **VAC-SAME-01** — Same-day vacating approve + stay shortening edge case → see tests

---

## Resolved (memory log)

## 2026-06-21

- **VAC-CRASH-01** — `/admin/vacating` crash (Date serialization) → `d4c01c6` ([[mistakes]])
- **BED-SSOT-01** — Bed map vs residents list mismatch → `88a16e8`
- **VAC-RENT-01** — Missing checkout-month rent on notice → `369bddb`

---

## How to append

```markdown
## YYYY-MM-DD
- **BUG-ID or summary:** symptom → status (link [[BUGS#…]] if tracked)
```

---

## Related

[[mistakes]] · [[BUGS]] · [[tasks]] · [[active_memory]] · [[insights]]
