# Fix Log

> This file is created by the Developer after an Approver REJECTION.
> It must be completed before the Approver is allowed to re-review.
> The Approver will NOT re-review without a completed FIX_LOG.

---

## Rejection Reference

- **Date of Rejection:** YYYY-MM-DD
- **Rejected By:** Approver
- **ADR / PR Reference:** [ADR-NNNN / PR title]
- **TASK_STATUS at Rejection:** REJECTED

---

## Rejection Reasons (as cited by Approver)

Copy each blocking item from the Approver's review here:

| Severity    | Issue                          | Description                      |
|-------------|--------------------------------|----------------------------------|
| `[BLOCKER]` | [Label]                        | [Full description]               |
| `[CRITICAL]`| [Label]                        | [Full description]               |
| `[NIT]`     | [Label]                        | [Full description] *(deferred?)* |

---

## Corrections Made

For each `[BLOCKER]` and `[CRITICAL]` item, document the fix:

### Fix 1: [Issue Label]

- **Root Cause:** [Why did this happen?]
- **Change Made:** [What was changed?]
- **Evidence:** [Paste relevant output, diff, or path to updated file]

### Fix 2: [Issue Label]

- **Root Cause:** [Why did this happen?]
- **Change Made:** [What was changed?]
- **Evidence:** [Paste relevant output, diff, or path to updated file]

---

## Deferred NITs (if any)

| NIT | Reason for Deferral | Planned Resolution |
|-----|---------------------|--------------------|
| [NIT label] | [Justification] | [e.g., ADR-0002] |

---

## Re-Review Readiness

- [ ] All `[BLOCKER]` items resolved with evidence
- [ ] All `[CRITICAL]` items resolved with evidence
- [ ] `[NIT]` items addressed or deferred with justification
- [ ] `TASK_STATUS.md` updated to `READY_FOR_REVIEW`
- [ ] Linter output attached (zero errors)
- [ ] Test output attached (passing)
