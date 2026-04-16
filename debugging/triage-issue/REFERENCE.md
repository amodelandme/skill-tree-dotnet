# Triage Issue — Reference

## Issue template

```md
## Problem

A clear description of the bug or issue:
- What happens (actual behavior)
- What should happen (expected behavior)
- How to reproduce (if known)

## Root Cause Analysis

What was found during investigation:
- The code path involved
- Why the current code fails
- Any contributing factors

Do NOT include specific file paths, line numbers, or implementation details
tied to current code layout. Describe modules, behaviors, and contracts instead.
The issue should remain useful even after major refactors.

## TDD Fix Plan

A numbered list of RED-GREEN cycles:

1. **RED**: Write a test that verifies [specific expected behavior]
   **GREEN**: [Minimal change to make it pass]

2. **RED**: Write a test that verifies [next expected behavior]
   **GREEN**: [Minimal change to make it pass]

**REFACTOR**: [Any cleanup needed after all tests pass — or omit if none needed]

## Acceptance Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] All new tests pass
- [ ] Existing tests still pass
```

---

## Durability rules

The issue should survive a major refactor and still be actionable. Before filing, verify:

- [ ] No file paths or line numbers referenced
- [ ] Describes behaviors and contracts, not internal structure
- [ ] Root cause described in terms of modules and interfaces, not specific classes
- [ ] TDD plan tests observable outcomes (API responses, domain behavior) not internal state
- [ ] A developer unfamiliar with the current code layout could still act on this issue
