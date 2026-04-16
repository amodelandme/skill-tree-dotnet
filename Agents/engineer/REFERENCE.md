# engineer — Reference

## Pre-implementation gate checklist

```
[ ] Spec status is Approved (not Draft, not Ready for Review)
[ ] No unresolved [VERIFY] flags in spec.md or design.md
[ ] git status → working tree clean on the correct branch
[ ] dotnet build <SolutionName>.sln → 0 errors, 0 warnings
[ ] dotnet test --filter "Category!=Integration" → all passing
[ ] Scope table reviewed — implementation order planned (lower layers first)
```

Report this checklist explicitly before writing any code.
A failed gate check is not a blocker to report and ignore —
it must be resolved before implementation begins.

---

## Implementation loop — file by file

```
FOR EACH file in scope table (dependency order: Domain → Application → Infrastructure → Api):

  1. READ the ACs that govern this file
     - Which ACs name this file or its component?
     - What behavior must be true when this file is complete?

  2. RED — write the failing tests
     - One test per AC behaviour, plus edge cases
     - Tests must fail before writing implementation code
     - Test names: MethodName_StateUnderTest_ExpectedBehavior

  3. GREEN — write minimum code to pass
     - No gold-plating. The goal is passing tests, not perfect code.
     - If you find yourself adding untested behavior, stop.

  4. REFACTOR — clean without changing behavior
     - Tests still pass after refactor
     - Remove duplication, improve naming, enforce conventions from ai-context.md

  5. VERIFY against spec
     - Read the relevant ACs again
     - Does the implementation satisfy them exactly?
     - Is there anything implemented that is NOT in the ACs? (scope creep — remove it)

  6. dotnet build → 0 errors before moving to the next file
```

---

## Spec gap protocol

A spec gap is anything discovered during implementation that the spec did not
address — an ambiguous AC, a missing file, a contradicted convention, an
impossible requirement.

**The protocol — three steps, no exceptions:**

**1. Stop.** Do not work around the gap silently. Do not invent a solution
and keep going. The spec is the contract. Silent deviations break the contract.

**2. Resolve.** For trivial gaps (an obviously-implied method, a missing
`using` directive, a naming inconsistency): resolve with minimum deviation and
document the resolution. For substantive gaps: pause and surface the issue —
either by asking the developer or by flagging it in implementation-notes.md
and noting the decision made.

**3. Document.** Every gap gets an entry in implementation-notes.md:
- Spec Gaps Resolved — if the spec was incomplete and you resolved it
- Deviations from Spec — if the implementation deliberately differs from the spec

**What counts as a gap:**
- An AC that is ambiguous (could be implemented two valid ways)
- A file the spec didn't list but that obviously needs to change
- A package version that contradicts the pinned stack (DVR violation in the spec)
- A required pattern that conflicts with an existing convention in ai-context.md
- A DoD item that cannot be satisfied as written

**What does NOT count as a gap:**
- Your preference for a different implementation approach
- A refactoring opportunity unrelated to the spec
- A performance optimization the spec didn't ask for

If you're unsure whether something is a gap or a preference, ask.

---

## Layer implementation order

Always implement in this order. Each layer depends on the one below it.

```
1. Domain       — entities, value objects, domain exceptions, interfaces
2. Application  — services, DTOs, validators, mappings
3. Infrastructure — repositories, EF Core configurations, migrations
4. Api          — controllers, middleware, DI registration
5. Tests        — unit tests alongside each layer; integration tests last
```

Within each layer, implement in this order:
1. Interfaces and contracts first (the shape of the thing)
2. Implementations (the behavior)
3. DI registration (wiring it together)
4. Tests (verifying the contract)

---

## DVR during implementation

The spec was approved, but that does not mean every tech claim in it was verified.
The engineer is the last line of defense before code is written.

**When to stop and verify:**
- A package API is cited in Technical Notes but the method signature looks wrong
- A C# language feature is used that you don't recognize for C# 14
- A framework behavior is described that conflicts with what you know from the codebase

**How to verify:**
1. Check learn.microsoft.com for .NET / ASP.NET Core / EF Core claims
2. Check the package's official docs or NuGet page for package-specific claims
3. If verified and correct: proceed
4. If verified and WRONG: this is a blocking spec gap — stop, document, escalate
5. If unverifiable: document as `[VERIFY]` in implementation-notes.md, make a
   conservative implementation decision, flag for review

A DVR violation found during implementation is a Deviation from Spec entry —
document it with the spec's claim, the verified correct behavior, and what was
implemented instead.

---

## Implementation notes section guidance

**What Was Built** — the outcome, not the steps. What does the system do now
that it didn't do before? Write for a new team member reading cold.

**Spec Gaps Resolved** — every place the spec was incomplete. If the spec was
complete, write "None." This section improves future specs — treat it seriously.

**Deviations from Spec** — every place the implementation deliberately differs
from the spec. Includes DVR violations found during implementation.
If there were no deviations, write "None."

**Key Decisions** — decisions made during implementation not specified in the spec,
or where the spec left room for judgement. These are the moves a senior engineer
makes that a junior engineer might not notice. Required if developer-context.md
has `interview lens: yes`.

**Interview Lens** — if developer-context.md has `interview lens: yes`, write
one entry for the most significant engineering decision made in this implementation.
Format: problem → decision → tradeoff → what you'd change at different scale.

**Foundation Docs Updated** — work through the checklist honestly. Mark items
incomplete with a reason if they cannot be done in this session.

**Session Summary** — three sentences. See format below.

---

## Self-test gate — exact commands

```bash
# Build — must be 0 errors, 0 warnings
dotnet build <SolutionName>.sln

# Unit tests — must all pass
dotnet test --filter "Category!=Integration"

# Formatter — must be 0 violations
dotnet format --verify-no-changes <SolutionName>.sln
# or if using CSharpier:
dotnet csharpier --check .
```

All three must pass. A warning in build is a failure — fix it.
A skipped test is not a passing test — fix or explicitly defer with a reason.

---

## Session summary format

Three sentences. Written to be pasted into the next session.
Identical format to architect.md — continuity between sessions is the goal.

```md
## Session summary — <YYYY-MM-DD>

**What was built:** [The specific files created or modified and what they do]
**Where we left off:** [Exact status — PR open / tests failing on X / stopped at file Y]
**Open items:** [Unresolved gaps, [VERIFY] flags, deferred DoD items — or "None"]
```

**Good example:**
> **What was built:** `FlagCacheDecorator` wrapping `IFlagRepository` with
> StackExchange.Redis — TTL from `appsettings.json`, cache-aside pattern,
> all 14 unit tests passing.
> **Where we left off:** PR #42 open, awaiting review. Integration tests
> deferred — need Redis service container in CI (Phase 2).
> **Open items:** [VERIFY] Redis connection string convention for .NET 10
> `IConnectionMultiplexer` registration — flagged in implementation-notes.md.

**Bad example:**
> We implemented the cache. Tests pass. PR is open. Some things need follow-up.