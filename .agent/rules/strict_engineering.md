# Strict Engineering Rules — Zero-Trust AI Workflow
# These are NON-NEGOTIABLE constraints. Every agent MUST follow them.

---

## ❌ NO "Works on My Machine"

- Any code change that does not pass a linting check is an **automatic failure**.
- The Developer MUST run the linter (e.g., `terraform validate`, `tflint`, `pylint`, `eslint`) and attach the successful output to their handoff **before** requesting an Approver review.
- The Approver will REJECT any PR without attached linter output.

---

## ❌ NO "Ghost Changes"

- Every single code change — no matter how trivial — MUST have a corresponding entry in `CHANGELOG.md`.
- Changelog entries must appear under the correct SemVer header (`## [Unreleased]` or `## [X.Y.Z] - YYYY-MM-DD`).
- The Approver will REJECT any PR whose diff does not include a `CHANGELOG.md` update.

---

## ❌ NO Context Leakage

- Agents MUST NOT rely on chat history for task continuity.
- Before handing off to the next agent, the current agent MUST update `.agent/state/TASK_STATUS.md` with:
  - Current status (IN_PROGRESS / BLOCKED / DONE)
  - What was done
  - What the next agent needs to do
  - Any open questions or blockers
- The receiving agent MUST read `.agent/state/TASK_STATUS.md` as its first action.

---

## ❌ NO Security Shortcuts

- If a resource CAN be private, it MUST be private.
- Public access is an **exceptional case** and requires:
  1. A specific ADR entry in `docs/adr/` justifying the exception.
  2. Explicit sign-off from the Approver.
- Default posture: deny all public access. Allowlist, never denylist.

---

## Enforcement

| Violation              | Consequence                                   |
|------------------------|-----------------------------------------------|
| Missing linter output  | Automatic REJECT by Approver                  |
| Missing CHANGELOG entry| Automatic REJECT by Approver                  |
| No TASK_STATUS.md update | Architect flags as incomplete; loop resets  |
| Public access without ADR | Architect vetos; change is rolled back    |
