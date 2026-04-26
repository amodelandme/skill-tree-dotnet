---
name: prd-to-issues
description: Slice an approved PRD into tracer-bullet issue files under features/<slug>/issues/. Drafts the list, gates on user approval, then writes the files. Use when the user says "slice this PRD", "generate issues from features/<slug>/prd.md", or "/prd-to-issues". The second HITL gate of the feature pipeline.
---

# prd-to-issues

Take an approved PRD and turn it into a sliced list of issue files. **The slicing and file-writing live in the same skill, with a HITL gate in between.** Do not write any files until the user approves the list.

---

## Step 1 — Locate and read the PRD

The user will pass a path (or you infer from context). Read:

- `features/<slug>/prd.md` — the PRD itself.
- `docs/architecture.md` and `docs/conventions.md` — to ground layer-crossing claims and constraints.
- `features/<slug>/issues/` (if present) — to see what's already been sliced.

Confirm the PRD's `status` is `drafted` or `issues-generated`. If it's anything else, stop and ask.

---

## Step 2 — Slice into tracer-bullet issues

Generate a list of issues that, when stacked, satisfy every PRD success criterion. Slicing rules:

- **Vertical, not horizontal.** Each issue crosses every layer it needs to deliver observable behavior. No "build the repository, then the service, then the API" sequencing.
- **Tracer first.** The first issue is the thinnest possible end-to-end slice. Subsequent issues thicken or extend.
- **One AC anchor minimum.** Every issue must trace to at least one PRD success criterion. If a slice doesn't, either it's scope creep or a criterion is missing.
- **Mark dependencies.** If issue B requires the schema introduced in A, set `blocked-by: [001]` on B.
- **Type defaults to AFK.** Mark `type: HITL` only when human judgment is required mid-slice (e.g., a copy decision, a UX trade-off).
- **Numbering.** Zero-padded sequential per feature: `001`, `002`, ... Numbers are local to the feature.

Aim for the smallest set of slices that covers the PRD. If you need more than ~7 issues, the PRD is probably too big — surface that to the user instead of pushing through.

---

## Step 3 — HITL gate: present the list

Show the full slice plan as a flat list **before writing any files**. Format:

```
Proposed slices for features/<slug>/:

001 — <title>           [AFK]   blocked-by: —        criteria: 1, 2
002 — <title>           [AFK]   blocked-by: 001      criteria: 2
003 — <title>           [HITL]  blocked-by: 001      criteria: 3
...

Coverage check:
  Criterion 1: ✅ covered by 001
  Criterion 2: ✅ covered by 001, 002
  Criterion 3: ✅ covered by 003
  Criterion 4: ❌ not covered — propose adding 004
```

Ask:

> "Approve this slice list? (y / edits / no)"

- **edits** — capture changes (re-slice, add, drop, retitle, re-block), re-show. Repeat.
- **no** — stop without writing anything.
- **y** — proceed to step 4.

Do not write any issue file before approval.

---

## Step 4 — Write the issue files

For each approved slice, write `features/<slug>/issues/<id>.md` using this template:

```markdown
---
id: <id>
title: <title>
type: AFK
status: open
blocked-by: [<other-ids>]    # [] if none
parent-prd: features/<slug>/prd.md
---

## Intent
<one paragraph: end-to-end behavior this slice delivers>

## Acceptance criteria
- [ ] <observable behavior 1>
- [ ] <observable behavior 2>
- [ ] <error case>
- [ ] <edge case>

## Layers crossed
<Api → Application → Domain → Infrastructure — whichever apply>

## Definition of done
- All ACs covered by tests
- dotnet build/test/format clean
- Issue moved to `features/<slug>/issues/done/`
```

ACs should be testable. If you find yourself writing "the system is robust", reword it to a behavior.

Do not invent "files touched" or "technical notes" — those are derived at implementation time from `docs/architecture.md` and `docs/conventions.md`. The issue contract is intent + ACs + layers + DoD.

---

## Step 5 — Update PRD status and hand off

After writing all issues:

1. Update the PRD frontmatter `status: drafted` → `status: issues-generated`.
2. Tell the user:

   > "Sliced N issues into `features/<slug>/issues/`. Ready for ralph — kick off with `ralph/once.sh` or `ralph/afk.sh <iterations>`."

Do not run ralph for the user. The user owns that handoff.

---

## What this skill does NOT do

- It does not run ralph.
- It does not push to GitHub. There is no `gh issue create` here — issues are local files.
- It does not write the changelog. That is `wrap-up`, after AFK.
