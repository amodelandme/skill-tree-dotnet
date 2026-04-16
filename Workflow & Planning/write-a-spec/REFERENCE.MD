# write-a-spec — Reference

## Acceptance criteria format

Use Given/When/Then for behavioural ACs. Use declarative format when the
behaviour is a constraint rather than a flow.

**Given/When/Then:**
```md
### AC-N: [Behaviour name — short, descriptive]

Given [precondition — system state before the action],
when [action — what the caller does],
then [outcome — what the system must do].

**Rules:**
- [Specific constraint for this AC]
- [Another constraint]
```

**Declarative (for constraints):**
```md
### AC-N: [Constraint name]

[The system must / must not] [observable behaviour].

**Rules:**
- [Specific rule]
```

**What makes a good AC:**
- Observable: can be verified without reading source code
- Independent: each AC can be tested in isolation
- Specific: names the interface, the status code, the field — never "handles errors correctly"
- Error cases are first-class ACs — never grouped as "error handling"

**What makes a bad AC:**
- "The service validates the request" — not observable, describes implementation
- "Handles all edge cases" — not specific
- "Returns an error" — what error? What status? What body?

---

## Scope table format

```md
| # | Action   | File                                      |
|---|----------|-------------------------------------------|
| 1 | Create   | `Domain/Entities/<Entity>.cs`             |
| 2 | Create   | `Application/Services/<Feature>Service.cs`|
| 3 | Modify   | `Application/DependencyInjection.cs`      |
| 4 | Modify   | `Api/Controllers/<Feature>Controller.cs`  |
```

**Actions:** Create / Modify / Delete (rare — note why)

The scope table is the contract. If a file is touched during implementation
that is not in this table, either:
- The spec missed it (document in Spec Gaps Resolved in implementation-notes.md), or
- The implementation went out of scope (document in Deviations from Spec)

---

## Definition of Done baseline

Every spec inherits this baseline. Add feature-specific items above the baseline.

```md
## Definition of Done

- [ ] [Feature-specific deliverable — named file, not "implement the feature"]
- [ ] [Feature-specific behavioral check — named endpoint, named status code]
- [ ] [Feature-specific behavioral check — error path]
- [ ] `dotnet build <SolutionName>.sln` → 0 errors, 0 warnings
- [ ] All unit tests passing: `dotnet test --filter "Category!=Integration"`
- [ ] Formatter check → 0 violations
- [ ] Foundation docs updated: current-state.md, roadmap.md
- [ ] Handoff Notes reviewed and all open questions resolved
```

Feature-specific items must be specific enough to verify. "Tests passing" is
not a feature-specific item — it is the baseline. "Unit tests for
`FlagService.IsEnabledAsync` — happy path, archived flag, unknown flag name"
is a feature-specific item.

---

## Handoff Notes for Engineer format

Added as the final section of every spec, after Definition of Done.
This is the architect's pre-emptive brief to the engineer — known ambiguities,
anticipated questions, and explicit decisions that must not be changed without
coming back to the architect.

```md
## Handoff Notes for Engineer

> These notes exist to reduce the spec-review round-trip. Read them before
> raising a review issue — the answer may already be here.

### Anticipated questions

**[Question the engineer is likely to ask]**
[Answer — or explicit acknowledgement that it is open and needs resolution]

**[Another anticipated question]**
[Answer]

### Decisions that must not be changed without architect sign-off

- [Decision 1 — e.g., "Validation runs in the controller, not a filter. This is deliberate — see Design Decision 2."]
- [Decision 2]

### Open questions (must resolve before implementation begins)

- [ ] [Unresolved question — e.g., "[VERIFY] FluentValidation Must() lambda behaviour with null inputs — check docs.fluentvalidation.net"]
- [ ] [Another open question]

> If this section has unchecked items, spec status must remain Draft.
> Do not begin implementation with open questions.
```

**The Handoff Notes section is required.** If there are no anticipated questions
and no open items, write "None — spec is self-contained." Do not omit the section.

---

## Learning Opportunities format

Minimum two entries per spec. Required, not optional.

```md
## Learning Opportunities

### [Concept — specific to this feature, not generic]

[2–4 sentences. Concrete and .NET-specific. Tied to what this feature actually
does. Name the common misconception if one exists.]
```

Good learning opportunity: "Why `JsonSerializerOptions` must not be allocated
per-call in middleware — this feature's middleware allocates one static instance,
which avoids a documented .NET performance anti-pattern."

Bad learning opportunity: "This feature uses dependency injection." (generic,
not tied to a decision made in this spec)

---

## DVR inline citation format

For any claim in Technical Notes that involves a package or API:

```md
### Package prerequisite

Add `Asp.Versioning.Mvc` v8.x ([NuGet](https://www.nuget.org/packages/Asp.Versioning.Mvc),
[docs](https://github.com/dotnet/aspnet-api-versioning)) — verified against .NET 10.
```

For unverified claims:

```md
### [Claim title]

[VERIFY] [The claim]. Could not verify against pinned stack in this session.
Human review required before implementation begins.
```

`[VERIFY]` flags block spec approval. Every flag must be resolved before
the spec status moves from Draft to Approved.