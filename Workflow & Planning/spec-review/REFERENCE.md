# spec-review — Reference

## Review checklist

Work through every item. Mark each: ✅ PASS | ⚠️ ISSUE | N/A

---

### 1. Architectural integrity

- [ ] Every new component in the scope table is assigned to exactly one layer
- [ ] No dependency arrow in the design doc's component diagram violates the
      inward rule: `Api → Application → Domain ← Infrastructure`
- [ ] No domain entity appears in any `I<Feature>Service` method signature
- [ ] No `DbContext` reference exists outside Infrastructure
- [ ] No business logic is assigned to a controller in any AC
- [ ] No `try/catch` block is required in any controller by any AC
- [ ] If the feature crosses a layer boundary in a non-obvious way, the design
      doc explicitly justifies it

**Raise as blocking** if any item fails — layer violations propagate and are
expensive to reverse after implementation.

---

### 2. Spec completeness

**Acceptance criteria:**
- [ ] Every AC describes an observable, externally verifiable outcome
- [ ] Every AC names the specific interface, endpoint, status code, or field it governs —
      never "handles errors" or "validates correctly"
- [ ] Error cases have their own numbered ACs — not grouped or described in prose
- [ ] Every happy-path AC has at least one corresponding error-path AC

**Scope table:**
- [ ] Every file in the scope table maps to at least one AC
- [ ] Every AC maps to at least one file in the scope table
- [ ] No obvious file is missing — walk through each AC and ask "what file changes?"
- [ ] File Layout section matches the scope table

**Definition of Done:**
- [ ] Every DoD item is specific enough to verify without reading the spec again
- [ ] DoD includes `dotnet build` → 0 errors, 0 warnings
- [ ] DoD includes `dotnet test` (appropriate filter)
- [ ] DoD includes formatter check
- [ ] DoD includes foundation docs update
- [ ] Handoff Notes open questions are listed in DoD as required pre-conditions

**Raise as blocking** if: an AC is unverifiable, a file is missing from scope,
or the DoD would not catch a regression.

---

### 3. DVR compliance

- [ ] No `[VERIFY]` flags remain unresolved in the spec
- [ ] Every package recommendation in Technical Notes has a reference URL
- [ ] Every version-specific API claim in Technical Notes has a reference URL
- [ ] No package version cited in the spec contradicts the pinned versions in `ai-context.md`
- [ ] Any package marked `verify always` in `ai-context.md` has been verified
      in this session and cited

**Raise as blocking** if: a `[VERIFY]` flag is unresolved, or a package version
contradicts the pinned stack. A spec with unresolved DVR flags cannot be approved.

**How to verify during review:**
If a claim looks suspicious, use the Microsoft Learn MCP or official package docs
to verify it now. If verified, add the citation. If contradicted, raise as blocking.

---

### 4. Internal consistency

**Spec vs design doc:**
- [ ] ACs are consistent with the component diagram — no AC requires a component
      not shown in the diagram
- [ ] Out of Scope section matches the design doc's explicit out-of-scope boundary
- [ ] Interfaces listed in the spec match those introduced or modified in the design doc

**Spec vs architecture.md:**
- [ ] Spec follows all naming conventions from `ai-context.md`
- [ ] No AC requires a pattern explicitly prohibited in `ai-context.md`
  (e.g., `try/catch` in controllers, naked entities in service signatures)
- [ ] Validation placement matches the convention: boundary validation in controller,
      domain rules in domain layer

**Spec vs current-state.md:**
- [ ] No AC depends on infrastructure flagged as "Not Yet Built"
- [ ] No AC violates a constraint in "What Not To Do Right Now"
- [ ] Spec phase matches the active phase in current-state.md
- [ ] No AC would close a Known Issue without that KI being referenced

**Raise as blocking** if: the spec contradicts an established convention, depends on
infrastructure that does not exist, or violates a current-phase constraint.

---

### 5. Implementation feasibility

For each AC, mentally trace the implementation path:

- [ ] The AC can be satisfied by code that fits within the declared scope table
- [ ] The AC does not implicitly require files or packages not listed in Technical Notes
- [ ] No AC requires a pattern not established in the codebase or explicitly introduced
      in this spec
- [ ] The sequence of implementation steps implied by the scope table is coherent —
      no circular dependency between new files
- [ ] The test strategy implied by the DoD is achievable with the test infrastructure
      described in `ai-context.md`

**Raise as non-blocking** if a feasibility concern exists but does not block
implementation — flag it as an implementation note for the engineer's awareness.

**Raise as blocking** if an AC is genuinely not implementable as written.

---

### 6. Handoff Notes

- [ ] All items in "Open questions" are resolved or explicitly carried as `[VERIFY]` flags
- [ ] "Decisions that must not be changed without architect sign-off" list is acknowledged —
      if the engineer disagrees with any locked decision, raise it now as a non-blocking issue
- [ ] No open question in Handoff Notes is also a DoD item without a resolution path

**Raise as blocking** if: Handoff Notes contain unresolved open questions and the
spec status is not Draft.

---

## Review report format

```md
# Spec Review — <Feature Name>

**Date:** <YYYY-MM-DD>
**Spec:** `docs/decisions/<feature-branch-name>/spec.md`
**Design doc:** `docs/decisions/<feature-branch-name>/design.md`
**Verdict:** Approved | Approved with Notes | Revise and Resubmit

---

## Blocking issues

> Must be resolved before implementation begins.
> Re-run spec-review after each revision.

### B-1 — [Short title]

**Location:** [Section and item — e.g., "AC-3, scope table"]
**Issue:** [What is wrong — specific, not general]
**Required fix:** [What the spec must say instead]

---

### B-2 — [Short title]

[Same format]

---

## Non-blocking issues

> Should be addressed but will not prevent implementation from starting.

### N-1 — [Short title]

**Location:** [Section]
**Issue:** [What could be improved]
**Suggestion:** [What to change]

---

## Implementation notes

> Engineer's perspective. No action required from architect.
> These inform implementation decisions, not spec revisions.

- [Note 1 — e.g., "The validator registration in TN-1 can use the
  `AddValidatorsFromAssembly` overload introduced in FV v11 — simpler than
  manual registration. Verified: docs.fluentvalidation.net/en/latest/di.html"]
- [Note 2]

---

## Checklist summary

| Category | Result |
|---|---|
| Architectural integrity | ✅ / ⚠️ [N issues] |
| Spec completeness | ✅ / ⚠️ [N issues] |
| DVR compliance | ✅ / ⚠️ [N issues] |
| Internal consistency | ✅ / ⚠️ [N issues] |
| Implementation feasibility | ✅ / ⚠️ [N issues] |
| Handoff Notes | ✅ / ⚠️ [N issues] |
```

---

## Verdict routing

| Verdict | Condition | Next step |
|---|---|---|
| **Approved** | Zero blocking issues | Run `engineer.md` |
| **Approved with Notes** | Zero blocking, one or more non-blocking | Run `engineer.md`, architect may address notes async |
| **Revise and Resubmit** | One or more blocking issues | Present blocking issues to architect, revise spec, re-run spec-review |

**Important:** A "Revise and Resubmit" verdict is not a failure — it is the system
working correctly. The spec-review loop exists to catch issues cheaply. One revision
cycle here costs far less than discovering the same issue during implementation.