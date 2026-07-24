# Billing engine invariants — move-out settlement

**Status:** Registry for validation and production audits.  
**Related:** [BILLING_SETTLEMENT_BUSINESS_RULES.md](./BILLING_SETTLEMENT_BUSINESS_RULES.md) · [BILLING_COVERAGE_MODEL.md](./BILLING_COVERAGE_MODEL.md)

Each invariant has:

- **ID** — stable identifier  
- **Statement** — mathematical or logical rule  
- **Signature** — failure code for grouping root causes  
- **Implemented** — Y = enforced in code today, P = partial, N = documented only (Phase 1)

Violations are **engine bugs**. Do not patch individual residents.

---

## Waterfall (CheckoutSettlementEngineV2)

| ID | Statement | Signature | Impl | Code |
|----|-----------|-----------|------|------|
| **INV-W1** | `rentPaid = rentConsumed + unusedRent` | `WATERFALL_INCONSISTENT` | Y | [`assertCheckoutSettlementWaterfallConsistent`](../src/lib/checkout/settlementInvariants.ts) |
| **INV-W2** | `depositRefundable = depositHeld − noticeFromDeposit − tail − electricity − other` (≥ 0) | `WATERFALL_INCONSISTENT` | Y | same |
| **INV-W3** | `refundTotal = depositRefundable + unusedRentAfterNotice` | `WATERFALL_INCONSISTENT` | Y | same |

---

## Notice bucket

| ID | Statement | Signature | Impl | Code |
|----|-----------|-----------|------|------|
| **INV-N1** | When notice applies: `noticeFull = noticeFromUnused + noticeFromDeposit` | `NOTICE_SPLIT_MISMATCH` | P | V2 compute; Phase 1 explicit assert |
| **INV-N2** | `noticeFromUnused ≤ min(unusedRent, noticeFull)` | `NOTICE_UNUSED_CAP` | P | V2 compute |
| **INV-N3** | `waterfall.missingNoticeDays` = BCM `noticeBreakdown.missingNoticeDays` | `NOTICE_DAYS_DRIFT` | Y | [`validateMoveOutSettlementExplanations`](../src/lib/vacating/moveOutSettlementExplanation.ts) |

---

## Non-negativity

| ID | Statement | Signature | Impl | Code |
|----|-----------|-----------|------|------|
| **INV-P1** | All waterfall bucket amounts ≥ 0 | `NEGATIVE_PAISE` | P | `guardDepositPaise` on inputs; Phase 1 full scan |

---

## Billing coverage & tail

| ID | Statement | Signature | Impl | Code |
|----|-----------|-----------|------|------|
| **INV-C1** | Every `paidInvoiceCoverage.periodStart` ≥ `moveInDate` | `COVERAGE_BEFORE_MOVEIN` | Y | [`clampPaidInvoiceCoverage`](../src/lib/billing/billingCoverageModel.ts) + unit tests |
| **INV-C2** | `waterfall.tailRentPaise === coverage.tailRentPaise` | `TAIL_MISMATCH` | Y | explainability validator |
| **INV-C3** | If vacating date ∈ any **paid** period, then `tailRentPaise = 0` | `TAIL_IN_PAID_PERIOD` | P | Regression Case C; Phase 1 prod check |
| **INV-C4** | Tail window days must not double-charge rent already in paid coverage | `TAIL_OVERLAP_PAID` | N | Phase 1 semantic check |

---

## Explainability & UI parity

| ID | Statement | Signature | Impl | Code |
|----|-----------|-----------|------|------|
| **INV-E1** | All 9 settlement explanation lines present with formula, rule, source | `EXPLANATION_GAP` | Y | [`moveOutSettlementExplanation.ts`](../src/lib/vacating/moveOutSettlementExplanation.ts) |
| **INV-E2** | Each explanation `valuePaise` equals waterfall field | `EXPLANATION_VALUE_MISMATCH` | Y | same |
| **INV-E3** | Preview UI rows match waterfall for mapped ids | `UI_ROW_MISMATCH` | Y | same |
| **INV-E4** | Every displayed ₹0 amount has non-empty business **Reason** in explanation | `ZERO_WITHOUT_REASON` | N | Phase 1 |

---

## Cross-surface & stored snapshots

| ID | Statement | Signature | Impl | Code |
|----|-----------|-----------|------|------|
| **INV-X1** | Locked checkout settlement waterfall matches presentation loader for same booking/dates | `CHECKOUT_PREVIEW_DRIFT` | N | Phase 1 — settlement_review / refund_ready |
| **INV-X2** | Pending: `vacating_requests.deduction_paise` aligns with engine notice-from-deposit or full notice at submit | `STORED_ROW_DRIFT` | Y | explainability validator (informational) |

---

## Business rule mapping

| Invariant | Business rules (BR-*) |
|-----------|------------------------|
| INV-W1–W3 | BR-RENT-PAID, BR-RENT-CONSUMED, BR-RENT-UNUSED, BR-NOTICE-ORDER, BR-REFUND |
| INV-N* | BR-NOTICE-CHARGE, BR-NOTICE-PREPAID, BR-NOTICE-ORDER |
| INV-C* | BR-ANCHOR, BR-LAST-MONTH, BR-TAIL-CHARGE, BR-TAIL-NONE |
| INV-E* | All displayed amounts in approve/review UI |

---

## Production validation (Phase 0)

**Automated today (estimate path, all non-terminal move-outs):**

```bash
USE_PRODUCTION_DB=1 npx tsx scripts/audit-active-moveout-settlement-explanations.ts
```

Covers: INV-W* (via assert), INV-N3, INV-C2, INV-E1–E3, INV-X2 (pending), plus grouped signatures.

**Extended matrix (read-only report):**

```bash
USE_PRODUCTION_DB=1 npx tsx scripts/report-phase0-moveout-validation-matrix.ts
```

Writes [`docs/validation/ACTIVE_MOVEOUT_PHASE0_MATRIX.md`](validation/ACTIVE_MOVEOUT_PHASE0_MATRIX.md).

---

## Root-cause routing (Part 4)

| Signature | Fix once in |
|-----------|-------------|
| `TAIL_MISMATCH`, `TAIL_IN_PAID_PERIOD`, `TAIL_OVERLAP_PAID` | `vacatingFinalPeriodRent.ts` / BCM / presentation loader |
| `NOTICE_DAYS_DRIFT`, `NOTICE_SPLIT_MISMATCH` | BCM ↔ V2 wiring |
| `UI_ROW_MISMATCH`, `EXPLANATION_GAP` | Preview sections / explanation builder |
| `STORED_ROW_DRIFT` | Vacating submit snapshot vs engine |
| `CHECKOUT_PREVIEW_DRIFT` | Checkout lock vs `loadVacatingBillingPresentation` |
| `ZERO_WITHOUT_REASON` | `moveOutSettlementExplanation.ts` reason lines |

---

## Phase 1 (after proof)

Implement [`src/lib/billing/billingEngineValidation.ts`](../src/lib/billing/billingEngineValidation.ts) running all **INV-*** checks, branch by workflow stage (estimate vs locked checkout), CI gate when clean.
