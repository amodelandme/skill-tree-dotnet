---
name: request-refactor-plan
description: Plan a safe incremental refactor via detailed user interview, then file it as a reviewed GitHub issue RFC with tiny commits. Use when user wants to plan a refactor, create a refactoring RFC, or break a refactor into safe incremental steps.
---

# Request Refactor Plan

Plan a safe incremental refactor through deep interview. File it as a GitHub issue RFC — draft first, user reviews, then create.

See [REFERENCE.md](REFERENCE.md) for the RFC issue template.

## Process

You may skip steps that are clearly not necessary for the scope at hand.

## Step 0 — Check for project documentation

Before reading any code, ask:

> "Do you have project docs — architecture notes, current state, 
> or a roadmap? If so, where do they live?"

If docs exist, read them first. They may answer questions the 
code can't. Then proceed with the trail below.

### 1. Understand the problem

Ask the user for a detailed description of:
- The problem they're experiencing (not the solution)
- Any ideas they already have for solving it
- What triggered this refactor now

### 2. Explore the codebase

Verify the user's assertions. Understand the current state of the affected code — its shape, its dependencies, its test coverage.

### 3. Present alternatives

Before committing to a direction, ask whether they've considered other approaches. Present 2-3 alternatives with trade-offs. Let the user choose or confirm their original direction.

### 4. Interview deeply

Go through every aspect of the implementation:
- Exact scope: what changes, what stays the same
- Layer impact: which layers are touched
- Dependency changes: anything added, removed, or restructured
- Schema changes: any EF Core migrations required
- API contract changes: any breaking changes to endpoints or response shapes
- Risk surface: where could this go wrong

Do not move on until scope is locked.

### 5. Check test coverage

Look at test coverage for the affected area. If coverage is thin or missing:
- Flag it explicitly
- Ask the user: "Do you want to write characterization tests before refactoring, or proceed with the risk noted in the RFC?"

### 6. Break into tiny commits

Write the implementation as a sequence of the smallest possible commits. Each commit must leave the codebase in a **working, buildable, passing state** — `dotnet build` and `dotnet test` green after every step.

Follow Martin Fowler's rule: *"Make each refactoring step as small as possible, so that you can always see the program working."*

### 7. Draft the RFC issue

Using the template in REFERENCE.md, write the full issue body and present it to the user for review. Do NOT create the issue until the user approves.

Once approved:

```
gh issue create --title "<title>" --body "<body>" --label "rfc,refactor"
```

Share the issue URL.
