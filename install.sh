#!/usr/bin/env bash
# =============================================================================
# Zero-Trust AI Workflow — Project Installer
# https://github.com/magnus-ffcg/ag-multi-agent
#
# Usage (one-liner):
#   curl -fsSL https://raw.githubusercontent.com/magnus-ffcg/ag-multi-agent/main/install.sh | bash
#
# What this does:
#   - Downloads the agent role, rules, workflow, and ADR template files.
#   - Generates fresh project-specific files (CHANGELOG, VERSION, state files).
#   - Never overwrites existing files — safe to re-run.
# =============================================================================

set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/magnus-ffcg/ag-multi-agent/main"
PROJECT_DIR="$(pwd)"
TODAY="$(date +%Y-%m-%d)"

# ── Colours ──────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; RESET='\033[0m'
ok()   { echo -e "${GREEN}  ✓${RESET} $1"; }
skip() { echo -e "${YELLOW}  ↷${RESET} $1 (already exists, skipped)"; }
info() { echo -e "${CYAN}  →${RESET} $1"; }

# ── Helpers ───────────────────────────────────────────────────────────────────
# Download a file from the template repo only if the destination doesn't exist.
download_if_missing() {
  local src_path="$1"    # path in the template repo
  local dest_path="$2"   # destination path in the target project

  if [ -f "${PROJECT_DIR}/${dest_path}" ]; then
    skip "${dest_path}"
    return
  fi

  mkdir -p "${PROJECT_DIR}/$(dirname "${dest_path}")"
  curl -fsSL "${REPO_RAW}/${src_path}" -o "${PROJECT_DIR}/${dest_path}"
  ok "Downloaded → ${dest_path}"
}

# Write a file only if it doesn't already exist.
write_if_missing() {
  local dest_path="$1"
  local content="$2"

  if [ -f "${PROJECT_DIR}/${dest_path}" ]; then
    skip "${dest_path}"
    return
  fi

  mkdir -p "${PROJECT_DIR}/$(dirname "${dest_path}")"
  printf '%s\n' "${content}" > "${PROJECT_DIR}/${dest_path}"
  ok "Generated → ${dest_path}"
}

# ── Banner ────────────────────────────────────────────────────────────────────
echo ""
echo "  ╔══════════════════════════════════════════════════╗"
echo "  ║   Zero-Trust AI Workflow — Project Installer     ║"
echo "  ║   https://github.com/magnus-ffcg/ag-multi-agent  ║"
echo "  ╚══════════════════════════════════════════════════╝"
echo ""
info "Installing into: ${PROJECT_DIR}"
echo ""

# ── 1. Template files (downloaded verbatim — no project-specific content) ────
echo "── Agent Roles ──────────────────────────────────────"
download_if_missing ".agent/roles/architect.md"  ".agent/roles/architect.md"
download_if_missing ".agent/roles/developer.md"  ".agent/roles/developer.md"
download_if_missing ".agent/roles/approver.md"   ".agent/roles/approver.md"

echo ""
echo "── Rules & Workflow ─────────────────────────────────"
download_if_missing ".agent/rules/strict_engineering.md" ".agent/rules/strict_engineering.md"
download_if_missing ".agent/workflows/zero_trust_loop.md" ".agent/workflows/zero_trust_loop.md"

echo ""
echo "── ADR Template ─────────────────────────────────────"
download_if_missing "docs/adr/ADR-TEMPLATE.md" "docs/adr/ADR-TEMPLATE.md"
download_if_missing "docs/adr/README.md"        "docs/adr/README.md"

# ── 2. Generated files (fresh, no references to the template repo) ────────────
echo ""
echo "── Project Files (generated fresh) ─────────────────"

# VERSION
write_if_missing "VERSION" "0.1.0"

# CHANGELOG — generic placeholder, no template repo URL
write_if_missing "CHANGELOG.md" "# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- Initialized Zero-Trust AI Workflow agent structure.

---

## [0.1.0] - ${TODAY}

### Added
- Initial project scaffold.

[Unreleased]: https://github.com/your-org/your-repo/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/your-org/your-repo/releases/tag/v0.1.0"

# ── 3. State files (blank runtime state, no history from this repo) ───────────
echo ""
echo "── Agent State ──────────────────────────────────────"

write_if_missing ".agent/state/TASK_STATUS.md" "# Task Status — Zero-Trust AI Workflow

> ⚠️ Agents MUST update this file before every handoff. Do NOT rely on chat history.

---

## Current Status: \`INITIALIZED\`

**Last Updated:** ${TODAY}
**Last Updated By:** System (Workspace Bootstrap)
**Current Phase:** Awaiting first task

---

## What Was Done

- Zero-Trust AI Workflow structure installed via one-liner.

---

## What the Next Agent Needs to Do

The **Architect** should:
1. Read \`.agent/roles/architect.md\` for role constraints.
2. Read \`.agent/rules/strict_engineering.md\` for guardrails.
3. Receive the first task.
4. Classify tier (TRIVIAL / MINOR / MAJOR) and produce an ADR if required.
5. Update this file with \`Status: READY_FOR_DEVELOPER\` on completion.

---

## Open Questions / Blockers

- Awaiting first task input.

---

## Handoff History

| Date | From | To | Status |
|------|------|----|--------|
| ${TODAY} | System | Architect | INITIALIZED |"

write_if_missing ".agent/state/HANDOFF_LOG.md" "# Handoff Log

> Append-only audit trail of every agent handoff. Never delete rows.
> \`TASK_STATUS.md\` holds current state. This file holds history.

| Timestamp | From | To | Task Description | Tier | Status | Notes |
|-----------|------|----|-----------------|------|--------|-------|
| ${TODAY} | System | Architect | Workspace initialization | — | INITIALIZED | Bootstrap via install.sh |"

write_if_missing ".agent/state/FIX_LOG.md" "# Fix Log

> Created by the Developer after an Approver REJECTION containing a [BLOCKER].
> The Approver will NOT re-review without a completed FIX_LOG for [BLOCKER] items.

---

## Rejection Reference

- **Date of Rejection:** YYYY-MM-DD
- **Rejected By:** Approver
- **ADR / PR Reference:** [ADR-NNNN / PR title]

---

## Rejection Reasons

| Severity | Issue | Description |
|----------|-------|-------------|
| \`[BLOCKER]\` | [Label] | [Full description] |
| \`[CRITICAL]\` | [Label] | [Full description] |
| \`[NIT]\` | [Label] | [Full description] |

---

## Corrections Made

### Fix 1: [Issue Label]

- **Root Cause:** [Why did this happen?]
- **Change Made:** [What was changed?]
- **Evidence:** [Paste output or path]

---

## Re-Review Readiness

- [ ] All \`[BLOCKER]\` items resolved with evidence
- [ ] All \`[CRITICAL]\` items resolved with evidence
- [ ] \`[NIT]\` items addressed or deferred with justification
- [ ] \`.agent/state/TASK_STATUS.md\` updated to \`READY_FOR_REVIEW\`
- [ ] Linter output attached
- [ ] Test output attached"

# ── 4. .gitignore — merge-safe append ────────────────────────────────────────
echo ""
echo "── .gitignore ────────────────────────────────────────"
GITIGNORE_BLOCK="# Zero-Trust AI Workflow (auto-added by install.sh)
*.tfstate
*.tfstate.backup
*.tfplan
**/.terraform/
.terraform.lock.hcl
__pycache__/
.venv/
.env
.DS_Store
node_modules/"

GITIGNORE_PATH="${PROJECT_DIR}/.gitignore"
if grep -q "Zero-Trust AI Workflow" "${GITIGNORE_PATH}" 2>/dev/null; then
  skip ".gitignore (block already present)"
else
  echo "" >> "${GITIGNORE_PATH}"
  printf '%s\n' "${GITIGNORE_BLOCK}" >> "${GITIGNORE_PATH}"
  ok ".gitignore updated (block appended)"
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}  ✅ Zero-Trust AI Workflow installed successfully.${RESET}"
echo ""
echo "  Next steps:"
echo "  1. Update CHANGELOG.md repo links (replace 'your-org/your-repo')."
echo "  2. Give the Architect a task — it reads .agent/state/TASK_STATUS.md first."
echo "  3. Follow the loop in .agent/workflows/zero_trust_loop.md."
echo ""
