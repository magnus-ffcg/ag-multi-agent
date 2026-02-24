# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- Initialized Zero-Trust AI Workflow multi-agent workspace structure.
- Created `.agent/rules/strict_engineering.md` with four negative guardrails.
- Created role definitions: `architect.md`, `developer.md`, `approver.md`.
- Created ADR Nygard template at `docs/adr/ADR-TEMPLATE.md`.
- Created `TASK_STATUS.md` for agent handoff continuity.
- Created `FIX_LOG.md` template for post-rejection correction documentation.
- Created `VERSION` file seeded at `0.1.0`.
- Created `.agent/workflows/zero_trust_loop.md` defining the full agent loop.
- Created `CHANGELOG.md` following Keep a Changelog standard.
- Created `README.md` as workspace orientation document.
- Created `HANDOFF_LOG.md` as append-only audit trail of all agent handoffs.

### Changed
- Added YAML model frontmatter to all three role files (`gemini-2.5-pro` for Architect/Approver, `gemini-2.0-flash` for Developer).
- Added three-tier task severity classification to Architect role (TRIVIAL / MINOR / MAJOR) to eliminate unnecessary ADR overhead on small changes.
- Added ADR precedent check to Architect role — prior decisions can shortcut re-deliberation.
- Softened Approver `[CRITICAL]` mandate: must provide explicit clearance reasoning if no risk found, eliminating artificial friction.
- Softened FIX_LOG.md gate: now only required for `[BLOCKER]` rejections; `[CRITICAL]`-only rejections allow inline `TASK_STATUS.md` response.
- Updated loop workflow with per-phase model assignments, tier-aware evidence checklist, and HANDOFF_LOG step at every handoff.
- Developer test bar is now tier-aware: TRIVIAL requires lint only; MINOR requires unit/smoke; MAJOR requires full integration test.

---

## [0.1.0] - 2026-02-24

### Added
- Initial workspace scaffold for Zero-Trust AI Workflow.

[Unreleased]: https://github.com/magnus-ffcg/ag-multi-agent/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/magnus-ffcg/ag-multi-agent/releases/tag/v0.1.0
