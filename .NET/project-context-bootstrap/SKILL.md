---
name: project-context-bootstrap
description: Bootstrap or refresh a three-document living context system (architecture.md, current-state.md, roadmap.md) and a thin CLAUDE.md router for any .NET project. Detects what exists, audits for gaps, generates missing docs from interview + codebase reading, and surfaces drift between docs and actual code in refresh mode. Model-agnostic context — CLAUDE.md adapts to Claude Code, Cursor, or any AI tool. Use when the user says "bootstrap my project context", "generate a CLAUDE.md", "set up my living docs", "my docs are out of date", or "onboard an AI to my project".
---

# project-context-bootstrap

Bootstrap a living context system for your project. Keep it honest as the code evolves.

See [REFERENCE.md](REFERENCE.md) for doc templates, interview question sets, and conflict detection patterns.

## Philosophy

An AI assistant is only as good as the context it has. A `CLAUDE.md` that points nowhere is noise. Three living docs that drift from the codebase are worse than nothing — they actively mislead. This skill generates the context system, then keeps it honest.

Conservative by default. Every generated or updated document is shown as a preview before saving.

---

## Step 1 — Ask before reading anything

Before touching the filesystem or reading any code, ask:

> "Do you have existing project documentation — architecture notes, a roadmap, a current state doc? If so, where do they live? (e.g. `docs/`, project root, `_dev/`) If not, just say none and I'll read the codebase directly."

> "What is the root of your project? (path or confirm it's the current directory)"

This prevents blind filesystem searching and keeps token usage tight. Two questions upfront beats hundreds of tokens of exploratory reads.

---

## Step 2 — Audit what exists

Check for the four files that make up the context system:

| File | Purpose |
|---|---|
| `CLAUDE.md` (or equivalent) | AI router — quick context + doc pointers + skill library |
| `docs/architecture.md` | Architecture decisions, layer rules, patterns |
| `docs/current-state.md` | What's built, what's not, what not to do, AI notes |
| `docs/roadmap.md` | Product vision, phases, current focus |

Present a gap report:

```
## Context system audit

✅ CLAUDE.md — found at project root
❌ docs/architecture.md — missing
✅ docs/current-state.md — found
⚠️  docs/roadmap.md — found but may need refresh (last modified > 30 days ago)

What would you like to do?
1. Generate missing docs
2. Refresh existing docs
3. Both
4. Just update CLAUDE.md
```

Do not generate or modify anything yet. Wait for the developer's choice.

---

## Step 3 — Execute based on choice

### Generating missing docs

**`roadmap.md` and `architecture.md`** — generated via interview.

Vision and architectural decisions require human input. The codebase cannot tell you what you intended. Run the relevant interview from REFERENCE.md, then generate a draft.

Show preview. Ask: **"Should I save this to `docs/roadmap.md`?"**

**`current-state.md`** — generated codebase-first.

What's built is what's there — the code doesn't lie. Read the codebase (see trail below), then draft `current-state.md` from what's actually present. Developer reviews and corrects before saving.

Show preview. Ask: **"Does this accurately reflect the current state? Should I save it?"**

**`CLAUDE.md`** — generated last, after the three docs exist.

The router is only useful once it has something to point to. Generate it from the confirmed doc locations and the developer's skill library path. See REFERENCE.md for the template.

Show preview. Ask: **"Should I save this as `CLAUDE.md` at the project root?"**

### Refresh mode

When docs exist, run conflict detection before proposing any updates.

#### Codebase trail for conflict detection

Read in this order — targeted, not exploratory:

1. `.sln` file — project graph, how many projects, how they relate
2. Root docs first — `README.md`, any existing architecture or context files
3. Each `.csproj` — packages installed, project references
4. Layer entry points — `Program.cs`, `DbContext`, key interfaces (`I*Service`, `I*Repository`)
5. `Migrations/` folder — latest migration name and date
6. Test projects — what's covered, test counts if available
7. CI workflow files (`.github/workflows/`) — what jobs exist

#### Surface conflicts

Compare what the docs say against what the codebase shows. Flag mismatches:

```
⚠️  Conflict detected in current-state.md

  Doc says:     "Phase 7 — .NET SDK: not yet built"
  Codebase shows: Banderas.Client project found in solution

  Is the SDK further along than the doc reflects?
  (y) Update the doc / (n) Leave as-is / (s) Skip this conflict
```

One conflict at a time. Developer decides what's true. Skill updates on confirmation only.

#### Update scope

After all conflicts are resolved, propose targeted section updates — never rewrite a full doc. Show a diff-style preview:

```
## Proposed update to current-state.md

Section: Status Summary
- **Phase 1 — Unit Tests: 🔄 In Progress**
+ **Phase 1 — Unit Tests: ✅ Complete**
+ 81 unit tests passing

Accept? (y/n)
```

---

## CLAUDE.md structure

The router has three sections — never more:

```md
# [Project Name]

## Quick context
[5-10 lines maximum — stack, architecture pattern, the one or two things
that cause the most damage if an AI gets them wrong]

## Project docs
Read these before touching anything:
- docs/architecture.md   — layer rules, patterns, architectural decisions
- docs/current-state.md  — what's built, what's not, what not to do
- docs/roadmap.md        — product vision, phases, current focus

## Skills
[wired skill references — paths to SKILL.md files in the developer's skill library]
```

The quick context block is strictly bounded. If a rule is important enough to live at the top level, it belongs there. Everything else belongs in the three docs.

---

## Portability note

`CLAUDE.md` is Claude Code's convention. The same content works elsewhere:

| Tool | File | Notes |
|---|---|---|
| Claude Code | `CLAUDE.md` | Native support |
| Cursor | `.cursorrules` | Paste quick context + doc summaries |
| GitHub Copilot | `.github/copilot-instructions.md` | Same structure |
| Any AI tool | `AI_CONTEXT.md` | Universal fallback name |

The three living docs (`architecture.md`, `current-state.md`, `roadmap.md`) are model-agnostic by design — any tool can read them.
