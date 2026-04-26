---
name: wrap-up
description: Synthesize a feature's changelog.md after ralph finishes the AFK loop. Reads the PRD, completed issues, and git log; writes a criterion-anchored narrative. Use when the user says "wrap up the feature", "write the changelog", or "/wrap-up features/<slug>". Run after AFK and before /review.
---

# wrap-up

Synthesis only. No accretive layer ran during AFK — wrap-up is where the story gets told. The output is `features/<slug>/changelog.md`, organized by PRD success criteria, narrative voice.

This skill runs **after** ralph stops emitting `<promise>NO MORE TASKS</promise>` and **before** `/review`. Its purpose is to give `/review` a structured artifact to anchor against.

---

## Step 1 — Locate inputs

For the target feature slug, gather:

- `features/<slug>/prd.md` — the success criteria are the spine of the changelog.
- `features/<slug>/issues/done/*.md` — what got built. Skip anything still in `features/<slug>/issues/` (not done).
- Git log scoped to the feature's lifetime — every commit since the PRD was created, or since the last changelog if one exists.

If any AFK issues remain unfinished, stop and tell the user — wrap-up is premature.

---

## Step 2 — Build the criterion → evidence map

For each PRD success criterion, walk the completed issues and the git log and identify:

- Which issues' ACs satisfy this criterion (parent-prd link + AC text alignment).
- Which commits implemented those ACs.
- Which files / interfaces / tests now exist that prove the criterion holds.

If a criterion has no evidence, **flag it.** Do not paper over a gap. Either the criterion was missed, or it was satisfied implicitly and needs to be traced.

If commits exist that don't trace to any criterion, collect them for the "Beyond the criteria" section. Do not silently drop them.

---

## Step 3 — Draft the changelog

Use this template verbatim:

```markdown
---
feature: <slug>
prd: features/<slug>/prd.md
issues-completed: [<ids>]
generated: <YYYY-MM-DD>
---

# <feature title> — what was built

## <success criterion 1, verbatim from PRD>
<one paragraph: what now satisfies this, where the code lives, what tests prove it>

## <success criterion 2>
<...>

## Beyond the criteria
<commits or files not traced to a criterion; default empty>

## Foundation-doc impact
<empty by default; if patterns/conventions changed: candidate edits to architecture.md / conventions.md>
```

Voice rules:
- **Narrative, not a ledger.** Don't list issues — tell the story of how the criterion got satisfied.
- **Verbatim criteria headings.** Copy each success criterion as the section heading without paraphrasing. The reader should be able to ctrl-F the PRD and land on the matching paragraph.
- **Cite, don't dump.** Reference files and tests by path; don't paste code.
- **Keep "Beyond the criteria" honest.** If commits crept in that aren't traced, name them. `/review` will surface them anyway — you might as well call them out first.
- **Foundation-doc impact is empty by default.** Only fill it if the feature genuinely changed how the codebase works (a new layer rule, a new convention). Cosmetic edits don't qualify.

---

## Step 4 — Write the file

Write to `features/<slug>/changelog.md`. Update the PRD's frontmatter `status: issues-generated` → `status: review`.

Tell the user:

> "Changelog written. Run `/review features/<slug>` for the load-bearing gate."

---

## What this skill does NOT do

- It does not approve, block, or push. That is `/review`.
- It does not edit `architecture.md` or `conventions.md` directly. It surfaces *candidate* edits in the Foundation-doc impact section; `/review` decides whether to apply them.
- It does not write a per-issue ledger. The `issues/done/` directory and git log already carry that information — duplicating it is rot.
