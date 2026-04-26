---
name: write-a-prd
description: Drive an idea to a written PRD via a grill-me interview, then synthesize the answers into the 8-section PRD template. Use when the user has a feature idea and says "write a PRD", "spec this out", or "let's plan a feature". The first HITL gate of the feature pipeline.
---

# write-a-prd

Turn a fuzzy feature idea into a PRD that the rest of the pipeline can execute against. This skill is the **first HITL gate** of the feature pipeline. The user reviews and approves the PRD before any issues get generated.

PRDs live at `features/<slug>/prd.md`. The slug is kebab-case, derived from the feature title.

---

## Step 1 — Confirm the slug and target path

Before interviewing, propose:

> "I'll draft this PRD at `features/<slug>/prd.md`. Slug ok?"

If `features/<slug>/` already exists, stop and ask whether to overwrite, pick a new slug, or resume an in-progress PRD.

---

## Step 2 — Interview

Run a `grill-me`-style interview. **One question at a time.** For each question, give a recommended answer with rationale, then let the user confirm, refine, or push back.

Walk the decision tree of the feature in roughly this order — but if an early answer collapses a later branch, skip it:

1. **Intent.** What is the single sentence that captures the point of this feature? Why does it matter now?
2. **Beneficiaries.** Who is the actor and what observable outcome do they get? If you cannot name an actor, the feature is not ready.
3. **Success criteria.** Two to five observable behaviors that prove the feature is done. These will become the spine of issue ACs and the changelog. Reject vague criteria ("works well", "is fast") — push for behavior you can test.
4. **Layers and interfaces.** Which architectural layers does this cross? What new or modified interfaces appear? Cross-check against `docs/architecture.md` if present.
5. **Out of scope.** What is this PRD explicitly *not* covering, and where do those concerns belong (a different PRD, a chore, a future phase)?
6. **Dependencies and unknowns.** What other features block this one? What is genuinely unknown and must be flagged `[VERIFY]`?
7. **Anything else.** Loose threads from the interview that don't fit the above sections.

Discipline:
- Don't accept hand-waving on success criteria. They are load-bearing.
- If the user contradicts an earlier answer, fold the correction in and confirm.
- Stop interviewing as soon as every section has a defensible answer. Don't pad.

---

## Step 3 — Draft the PRD

Use this template verbatim. Do not add sections. Empty sections are allowed; write `_None._` rather than inventing content.

```markdown
---
slug: <slug>
status: drafted
created: <YYYY-MM-DD>
---

# <feature title>

## One-sentence intent
<single sentence>

## Who benefits, and how
<actor + observable outcome>

## Success criteria
- <observable behavior 1>
- <observable behavior 2>
- <observable behavior 3>

## Layers and interfaces
<which architectural layers; new/modified interfaces>

## Explicitly out of scope
<what this PRD does NOT cover, and where those concerns belong>

## Dependencies and unknowns
<blocked-by features; [VERIFY] flags; known unknowns>

## Notes from interview
<anything from the interview that doesn't fit above>
```

`created` is today's date in ISO format. `status: drafted` is the only legal value at this stage — `prd-to-issues` will move it forward.

---

## Step 4 — HITL gate

Show the full draft to the user. Ask:

> "Is this PRD ready to slice into issues? (y / edits / no)"

- **y** — write the file to `features/<slug>/prd.md`.
- **edits** — capture the edits, redraft, re-show. Repeat until the user approves.
- **no** — do not write the file. Capture what's missing and offer to either continue interviewing or stop.

Only write the file once the user explicitly approves.

---

## Step 5 — Hand off

After saving, tell the user:

> "PRD saved. Run `/prd-to-issues features/<slug>/prd.md` when you're ready to slice it."

Do not invoke `prd-to-issues` automatically. The user owns the next gate.

---

## What this skill does NOT do

- It does not write issue files. That is `prd-to-issues`.
- It does not modify `docs/architecture.md` or `docs/conventions.md`. PRDs are fed by foundation docs, not the other way around.
- It does not invoke ralph or run feedback loops.
