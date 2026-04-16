---
name: write-a-spec
description: Produce a L3 feature specification from an existing L2 design doc. Inherits diagrams and design decisions from design.md — does not re-interview for what is already decided. Fills in the spec sections the design doc deliberately omits: user story, acceptance criteria, file-by-file scope, technical notes, learning opportunities, and definition of done. Adds a Handoff Notes section for the engineer's pre-implementation review. Use after write-a-design has produced a confirmed design.md. Triggers: "write the spec", "write-a-spec", "spec this out", or when design.md exists and is approved.
---

# write-a-spec

Turn a confirmed design into a spec the engineer can implement and review without
ambiguity. The design doc is the input — this skill fills the gap between design
intent and behavioral contract.

See [REFERENCE.md](REFERENCE.md) for AC format, DoD baseline, and Handoff Notes format.

## Philosophy

The spec is a behavioral contract, not a task list. Acceptance criteria define
what the system must do — observable, verifiable outcomes. The Definition of Done
defines what must be true before the PR is opened. These are different things and
must never be merged into one list.

---

## Step 0 — Apply DVR

Read `docs/ai-context.md`. The Tech Currency Rule governs this entire session.
Any package, API, or language feature claim in Technical Notes must be verified
against the pinned stack versions. If unverifiable: mark `[VERIFY]` and flag
for human review. Never assert from training alone.

---

## Step 1 — Load context

Read in this order. Stop if any required document is missing.

1. `docs/ai-context.md` — guardrails, DVR rule, pinned versions
2. `docs/decisions/<feature-branch-name>/design.md` — **required**. If missing,
   run write-a-design first. Do not produce a spec without a confirmed design doc.
3. `docs/architecture.md` — layer rules, existing patterns
4. `docs/current-state.md` — active phase, constraints, known issues

---

## Step 2 — Extract from the design doc

Do not re-interview for what the design doc already answers. Extract directly:

- **Diagrams** → Architecture Overview section (reference, do not duplicate)
- **Design decisions** → Design Decisions section (summarise, link to design.md)
- **In/out of scope** → Scope boundary and Out of Scope section
- **Interfaces introduced or modified** → seed the Scope table and File Layout

The spec adds what the design doc deliberately omits. Ask only for what is
genuinely missing after extraction.

---

## Step 3 — Interview for missing sections

Ask one question at a time. Stop asking when the answer is clear.

**User story** (if not obvious from design doc):
> "Complete this: As a [who], I want [what] so that [why]."

**Acceptance criteria** — for each behaviour the design introduces, ask:
> "Given [state], when [action], what must happen?"

Cover: happy path, validation failures, error cases, edge cases the design
flagged. Use the AC format from REFERENCE.md. Error cases are first-class ACs —
never group them as "error handling."

**File scope** — walk through the design doc's interface list:
> "Are there files affected by this that the design doc didn't list?"

The scope table is the contract between spec and implementation. If a file is not
listed, the engineer should question whether the spec is complete.

**Technical Notes** — for each package or API claim:
- Apply DVR before including it
- Include the reference URL inline
- Flag anything that cannot be verified

---

## Step 4 — Produce the spec

Fill the template from `docs/decisions/<feature-branch-name>/` using
`spec-template.md` as the structure. Every section must be populated —
no placeholder text in the final document.

Sections inherited from design.md (reference, do not duplicate prose):
- Architecture Overview → embed the Mermaid diagrams directly
- Design Decisions → one-paragraph summary per decision, link to design.md for full record

Sections the spec owns:
- User Story
- Background and Goals
- Scope (file table)
- Acceptance Criteria
- File Layout
- Technical Notes (DVR-verified)
- Out of Scope
- Learning Opportunities (minimum two — required, not optional)
- DX / Tooling Idea (one concrete, buildable idea)
- Definition of Done
- Handoff Notes for Engineer (see REFERENCE.md — added after DoD)

---

## Step 5 — Preview and save

Show the complete spec as a preview. Ask:
**"Does this accurately capture the intended behavior? Should I save it?"**

Target path: `docs/decisions/<feature-branch-name>/spec.md`
Status on save: `Draft`

Do not save without explicit confirmation.

---

## Step 6 — Hand off to spec-review

After saving, prompt:

> "Spec saved as Draft. Next step: run spec-review so the engineer can validate
> this before any code is written."

If any `[VERIFY]` flags remain in the spec, surface them as a list before
handing off — these must be resolved before spec-review begins.