---
name: triage-issue
description: Triage a bug or issue by exploring the codebase to find root cause, then draft a GitHub issue with a TDD-based fix plan for user review before filing. Use when user reports a bug, wants to file an issue, mentions "triage", or wants to investigate and plan a fix for a problem.
---

# Triage Issue

Investigate a reported problem, find its root cause, and draft a GitHub issue with a TDD fix plan. Hands-off investigation — minimize questions. Human reviews the draft before it's filed.

See [REFERENCE.md](REFERENCE.md) for the issue template.

## Process

## Step 0 — Check for project documentation

Before reading any code, ask:

> "Do you have project docs — architecture notes, current state, 
> or a roadmap? If so, where do they live?"

If docs exist, read them first. They may answer questions the 
code can't. Then proceed with the trail below.

### 1. Capture the problem

Get a brief description from the user. If they haven't provided one, ask ONE question: "What's the problem you're seeing?"

Do NOT ask follow-up questions. Start investigating immediately.

### 2. Explore and diagnose

**If running in Claude Code**: use the Agent tool to deeply investigate the codebase in parallel with responding.

**If running in Claude.ai**: investigate the codebase directly before responding.

Your goal is to find:

- **Where** the bug manifests — entry points, API responses, domain behavior
- **What** code path is involved — trace the flow end to end
- **Why** it fails — root cause, not just symptom
- **What** related code exists — similar patterns, tests, adjacent modules

Look at:
- Related source files and their dependencies
- Existing tests — what's covered, what's missing
- Recent changes to affected files (`git log` on relevant files)
- Error handling along the code path
- Similar patterns elsewhere in the codebase that work correctly

### 3. Identify the fix approach

Based on investigation, determine:
- The minimal change needed to fix the root cause
- Which modules and interfaces are affected
- What behaviors need to be verified via tests
- Whether this is a regression, missing feature, or design flaw

### 4. Design the TDD fix plan

Create a concrete, ordered list of RED-GREEN cycles. Each cycle is one vertical slice:

- **RED**: Describe a specific failing test that captures the broken behavior
- **GREEN**: Describe the minimal code change to make that test pass

Rules:
- Tests verify behavior through public interfaces — not implementation details
- One vertical slice at a time — NOT all tests first, then all code
- Each test should survive internal refactors
- Include a REFACTOR step if cleanup is needed after all tests pass

### 5. Draft and review

Write the full issue body using the template in REFERENCE.md. Show it to the user for review. Do NOT write the file until approved.

Once approved, write to `chores/<id>.md`:

```markdown
---
id: <kebab-case-id>
title: <title>
type: AFK
status: open
blocked-by: []
parent-prd: null
---

<issue body from REFERENCE.md template>
```

Share a one-line summary of the root cause. Tell the user: `ralph/once.sh` can pick this up immediately.
