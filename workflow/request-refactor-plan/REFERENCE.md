# Request Refactor Plan — Reference

## One-time label setup

```bash
gh label create "rfc" --color "0075ca" --description "Request for comments — needs review before implementation"
gh label create "refactor" --color "e4e669" --description "Refactoring work — no new behavior"
```

---

## RFC issue template

```md
## Problem Statement

The problem the developer is facing, from the developer's perspective. What is painful, fragile,
or hard to extend about the current state?

## Solution

The chosen approach and why it was selected over alternatives considered.

## Commits

A detailed, ordered implementation plan. Each commit leaves the codebase in a working,
buildable, passing state (dotnet build + dotnet test green after every step).

1. **Commit 1**: [description of smallest safe first step]
2. **Commit 2**: [next step]
3. ...

## Decision Document

Implementation decisions made during the interview:

- Modules being built or modified
- Interface changes
- Architectural decisions
- Schema changes (include EF Core migration notes if applicable)
- API contract changes (note any breaking changes)
- Dependencies added, removed, or restructured

Do NOT include specific file paths or code snippets — these go stale quickly.

## Testing Decisions

- What makes a good test for this area: test external behavior, not implementation details
- Which modules will be tested
- Whether characterization tests are needed before refactoring begins
- Prior art: similar test patterns already in the codebase to follow

## Out of Scope

What is explicitly NOT changing in this refactor. Be specific.

## Further Notes

Any additional context, risks, or open questions.
```

---

## Tiny commit checklist

Before finalizing the commit plan, verify each commit:

- [ ] `dotnet build` passes after this commit alone
- [ ] `dotnet test` passes after this commit alone
- [ ] No commit "breaks things temporarily to fix them later"
- [ ] Each commit has a single, describable purpose
- [ ] A reviewer could understand the intent of each commit in isolation
