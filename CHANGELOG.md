# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

---

## [0.2.1] - 2026-02-24

### Added
- Added NO Emojis guardrail to `.agent/rules/strict_engineering.md`.

### Changed
- Stripped all emojis from workspace files; replaced with plain-text alternatives (`[YES]`, `[NO]`, `[WARNING]`, `[OK]`).

---

## [0.2.0] - 2026-02-24

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
- Added `install.sh` one-liner installer — downloads template files, generates fresh project-specific files, idempotent and merge-safe.

### Changed
- Added YAML model frontmatter to all three role files (`gemini-2.5-pro` for Architect/Approver, `gemini-2.0-flash` for Developer).
- Added three-tier task severity classification to Architect role (TRIVIAL / MINOR / MAJOR).
- Added ADR precedent check to Architect role.
- Softened Approver `[CRITICAL]` mandate — explicit clearance required if no risk found.
- Softened FIX_LOG.md gate — only required for `[BLOCKER]` rejections.
- Moved agent state files (`TASK_STATUS.md`, `HANDOFF_LOG.md`, `FIX_LOG.md`) to `.agent/state/`.
- Updated loop workflow with per-phase model assignments and tier-aware evidence checklist.
- Developer test bar is now tier-aware (TRIVIAL: lint only; MINOR: unit/smoke; MAJOR: integration).

---

## [0.1.0] - 2026-02-24

### Added
- Initial workspace scaffold for Zero-Trust AI Workflow.

[Unreleased]: https://github.com/magnus-ffcg/ag-multi-agent/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/magnus-ffcg/ag-multi-agent/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/magnus-ffcg/ag-multi-agent/releases/tag/v0.1.0
