---
name: github-triage
description: Triage GitHub issues through a label-based state machine with interactive grilling sessions. Prepares issues for AFK agents or human implementation. Use when user wants to triage issues, review incoming bugs or feature requests, manage issue workflow, or prepare issues for an autonomous agent.
---

# GitHub Issue Triage

Triage issues in the current repo using a label-based state machine. Infer the repo from `git remote`. Use `gh` for all GitHub operations.

See [REFERENCE.md](REFERENCE.md) for the state machine, label setup, agent brief format, and out-of-scope knowledge base.

## Labels

| Label             | Type     | Description                                      |
|-------------------|----------|--------------------------------------------------|
| `bug`             | Category | Something is broken                              |
| `enhancement`     | Category | New feature or improvement                       |
| `needs-triage`    | State    | Maintainer needs to evaluate this issue          |
| `needs-info`      | State    | Waiting on reporter for more information         |
| `afk`             | State    | Fully specified — ready for autonomous agent     |
| `ready-for-human` | State    | Requires human implementation                    |
| `wontfix`         | State    | Will not be actioned                             |

Every issue should have exactly **one** state label and **one** category label. If an issue has conflicting state labels, flag the conflict, give a recommendation, and ask the maintainer which is correct before proceeding.

## Invocation

The maintainer invokes the skill and describes what they want in natural language:

- "Show me anything that needs my attention"
- "Let's look at #42"
- "Move #42 to afk"
- "What's ready for agents to pick up?"
- "Are there any unlabeled issues?"

---

## Workflow: Show What Needs Attention

Query GitHub and present a summary in three buckets:

1. **Unlabeled** — new, never triaged
2. **`needs-triage`** — maintainer needs to evaluate or continue evaluating
3. **`needs-info` with new activity** — reporter has commented since last triage notes

Show counts per group. Within each group, oldest first. For each issue: number, title, age, one-line summary. Let the maintainer pick which to dive into.

---

## Workflow: Triage a Specific Issue

### Step 1: Gather context

Before presenting anything:
- Read the full issue: body, comments, labels, reporter, timestamp
- Parse any prior triage notes to understand what's already established
- Explore the codebase for relevant context — domain behavior, interfaces, existing tests
- Check `.out-of-scope/` for matching prior rejections (see REFERENCE.md)

### Step 2: Present a recommendation

Tell the maintainer:
- **Category**: bug or enhancement, with reasoning
- **State**: where this issue should go, with reasoning
- If it matches a prior out-of-scope rejection, surface it: "This is similar to `.out-of-scope/concept-name.md` — we rejected this before because X. Do you still feel the same way?"
- Brief summary of relevant codebase context

Wait for the maintainer's direction before proceeding.

### Step 3: Bug reproduction (bugs only)

Attempt to reproduce before grilling:
- Read the reporter's reproduction steps
- Trace the relevant code path
- Try to reproduce: run tests, execute commands, trace logic
- Report findings — confirmed reproduction, failed reproduction, or insufficient detail

Confirmed reproduction with a known code path makes for a much stronger agent brief.

### Step 4: Grilling session (if needed)

If the issue needs fleshing out, interview the maintainer one question at a time. Follow the `grill-me` pattern:
- One question at a time
- Provide a recommended answer for each
- If a question can be answered by exploring the codebase, explore instead
- Resume from prior triage notes — never re-ask resolved questions
- For bugs: use reproduction findings to ask targeted questions

Keep going until you have: clear desired behavior, concrete acceptance criteria, key interfaces affected, and a clear out-of-scope boundary.

### Step 5: Preview and apply

Before posting any comment or applying any label, show the maintainer a **preview** of exactly what will be posted and which labels will change. Only proceed on confirmation.

Outcomes:
- **`afk`** — post an agent brief comment (see REFERENCE.md for format), apply label
- **`ready-for-human`** — post a comment summarizing the task and why it needs a human, apply label
- **`needs-info`** — post triage notes with progress + questions for reporter, apply label
- **`wontfix` (bug)** — post a polite explanation, close issue
- **`wontfix` (enhancement)** — write to `.out-of-scope/`, post comment linking to it, close issue

---

## Workflow: Quick State Override

When the maintainer explicitly says to move an issue to a specific state, trust their judgment. Apply the label directly — skip the grilling session.

Still show a confirmation preview of what will change. If moving to `afk` without a grilling session, ask: "Do you want to write a brief agent brief comment, or skip it?"
