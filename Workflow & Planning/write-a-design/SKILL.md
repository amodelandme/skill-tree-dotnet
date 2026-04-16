---
name: write-a-design
description: Produce a L2 feature design document — the bridge between foundation docs (30,000 ft) and a detailed spec (microscope). Generates Mermaid component and sequence diagrams, key design decisions with tradeoffs, verified package recommendations, and an explicit in/out-of-scope boundary. Use when a feature is ready to design but before write-a-spec runs. Triggers: "design this feature", "write a design doc", "L2", "before we spec this out", or after grill-me produces clear requirements.
---

# write-a-design

Bridge the gap between the roadmap and the spec. A design doc is not a spec —
it is the document that makes the spec reviewable before a single AC is written.

See [REFERENCE.md](REFERENCE.md) for diagram templates and the decision record format.

## Philosophy

A design doc answers one question: *can we build this without breaking what we have?*
An engineer should be able to read it in five minutes and say yes or no.
If it takes longer than that, it has too much detail — that detail belongs in the spec.

---

## Step 0 — Apply DVR before touching any technology claim

Read `docs/ai-context.md`. The Tech Currency Rule applies to this entire session.
Before recommending any package, API shape, or language feature: Doubt, Verify, Reference.
If verification is not possible, flag it explicitly — never assert from training alone.

---

## Step 1 — Load context

Read in this order:
1. `docs/ai-context.md` — guardrails, pinned versions, DVR rule
2. `docs/architecture.md` — layer rules, dependency directions
3. `docs/current-state.md` — active phase, current constraints
4. `docs/roadmap.md` — where this feature sits in the plan

If any of these are missing, ask before proceeding — do not design against assumptions.

---

## Step 2 — Confirm the feature intent

Ask or infer from context:

> "In one sentence: what does this feature do and who benefits from it?"

If grill-me has already run, the intent is established — do not re-run the interview.
If intent is unclear, ask one question at a time until it is clear. Do not proceed
with a fuzzy target.

---

## Step 3 — Produce the design document

Generate the document section by section. Show a preview of each diagram before
moving to the next section. The full document is previewed before saving.

### 3a — Component diagram

Show what is being added and where it sits in the layer structure.
Use the component diagram template from REFERENCE.md.

Rules:
- Every new component must land in exactly one layer
- Dependency arrows must respect the inward rule: Api → Application → Domain ← Infrastructure
- If a new component would violate a layer boundary, stop and surface it immediately —
  this is the architectural break the diagram exists to catch
- Label each arrow with the interface name, not the concrete type

### 3b — Sequence diagram (if applicable)

Show the happy-path request flow through the new components.
Omit if the feature adds no new request path (e.g., pure domain model change).

Use the sequence diagram template from REFERENCE.md.

### 3c — Design decisions

Document every non-obvious choice. Minimum two decisions for any non-trivial feature.
Use the format from REFERENCE.md: decision → rationale → alternative considered → why rejected.

For any decision that involves a package or API:
- Apply DVR: verify the claim against pinned versions before including it
- Include the reference URL inline: `([source](url))`
- If unverifiable in this session: mark as `[VERIFY]` and flag for human review

### 3d — Interfaces introduced or modified

List every interface that is new or changed. For each:
- Name and layer it lives in
- Method signatures (concise — not full implementation)
- Whether it is new or modified

### 3e — Explicit scope boundary

Two lists, no ambiguity:

**In scope:** what this design covers
**Out of scope:** what it explicitly does not cover and where those concerns belong

---

## Step 4 — Save the document

Target path: `docs/decisions/<feature-branch-name>/design.md`

Show the complete document as a preview. Ask:
**"Does this accurately capture the design? Should I save it?"**

Do not save without explicit confirmation.

---

## Step 5 — Flag for spec-review

After saving, prompt:

> "Design doc is ready. Next step: run write-a-spec to produce the detailed spec,
> then spec-review for the engineer's pre-implementation review."

If the component diagram surfaced a layer violation or an unresolvable DVR flag,
surface those as blocking issues before recommending write-a-spec.