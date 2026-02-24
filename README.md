# Antigravity: ag-multi-agent — Zero-Trust AI Workflow

A structured multi-agent engineering workspace implementing a **Zero-Trust AI Workflow** for Antigravity.
No agent trusts another's word — evidence, files, and guardrails govern every transition.

---

## Install into any project

```bash
curl -fsSL https://raw.githubusercontent.com/magnus-ffcg/ag-multi-agent/main/install.sh | bash
```

The installer:
- Downloads role, rules, workflow, and ADR template files from this repo.
- **Generates** fresh project-specific files (CHANGELOG, VERSION, state files) — no references to this template repo leak into your project.
- Skips any file that already exists — **safe to re-run**.
- Appends a block to your existing `.gitignore` rather than overwriting it.

After install, update the two placeholder URLs in `CHANGELOG.md` to point at your own repo.

---

## The Three Agents

| Role | File | Default Stance |
|------|------|----------------|
| **Architect** *(Gatekeeper)* | `.agent/roles/architect.md` | ADR required before any work begins |
| **Developer** *(Implementer)* | `.agent/roles/developer.md` | Pre-flight dry-run required before any modification |
| **Approver** *(Adversary)* | `.agent/roles/approver.md` | Default: **REJECT** until evidence proves otherwise |

---

## The Four Guardrails

Defined in `.agent/rules/strict_engineering.md`:

1. **NO "Works on my machine"** — Linting is mandatory. Failure = automatic reject.
2. **NO "Ghost Changes"** — Every change must be in `CHANGELOG.md`.
3. **NO Context Leakage** — `.agent/state/TASK_STATUS.md` is the single source of truth between agents.
4. **NO Security Shortcuts** — Private by default. Public requires an ADR.

---

## The Loop

```
User Task
    |
    v
+-------------+   ADR + VERSION updated
| ARCHITECT   |------------------------------+
+-------------+                             |
                                            v
                                  +------------------+
                                  |   DEVELOPER      |
                                  | (pre-flight req) |
                                  +--------+---------+
                                           | linter + tests + dry-run
                                           v
                                  +------------------+
                                  |    APPROVER      |<--- FIX_LOG.md (gated)
                                  | (default REJECT) |
                                  +--------+---------+
                                           |
                                  APPROVED v
                                    Loop ends [OK]
```

Full loop definition: `.agent/workflows/zero_trust_loop.md`

---

## Directory Structure

```
your-project/
+-- .agent/
|   +-- roles/
|   |   +-- architect.md            # Role: Gatekeeper
|   |   +-- developer.md            # Role: Implementer
|   |   +-- approver.md             # Role: Adversary
|   +-- rules/
|   |   +-- strict_engineering.md   # The four guardrails
|   +-- state/
|   |   +-- TASK_STATUS.md          # Current agent state (no context leakage)
|   |   +-- HANDOFF_LOG.md          # Append-only audit trail
|   |   +-- FIX_LOG.md              # Post-rejection correction log
|   +-- workflows/
|       +-- zero_trust_loop.md      # Full agent loop definition
+-- docs/adr/
|   +-- ADR-TEMPLATE.md             # Nygard ADR template
+-- install.sh                      # <- This installer
+-- CHANGELOG.md                    # Keep a Changelog standard
+-- VERSION                         # Single SemVer string
+-- README.md
```

---

## Current Status

See [`.agent/state/TASK_STATUS.md`](./.agent/state/TASK_STATUS.md) for the live status.

Current version: see [`VERSION`](./VERSION)

---

## ADRs

Architecture Decision Records are stored in [`docs/adr/`](./docs/adr/).
Use [`ADR-TEMPLATE.md`](./docs/adr/ADR-TEMPLATE.md) for every new decision.
Naming convention: `ADR-NNNN-short-title.md` (sequential, zero-padded to 4 digits).

---

## Starting the Loop

1. Give the Architect a task.
2. The Architect reads this README and `.agent/state/TASK_STATUS.md`.
3. The Architect produces an ADR and updates `.agent/state/TASK_STATUS.md` → `READY_FOR_DEVELOPER`.
4. The loop proceeds per `.agent/workflows/zero_trust_loop.md`.
