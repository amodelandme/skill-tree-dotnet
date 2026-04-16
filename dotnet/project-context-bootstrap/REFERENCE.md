# project-context-bootstrap — Reference

## Doc templates

### CLAUDE.md

```md
# [Project Name]

## Quick context

- **Stack:** ASP.NET Core [version] · EF Core · Postgres · xUnit
- **Architecture:** Clean Architecture — Api → Application → Domain ← Infrastructure
- **Provider:** [SQL Server / Postgres / SQLite]
- **One hard rule:** [The single most dangerous thing an AI could get wrong — e.g. "Do not change Host=postgres to localhost in connection strings"]
- **Current phase:** [Phase N — brief name]

## Project docs

Read these before touching anything:

- `docs/architecture.md`   — layer rules, patterns, architectural decisions, what not to do
- `docs/current-state.md`  — what's built, what's not, known issues, AI assistant notes
- `docs/roadmap.md`        — product vision, phases, current focus

## Skills

- Architecture review:      ~/dev/skill-tree/architecture/improve-codebase-architecture/SKILL.md
- Design an interface:      ~/dev/skill-tree/architecture/design-an-interface/SKILL.md
- TDD loop:                 ~/dev/skill-tree/architecture/tdd/SKILL.md
- Plan a migration:         ~/dev/skill-tree/dotnet/ef-migration-plan/SKILL.md
- Audit my API:             ~/dev/skill-tree/dotnet/dotnet-api-design/SKILL.md
- Quiz me on my codebase:   ~/dev/skill-tree/learning/codebase-trivia/SKILL.md
- Grill my design:          ~/dev/skill-tree/learning/grill-me/SKILL.md
- Write a PRD:              ~/dev/skill-tree/workflow/write-a-prd/SKILL.md
- Break PRD into issues:    ~/dev/skill-tree/workflow/prd-to-issues/SKILL.md
- Plan a refactor:          ~/dev/skill-tree/workflow/request-refactor-plan/SKILL.md
- Triage a bug:             ~/dev/skill-tree/debugging/triage-issue/SKILL.md
```

---

### architecture.md

```md
# Architecture — [Project Name]

## Overview

[2-3 sentences: what the system does and who uses it]

## Architecture pattern

[Clean Architecture / Vertical Slices / Modular Monolith / etc.]

[Dependency diagram — text or Mermaid]
Api → Application → Domain ← Infrastructure

## Layer responsibilities

### Domain
[What lives here — entities, value objects, domain exceptions, interfaces]
[What does NOT live here — EF Core, HTTP types, DTOs]

### Application
[What lives here — service interfaces, DTOs, validators, use case orchestration]
[Key contracts — IBanderasService speaks entirely in DTOs, no entity crosses the boundary]

### Infrastructure
[What lives here — DbContext, repositories, migrations, external service clients]
[Key decisions — which ORM, which provider, how DI is registered]

### Api
[What lives here — controllers or minimal API endpoints, middleware, Program.cs]
[Key decisions — endpoint style, error handling approach, OpenAPI setup]

## Key architectural decisions

| Decision | Choice | Rationale |
|---|---|---|
| Error handling | GlobalExceptionMiddleware | Controllers contain only happy path |
| Validation | FluentValidation v12, manual ValidateAsync | No AutoValidation — deprecated |
| Uniqueness | DbUpdateException catch in Infrastructure | TOCTOU-safe |
| [Add more as decisions are made] | | |

## Patterns in use

[Strategy pattern, Registry pattern, etc. — brief description of each]

## What not to do

[Explicit prohibitions — the things that caused bugs or were deliberately rejected]
- Do not use FluentValidation.AspNetCore or AddFluentValidationAutoValidation()
- Do not catch DbUpdateException in the Application layer
- [Add as the project evolves]

## External dependencies

| Dependency | Purpose | Version |
|---|---|---|
| EF Core | ORM | [version] |
| FluentValidation | Input validation | [version] |
| [etc.] | | |
```

---

### current-state.md

```md
# Current State — [Project Name]

## Table of Contents

- [Status Summary](#status-summary)
- [What Is Completed](#what-is-completed)
- [What Is Not Yet Built](#what-is-not-yet-built)
- [Known Issues](#known-issues)
- [Current Focus](#current-focus)
- [What Not To Do Right Now](#what-not-to-do-right-now)
- [Definition of Done — Current Phase](#definition-of-done--current-phase)
- [Notes for AI Assistants](#notes-for-ai-assistants)

---

## Status Summary

[Phase checklist — one line per phase, status emoji]

**Phase 0 — Foundation: ✅ Complete**
**Phase 1 — [Name]: 🔄 In Progress**

[Test count summary if applicable]
[N/N tests passing (X unit + Y integration)]

---

## What Is Completed

### [Layer / Area]

[Bullet list of completed items — specific, not vague]
[Include class names, method names, PR numbers where relevant]

---

## What Is Not Yet Built

- [ ] [Feature or task — specific enough that an AI knows what it means]

---

## Known Issues

### KI-001 — [Short title]

[Description of the issue]
[Workaround if applicable]
[Longer-term fix if planned]

---

## Current Focus

[1-3 items — what the developer is working on right now]

Phase N DoD is complete when [condition].

---

## What Not To Do Right Now

[Explicit prohibitions scoped to the current phase]
- No [feature] yet ([Phase N])
- Do not [specific thing] — [one sentence why]

---

## Definition of Done — Current Phase

- [x] Completed item
- [ ] Remaining item

---

## Notes for AI Assistants

[The most critical facts an AI needs before touching this codebase]
[Organized as a flat list of specific, actionable rules]

- Architecture follows [pattern]: [dependency direction]
- [Service interface] speaks entirely in DTOs — no entity crosses the boundary
- [The one ordering constraint that's load-bearing]
- [The one connection string / config value that must not change]
- [The one package that must not be used and why]
- Do not [X] — [consequence if violated]
```

---

### roadmap.md

```md
# Roadmap — [Project Name]

## Product Vision

[3-5 sentences: what this is, who it's for, what problem it solves, competitive positioning]

## Phase Map

| Phase | Name | Status |
|-------|------|--------|
| 0 | Foundation | ✅ Complete |
| 1 | [Name] | 🔄 Current |
| 2 | [Name] | Planned |

## Phase 0 — Foundation ✅ Complete

* [x] [Completed item]

## Phase 1 — [Name] 🔄 Current Focus

* [x] [Completed item]
* [ ] [Remaining item]

## Phase N — [Name]

* [ ] [Planned item]

## Current Focus

[1-3 sentences — what's being built right now and what unblocks the next phase]

## Notes for AI Assistants

[Same critical facts as current-state.md Notes section — kept in sync]

## Long-Term Vision

[Where this is going — 2-3 sentences]
```

---

## Interview question sets

### For roadmap.md

Ask one at a time:

1. What does this project do in one sentence?
2. Who uses it — internal team, external customers, other developers?
3. What problem does it solve that existing tools don't solve well?
4. What is the most important thing it needs to do in the next 30 days?
5. What phases or milestones have you already defined? (rough is fine)
6. What's the long-term vision — where does this go in 12-18 months?

### For architecture.md

Ask one at a time:

1. What architecture pattern are you following — Clean Architecture, vertical slices, plain MVC, something else?
2. What is the dependency direction between your layers?
3. What ORM and database provider are you using?
4. What is your error handling approach — global middleware, result types, exceptions?
5. What validation library and placement strategy are you using?
6. What are the one or two architectural decisions you made deliberately that an AI might accidentally undo?
7. What packages or patterns did you explicitly reject and why?

---

## Codebase reading strategy for current-state.md generation

Read in this order — targeted, not exploratory:

| Stop | What to read | What to extract |
|---|---|---|
| 1 | `.sln` | Project names, count, structure |
| 2 | Each `.csproj` | Packages, versions, project references |
| 3 | `Program.cs` | DI registrations, middleware pipeline, startup blocks |
| 4 | Layer entry points | Key interfaces (`I*Service`, `I*Repository`), DbContext |
| 5 | `Migrations/` | Migration names and dates — infer schema evolution |
| 6 | Test projects | Test class names, counts — infer what's covered |
| 7 | CI workflows | Job names — infer what's enforced |
| 8 | Existing docs | `README.md`, any partial notes |

From these reads, populate:
- **What Is Completed** — what classes, interfaces, and wiring actually exist
- **What Is Not Yet Built** — what the roadmap references that isn't in the codebase
- **Known Issues** — any `// TODO`, `// HACK`, `// FIXME` comments found
- **Notes for AI Assistants** — inferred rules from patterns seen (e.g. if `GlobalExceptionMiddleware` is present, note that controllers contain only happy path)

---

## Conflict detection patterns

Common mismatches to check for in refresh mode:

| Doc claim | Codebase signal | Conflict |
|---|---|---|
| "Not yet built" for a feature | Class or project for that feature exists | Feature may be further along |
| Phase listed as complete | Tests for that phase failing or missing | Phase may not be done |
| Package listed as "do not use" | Package appears in `.csproj` | Rule may have been violated |
| Migration listed as latest | Newer migration file exists | Current state doc is stale |
| Test count stated | Actual count differs | Tests added or removed since last update |
| Architecture decision stated | Code contradicts it | Decision may have changed |

---

## Portability mapping

| Context file | Tool | Notes |
|---|---|---|
| `CLAUDE.md` | Claude Code | Native — read automatically on startup |
| `.cursorrules` | Cursor | Paste quick context block + condensed doc summaries |
| `.github/copilot-instructions.md` | GitHub Copilot | Workspace instructions — same structure works |
| `AI_CONTEXT.md` | Any tool | Universal fallback — reference manually |

The three living docs are tool-agnostic. Only the router filename changes per tool.
