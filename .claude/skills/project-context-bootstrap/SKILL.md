---
name: project-context-bootstrap
description: Bootstrap or refresh the two-document foundation (architecture.md + conventions.md) and a thin CLAUDE.md router for any .NET project. Detects what exists, audits for gaps, generates missing docs from interview + codebase reading, and surfaces drift between docs and actual code in refresh mode. Refresh mode is callable from /review for foundation-doc drift detection. Use when the user says "bootstrap my project context", "generate a CLAUDE.md", "set up my foundation docs", "my docs are out of date", or "onboard an AI to my project".
---

# project-context-bootstrap

Bootstrap a living context system for your project. Keep it honest as the code evolves.

See [REFERENCE.md](REFERENCE.md) for doc templates, interview question sets, and conflict detection patterns.

## Philosophy

An AI assistant is only as good as the context it has. A `CLAUDE.md` that points nowhere is noise. Foundation docs that drift from the codebase are worse than nothing — they actively mislead. This skill generates the foundation, then keeps it honest.

The queue (`features/`, `chores/`) carries current state and roadmap. The foundation docs carry only the durable shape: layer rules and conventions. That is why there are two foundation docs, not four.

Conservative by default. Every generated or updated document is shown as a preview before saving.

---

## Step 1 — Ask before reading anything

Before touching the filesystem or reading any code, ask:

> "Do you have existing project documentation — architecture notes or convention rules? If so, where do they live? (e.g. `docs/`, project root, `_dev/`) If not, just say none and I'll read the codebase directly."

> "What is the root of your project? (path or confirm it's the current directory)"

This prevents blind filesystem searching and keeps token usage tight. Two questions upfront beats hundreds of tokens of exploratory reads.

---

## Step 2 — Audit what exists

Check for the three files that make up the foundation:

| File | Purpose |
|---|---|
| `CLAUDE.md` (or equivalent) | AI router — quick context + doc pointers + skill library |
| `docs/architecture.md` | Durable shape — layer rules, allowed dependencies, key patterns |
| `docs/conventions.md` | Pinned versions, formatting, DVR rules, naming, error-handling style |

If `docs/current-state.md` or `docs/roadmap.md` are present, flag them as **legacy** — the new model uses `features/` and `chores/` as the live queue, and these files should be retired (after extracting any durable content into architecture/conventions).

Present a gap report:

```
## Foundation audit

✅ CLAUDE.md — found at project root
❌ docs/architecture.md — missing
❌ docs/conventions.md — missing
⚠️  docs/current-state.md — legacy; recommend retiring once content is migrated
⚠️  docs/roadmap.md — legacy; recommend retiring (queue replaces this)

What would you like to do?
1. Generate missing foundation docs
2. Refresh existing foundation docs
3. Both
4. Just update CLAUDE.md
5. Help retire legacy docs
```

Do not generate or modify anything yet. Wait for the developer's choice.

---

## Step 3 — Execute based on choice

### Generating missing docs

**`architecture.md`** — generated via interview + codebase reading.

Architectural decisions require human input. The codebase tells you what is, not what you intended. Run the architecture interview from REFERENCE.md, cross-check against the codebase trail, then draft.

Show preview. Ask: **"Should I save this to `docs/architecture.md`?"**

**`conventions.md`** — generated codebase-first, then confirmed.

Conventions are visible in the code: pinned versions in `.csproj`, formatting in `.editorconfig`, naming in actual files. Read those signals, draft `conventions.md` from what's present, then ask the developer to fill in the conventions that aren't expressible in code (review style, commit message rules, error-handling philosophy).

Show preview. Ask: **"Does this accurately reflect your conventions? Should I save it?"**

**`CLAUDE.md`** — generated last, after the foundation docs exist.

The router is only useful once it has something to point to. Generate it from the confirmed doc locations and the developer's skill library path. See REFERENCE.md for the template.

Show preview. Ask: **"Should I save this as `CLAUDE.md` at the project root?"**

### Refresh mode

When docs exist, run conflict detection before proposing any updates.

**Refresh mode is callable from `/review`.** When `/review` flags foundation-doc drift, it can hand a scoped diff to this skill in refresh mode and receive back a list of proposed edits without re-running the full audit.

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
⚠️  Conflict detected in architecture.md

  Doc says:     "Application layer must not depend on Infrastructure"
  Codebase shows: src/App/Services/UserService.cs imports Infrastructure.Email

  Is this an intentional layer-rule change, or a violation?
  (y) Update the doc / (n) Leave as-is — flag as violation / (s) Skip this conflict
```

One conflict at a time. Developer decides what's true. Skill updates on confirmation only.

#### Update scope

After all conflicts are resolved, propose targeted section updates — never rewrite a full doc. Show a diff-style preview:

```
## Proposed update to conventions.md

Section: Testing
- Test framework: xUnit + FluentAssertions
+ Test framework: xUnit + FluentAssertions + Moq
+ Integration tests live under `tests/*.IntegrationTests` and are tagged `Category=Integration`

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

## Foundation docs
Read these before touching anything:
- docs/architecture.md  — layer rules, allowed dependencies, durable patterns
- docs/conventions.md   — pinned versions, formatting, DVR, naming, error-handling

## Skills
Skills live in `.claude/skills/` (mirrored to `.agents/`). The queue lives in
`features/<slug>/` and `chores/`.
```

The quick context block is strictly bounded. If a rule is important enough to live at the top level, it belongs there. Everything else belongs in the foundation docs or the queue.

---

## Portability note

`CLAUDE.md` is Claude Code's convention. The same content works elsewhere:

| Tool | File | Notes |
|---|---|---|
| Claude Code | `CLAUDE.md` | Native support |
| Cursor | `.cursorrules` | Paste quick context + doc summaries |
| GitHub Copilot | `.github/copilot-instructions.md` | Same structure |
| Any AI tool | `AI_CONTEXT.md` | Universal fallback name |

The two foundation docs (`architecture.md`, `conventions.md`) are model-agnostic by design — any tool can read them.
