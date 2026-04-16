---
name: prd-to-issues
description: Break a PRD into independently-grabbable GitHub issues using tracer-bullet vertical slices, with HITL/AFK classification and dependency ordering. Use when user wants to convert a PRD to issues, create implementation tickets, or break down a PRD into work items.
---

# PRD to Issues

Break a PRD into independently-grabbable GitHub issues using vertical slices (tracer bullets). Each issue is classified as HITL or AFK and ordered by dependency.

See [REFERENCE.md](REFERENCE.md) for the issue template and one-time label setup.

## Process

## Step 0 — Check for project documentation

Before reading any code, ask:

> "Do you have project docs — architecture notes, current state, 
> or a roadmap? If so, where do they live?"

If docs exist, read them first. They may answer questions the 
code can't. Then proceed with the trail below.

### 1. Locate the PRD

Ask the user for the PRD GitHub issue number (or URL). If not already in context, fetch it:

```
gh issue view <number> --comments
```

### 2. Explore the codebase (if needed)

If you haven't already explored the codebase, do so to understand the current integration layers — schema, API, tests, and any UI layer if present. Only explore what you need to understand the shape of a complete vertical slice in this project.

### 3. Draft vertical slices

Break the PRD into **tracer bullet** issues. Each slice is a thin but complete path through all relevant integration layers — NOT a horizontal slice of one layer.

Each slice is either:
- **HITL** (Human In The Loop): requires a human decision or review before it can progress — architectural choices, design reviews, external approvals
- **AFK** (Away From Keyboard): can be implemented, tested, and merged autonomously

Prefer AFK over HITL wherever possible.

<vertical-slice-rules>
- Each slice delivers a narrow but COMPLETE path through all layers present in the project
- A completed slice is demoable or verifiable on its own
- Prefer many thin slices over few thick ones
- Do NOT include implementation details that are likely to shift — focus on durable behavior
</vertical-slice-rules>

### 4. Quiz the user

Present the proposed breakdown as a numbered list. For each slice show:

- **Title**: short descriptive name
- **Type**: HITL / AFK
- **Blocked by**: which slices must complete first (or "None")
- **User stories covered**: which PRD user stories this addresses

Ask the user:
- Does the granularity feel right? (too coarse / too fine)
- Are the HITL / AFK classifications correct?
- Are the dependency relationships correct?
- Should any slices be merged or split?

Iterate until approved.

### 5. Create GitHub issues

Create issues in dependency order (blockers first) so real issue numbers can be referenced in the "Blocked by" field.

For each issue, apply labels if they exist in the repo — skip gracefully if not. See REFERENCE.md for the recommended label set and one-time setup command.

```
gh issue create --title "<title>" --body "<body>" --label "vertical-slice,afk"
```

Use the issue body template in REFERENCE.md.

Do NOT close or modify the parent PRD issue.
