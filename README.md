# ag-multi-agent — Zero-Trust AI Workflow Workspace

A structured multi-agent engineering workspace implementing a **Zero-Trust AI Workflow**.
No agent trusts another's word — evidence, files, and guardrails govern every transition.

---

## 🏗 The Three Agents

| Role | File | Default Stance |
|------|------|----------------|
| **Architect** *(Gatekeeper)* | `.agent/roles/architect.md` | ADR required before any work begins |
| **Developer** *(Implementer)* | `.agent/roles/developer.md` | Pre-flight dry-run required before any modification |
| **Approver** *(Adversary)* | `.agent/roles/approver.md` | Default: **REJECT** until evidence proves otherwise |

---

## 🔒 The Four Guardrails

Defined in `.agent/rules/strict_engineering.md`:

1. **NO "Works on my machine"** — Linting is mandatory. Failure = automatic reject.
2. **NO "Ghost Changes"** — Every change must be in `CHANGELOG.md`.
3. **NO Context Leakage** — `.agent/state/TASK_STATUS.md` is the single source of truth between agents.
4. **NO Security Shortcuts** — Private by default. Public requires an ADR.

---

## 🔄 The Loop

```
User Task
    │
    ▼
┌─────────────┐   ADR + VERSION updated
│  ARCHITECT  │──────────────────────────────┐
└─────────────┘                              │
                                             ▼
                                    ┌─────────────────┐
                                    │   DEVELOPER     │
                                    │ (pre-flight req)│
                                    └────────┬────────┘
                                             │ linter + tests + dry-run
                                             ▼
                                    ┌─────────────────┐
                                    │    APPROVER     │◄──── FIX_LOG.md (gated)
                                    │ (default REJECT)│
                                    └────────┬────────┘
                                             │
                                    APPROVED ▼
                                      Loop ends ✅
```

Full loop definition: `.agent/workflows/zero_trust_loop.md`

---

## 📁 Directory Structure

```
ag-multi-agent/
├── .agent/
│   ├── roles/
│   │   ├── architect.md       # Role: Gatekeeper
│   │   ├── developer.md       # Role: Implementer
│   │   └── approver.md        # Role: Adversary
│   ├── rules/
│   │   └── strict_engineering.md  # The four guardrails
│   └── workflows/
│       └── zero_trust_loop.md     # Full agent loop definition
├── docs/
│   └── adr/
│       └── ADR-TEMPLATE.md    # Nygard ADR template
├── CHANGELOG.md               # Keep a Changelog standard
├── FIX_LOG.md                 # Post-rejection correction log (template)
├── TASK_STATUS.md             # Agent handoff continuity (no context leakage)
├── VERSION                    # Single SemVer string
└── README.md                  # This file
```

---

## 🚦 Current Status

See [`.agent/state/TASK_STATUS.md`](./TASK_STATUS.md) for the live status.

Current version: see [`VERSION`](./VERSION)

---

## 📋 ADRs

Architecture Decision Records are stored in [`docs/adr/`](./docs/adr/).
Use [`ADR-TEMPLATE.md`](./docs/adr/ADR-TEMPLATE.md) for every new decision.
Naming convention: `ADR-NNNN-short-title.md` (sequential, zero-padded to 4 digits).

---

## ▶️ Starting the Loop

1. Give the Architect a task.
2. The Architect reads this README and `.agent/state/TASK_STATUS.md`.
3. The Architect produces an ADR and updates `.agent/state/TASK_STATUS.md` → `READY_FOR_DEVELOPER`.
4. The loop proceeds per `.agent/workflows/zero_trust_loop.md`.
