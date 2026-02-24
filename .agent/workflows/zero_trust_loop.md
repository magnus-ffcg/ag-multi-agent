---
description: Zero-Trust AI Workflow — The Full Agent Loop
---

# Zero-Trust AI Workflow Loop

This workflow defines the complete lifecycle of a task through the three-agent system.
All agents must read `.agent/state/TASK_STATUS.md` as their first action, and update it + append to `.agent/state/HANDOFF_LOG.md` as their last action before handoff.

---

## Phase 0: Bootstrap (System / User)

1. User provides a task description.
2. System routes the task to the **Architect**.
3. Update `.agent/state/TASK_STATUS.md` + append to `.agent/state/HANDOFF_LOG.md`.

---

## Phase 1: Architect — Classify & Design

> **Model:** `gemini-2.5-pro` (deep reasoning, long-context)

1. Read `.agent/state/TASK_STATUS.md`.
2. Read `.agent/roles/architect.md` and `.agent/rules/strict_engineering.md`.
3. **Classify task tier:**
   - `TRIVIAL` → skip ADR
   - `MINOR` → lightweight ADR (Context + Decision + Security)
   - `MAJOR` → full Nygard ADR
4. **Check ADR precedents** — scan `docs/adr/` for prior decisions on the same topic. Cite if applicable.
5. Produce ADR (if MINOR or MAJOR). Save as `docs/adr/ADR-NNNN-<slug>.md`.
6. Update `.agent/state/TASK_STATUS.md` → `READY_FOR_DEVELOPER`.
7. Append row to `.agent/state/HANDOFF_LOG.md`.

---

## Phase 2: Developer — Implementation

> **Model:** `gemini-2.0-flash` (fast, tool-use optimized)

1. Read `.agent/state/TASK_STATUS.md` (and referenced ADR, if not TRIVIAL).
2. **Pre-flight check (MANDATORY — no file changes without this):**
   - Run dry-run (`terraform plan`, `validate`, etc.)
   - Confirm clean state, document output.
3. Implement changes (DRY, modular, no copy-paste IaC).
4. Run linter — zero errors required.
5. Run tests — tier-appropriate bar:
   - `TRIVIAL`: lint pass only
   - `MINOR`: unit or smoke test
   - `MAJOR`: full integration test
6. Update `CHANGELOG.md`.
7. Update `.agent/state/TASK_STATUS.md` → `READY_FOR_REVIEW` (include all evidence).
8. Append row to `.agent/state/HANDOFF_LOG.md`.

---

## Phase 3: Approver — Adversarial Review

> **Model:** `gemini-2.5-pro` (high-reasoning, skeptical analysis)

1. Read `.agent/state/TASK_STATUS.md`.
2. Verify evidence (tier-aware):
   - All tiers: linter output required
   - MINOR + MAJOR: dry-run + test output required
   - Missing evidence = **automatic REJECT** (skip code review)
3. Review ADR (MINOR/MAJOR): raise `[CRITICAL]` or explicitly clear it.
4. Review PR: raise `[NIT]` + `[SECURITY]`.

### If APPROVED:
5. **Version bump (tier-based):**
   - `TRIVIAL` → PATCH bump optional (e.g., `0.1.0` → `0.1.1`)
   - `MINOR` → MINOR bump required (e.g., `0.1.0` → `0.2.0`)
   - `MAJOR` → MAJOR bump REQUIRED (e.g., `0.1.0` → `1.0.0`)
6. Update `VERSION` file and move `CHANGELOG.md` `[Unreleased]` to versioned release header.
7. Update `.agent/state/TASK_STATUS.md` → `Status: APPROVED`.
8. Append row to `.agent/state/HANDOFF_LOG.md`. Loop ends. [YES]

### If REJECTED:
5. Update `.agent/state/TASK_STATUS.md` → `Status: REJECTED`. List all issues.
6. **FIX_LOG.md gate (tiered):**
   - Contains `[BLOCKER]` → `.agent/state/FIX_LOG.md` is **required** before re-review
   - `[CRITICAL]` only → inline reply in `.agent/state/TASK_STATUS.md` is sufficient
   - `[NIT]` / `[SECURITY]` only → acknowledgement in `.agent/state/TASK_STATUS.md` is sufficient
7. Append row to `.agent/state/HANDOFF_LOG.md`.
8. Return to **Phase 2**.

---

## Phase 4: Fix Loop (Post-Rejection)

1. Developer reads `.agent/state/TASK_STATUS.md` (Status: REJECTED).
2. If `[BLOCKER]` exists: create/update `.agent/state/FIX_LOG.md` documenting every fix with evidence.
3. If `[CRITICAL]` only: write response in `.agent/state/TASK_STATUS.md`.
4. Update `.agent/state/TASK_STATUS.md` → `READY_FOR_REVIEW`.
5. Append row to `.agent/state/HANDOFF_LOG.md`.
6. Approver reads `.agent/state/FIX_LOG.md` or `.agent/state/TASK_STATUS.md` response before re-review.

---

## Status Reference

| Status | Set By | Meaning |
|--------|--------|---------|
| `INITIALIZED` | System | Workspace ready, awaiting first task |
| `IN_PROGRESS` | Any agent | Active work underway |
| `READY_FOR_DEVELOPER` | Architect | ADR complete (or TRIVIAL), Developer can begin |
| `READY_FOR_REVIEW` | Developer | Implementation done, Approver can review |
| `REJECTED` | Approver | Rejected; see `.agent/state/TASK_STATUS.md` for tier-appropriate gate |
| `APPROVED` | Approver | Loop complete, changes accepted |
| `BLOCKED` | Any agent | Blocker requires human intervention |

---

## Model Assignment Summary

| Agent | Model | Rationale |
|-------|-------|-----------|
| Architect | `gemini-2.5-pro` | Deep reasoning, tradeoff analysis, long-context ADRs |
| Developer | `gemini-2.0-flash` | Speed, tool-use (file edits, commands, dry-runs) |
| Approver | `gemini-2.5-pro` | Adversarial reasoning, security pattern recognition |
