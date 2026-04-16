# GitHub Triage — Reference

## One-time label setup

```bash
gh label create "bug"             --color "d73a4a" --description "Something is broken"
gh label create "enhancement"     --color "a2eeef" --description "New feature or improvement"
gh label create "needs-triage"    --color "e4e669" --description "Maintainer needs to evaluate this issue"
gh label create "needs-info"      --color "fef2c0" --description "Waiting on reporter for more information"
gh label create "afk"             --color "2ea44f" --description "Fully specified — ready for autonomous agent"
gh label create "ready-for-human" --color "0075ca" --description "Requires human implementation"
gh label create "wontfix"         --color "ffffff" --description "Will not be actioned"
```

---

## State machine

| Current State  | Can transition to  | Who triggers               | What happens                                                           |
|----------------|--------------------|----------------------------|------------------------------------------------------------------------|
| `unlabeled`    | `needs-triage`     | Skill (on first look)      | Skill applies label after presenting recommendation                    |
| `unlabeled`    | `afk`              | Maintainer (via skill)     | Already well-specified. Skill writes agent brief, applies label        |
| `unlabeled`    | `ready-for-human`  | Maintainer (via skill)     | Skill writes task summary comment, applies label                       |
| `unlabeled`    | `wontfix`          | Maintainer (via skill)     | Skill closes with comment; writes `.out-of-scope/` for enhancements    |
| `needs-triage` | `needs-info`       | Maintainer (via skill)     | Skill posts triage notes with progress + questions for reporter        |
| `needs-triage` | `afk`              | Maintainer (via skill)     | Grilling complete. Skill writes agent brief, applies label             |
| `needs-triage` | `ready-for-human`  | Maintainer (via skill)     | Grilling complete. Skill writes task summary, applies label            |
| `needs-triage` | `wontfix`          | Maintainer (via skill)     | Skill closes with comment; writes `.out-of-scope/` for enhancements    |
| `needs-info`   | `needs-triage`     | Skill (detects reply)      | Reporter replied. Skill surfaces to maintainer for re-evaluation       |

---

## Agent brief format

Posted as a comment when an issue moves to `afk`. This is the contract an autonomous agent works from.

```md
## Agent Brief

**Category:** bug / enhancement
**Summary:** one-line description of what needs to happen

**Current behavior:**
What happens now. For bugs: the broken behavior. For enhancements: the status quo.

**Desired behavior:**
What should happen after the work is complete. Include edge cases and error conditions.

**Key interfaces:**
- `TypeName` — what needs to change and why
- Method or function signature — current vs expected behavior
- Any new configuration or contract shapes

**Acceptance criteria:**
- [ ] Specific, testable criterion 1
- [ ] Specific, testable criterion 2
- [ ] Specific, testable criterion 3

**Out of scope:**
- Thing that should NOT be changed in this issue
- Adjacent feature that might seem related but is separate
```

### Agent brief principles

- **Durable over precise** — no file paths, no line numbers. Describe interfaces, contracts, and behaviors. The issue may sit in `afk` for weeks while the codebase changes.
- **Behavioral, not procedural** — describe *what* the system should do, not *how* to implement it
- **Complete acceptance criteria** — the agent needs to know when it's done. Each criterion must be independently verifiable.
- **Explicit scope boundaries** — state what is out of scope to prevent gold-plating

---

## Needs-info comment format

```md
## Triage Notes

**What we've established so far:**
- point 1
- point 2

**What we still need from you (@reporter):**
- specific question 1
- specific question 2
```

Questions for the reporter must be specific and actionable — not "please provide more info."

---

## Out-of-scope knowledge base

The `.out-of-scope/` directory stores persistent records of rejected feature requests.

**Purpose:**
1. Institutional memory — why a feature was rejected
2. Deduplication — surface prior rejections when a similar issue comes in

**File format** — one file per concept, not per issue:

```md
# Concept Name

Why this is out of scope, written in plain language with substantive reasoning.
Reference project scope, technical constraints, or strategic decisions.
Avoid temporary reasons ("too busy right now") — those are deferrals, not rejections.

## Prior requests

- #42 — "Original request title"
- #87 — "Similar request title"
```

**When to write:** only when an enhancement (not a bug) is rejected as `wontfix`.

**When to check:** during Step 1 of every triage session. Match by concept similarity, not keyword — "night theme" matches `dark-mode.md`.

**Naming:** short kebab-case concept name — `dark-mode.md`, `plugin-system.md`.
