---
name: spec-review
description: Pre-implementation spec validation from the engineer's perspective. Reads the design doc and spec, runs a systematic review against architecture rules, AC completeness, DVR compliance, scope consistency, and implementation feasibility. Produces a structured review report with blocking issues, non-blocking issues, and implementation notes. Blocks implementation if blocking issues exist. Use after write-a-spec produces a Draft spec and before any code is written. Triggers: "review the spec", "spec-review", "engineer review", "validate the spec".
---

# spec-review

Read the spec as an implementer. Find every gap, contradiction, and architectural
violation before a single line of code is written. Cheap to fix on paper.
Expensive to fix in code.

See [REFERENCE.md](REFERENCE.md) for the review checklist and report format.

## Philosophy

The engineer's job in this review is adversarial — constructively so. The goal
is to break the spec before the implementation does. Every issue raised here
saves at least one review round after the fact.

One rule: **raise issues against the spec, not against the design intent.**
If the spec's AC is ambiguous, raise it. If you disagree with the architectural
approach, that is a design-doc conversation — not a spec-review finding.

---

## Step 0 — Apply DVR

Read `docs/ai-context.md`. DVR applies to this review session.
Any technology claim in the spec that lacks a citation is a finding.
Any `[VERIFY]` flag that remains unresolved is a blocking issue.

---

## Step 1 — Load all context

Read in this order. Do not skip any document.

1. `docs/ai-context.md` — layer rules, DVR rule, pinned versions, conventions
2. `docs/decisions/<feature-branch-name>/design.md` — the L2 source of truth
3. `docs/decisions/<feature-branch-name>/spec.md` — the document under review
4. `docs/architecture.md` — existing patterns, request flows, boundaries
5. `docs/current-state.md` — active constraints, known issues, what not to do now

If any document is missing, stop and report it — the review cannot proceed
without the full context.

---

## Step 2 — Run the review checklist

Work through every category in REFERENCE.md systematically. For each item,
mark: PASS / ISSUE / N/A.

Do not skip categories because they seem unlikely to have issues.
The most damaging issues are the ones that seem unlikely.

Categories (full checklist in REFERENCE.md):
1. Architectural integrity — layer violations, dependency directions
2. Spec completeness — ACs, scope table, file layout, DoD
3. DVR compliance — verify flags, missing citations, suspicious versions
4. Internal consistency — spec vs design doc, spec vs architecture.md, spec vs current-state.md
5. Implementation feasibility — can each AC be traced to buildable code?
6. Handoff Notes — open questions resolved, locked decisions acknowledged

---

## Step 3 — Produce the review report

Do not produce a running commentary. Produce a single structured report
after completing the full checklist. Format from REFERENCE.md.

Report structure:
- **Verdict** — one of three outcomes (see below)
- **Blocking issues** — numbered, must be resolved before implementation
- **Non-blocking issues** — numbered, should be addressed but will not stop work
- **Implementation notes** — engineer's perspective, no action required from architect

**Verdict: Approved**
No blocking issues. Implementation may begin.
Spec status should be updated to `Approved`.

**Verdict: Revise and Resubmit**
One or more blocking issues. Implementation must not begin.
Architect addresses blocking issues and re-runs write-a-spec or targeted edits.
Engineer re-runs spec-review after revision.

**Verdict: Approved with Notes**
No blocking issues. Non-blocking issues and/or implementation notes exist.
Implementation may begin. Architect may address non-blocking issues in a
follow-up or leave them for the engineer to resolve during implementation.

---

## Step 4 — Save the report

Target path: `docs/decisions/<feature-branch-name>/spec-review.md`

Show the complete report as a preview. Ask:
**"Should I save this review report?"**

Do not save without confirmation.

---

## Step 5 — Route based on verdict

**If Approved or Approved with Notes:**
> "Spec is approved. Next step: run engineer.md to begin implementation."

**If Revise and Resubmit:**
> "Spec has [N] blocking issue(s). Present this report to the architect.
> After the spec is revised, re-run spec-review before implementation begins."

List the blocking issues in summary form — one line each — so they can be
copied directly to the architect session without reading the full report.