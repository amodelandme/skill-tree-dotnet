# project-context-bootstrap — Reference

Foundation = `architecture.md` + `conventions.md`. Plus the slim `CLAUDE.md` router. The queue (`features/`, `chores/`) carries the rest.

---

## Doc templates

### CLAUDE.md

```md
# [Project Name]

## Quick context

- **Stack:** ASP.NET Core [version] · EF Core · [Postgres/SQL Server/SQLite] · xUnit
- **Architecture:** [Clean Architecture / Vertical Slices / etc.] — [dependency direction]
- **One hard rule:** [The single most dangerous thing an AI could get wrong]

## Foundation docs

Read these before touching anything:

- `docs/architecture.md` — layer rules, allowed dependencies, durable patterns
- `docs/conventions.md`  — pinned versions, formatting, DVR, naming, error-handling

## Skills

Skills live in `.claude/skills/` (mirrored to `.agents/`). The work queue lives in
`features/<slug>/issues/` and `chores/`. AFK runner lives in `ralph/`.
```

The CLAUDE.md is intentionally short. Anything longer belongs in the foundation docs.

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
[Key contracts — service boundary types]

### Infrastructure
[What lives here — DbContext, repositories, migrations, external clients]
[Key decisions — ORM, provider, DI registration]

### Api
[What lives here — controllers/minimal endpoints, middleware, Program.cs]
[Key decisions — endpoint style, error handling, OpenAPI]

## Key architectural decisions

| Decision | Choice | Rationale |
|---|---|---|
| Error handling | GlobalExceptionMiddleware | Controllers contain only happy path |
| Validation | FluentValidation manual ValidateAsync | No AutoValidation — deprecated |
| [Add as decisions are made] | | |

## Patterns in use

[Strategy, Registry, etc. — brief description per pattern]

## What not to do

- [Explicit prohibitions — the things that caused bugs or were deliberately rejected]
```

---

### conventions.md

See `templates/conventions-template.md` for the full template. Sections:

- Pinned versions
- Formatting (`dotnet format` authority + `.editorconfig`)
- Don't Repeat Yourself (DVR) rules
- Naming (projects, interfaces, async, tests)
- Error handling
- Testing (xUnit + FluentAssertions; `Category=Integration` skipped by ralph)
- Commit messages
- Review style

---

## Interview question sets

### For architecture.md

Ask one at a time:

1. What architecture pattern — Clean Architecture, vertical slices, plain MVC, something else?
2. What is the dependency direction between layers?
3. What ORM and database provider?
4. What is the error-handling approach — global middleware, result types, exceptions?
5. What validation library and placement strategy?
6. What one or two architectural decisions did you make deliberately that an AI might accidentally undo?
7. What packages or patterns did you explicitly reject and why?

### For conventions.md

Ask one at a time, after extracting what's visible from the codebase (`.csproj`, `.editorconfig`, test projects):

1. Are there pinned versions whose pinning rationale matters? (which, why?)
2. What naming convention for tests — `Method_State_Expectation`, `Should_X_When_Y`, other?
3. What is the DVR threshold — when does duplication become a refactor?
4. Error-handling style: explicit result types, domain exceptions, both?
5. Commit-message rules — imperative, body-explains-why, issue-id trailer?

---

## Codebase reading strategy

Read in this order — targeted, not exploratory:

| Stop | What to read | What to extract |
|---|---|---|
| 1 | `.sln` | Project names, count, structure |
| 2 | Each `.csproj` | Packages, versions, project references |
| 3 | `.editorconfig` | Formatting rules |
| 4 | `Program.cs` | DI registrations, middleware pipeline, startup blocks |
| 5 | Layer entry points | Key interfaces (`I*Service`, `I*Repository`), DbContext |
| 6 | Test projects | Frameworks used, naming patterns, integration-tag conventions |
| 7 | CI workflows | What is enforced (build, test, format) |
| 8 | Existing docs | `README.md`, any partial notes |

From these reads, populate `architecture.md` (durable shape) and `conventions.md` (rules visible in code).

---

## Conflict detection patterns

Common mismatches to check for in refresh mode:

| Doc claim | Codebase signal | Conflict |
|---|---|---|
| Layer rule "Application must not depend on Infrastructure" | An Application file imports Infrastructure | Layer rule violated or rule has changed |
| Package listed as "do not use" | Package appears in `.csproj` | Rule was bypassed or changed |
| Pinned version stated | `.csproj` shows different version | Version drifted; intentional? |
| Naming convention stated | New code violates convention | Convention rotted or new pattern emerging |
| Architecture decision stated | Code contradicts it | Decision may have changed |

Refresh mode is callable from `/review` — when `/review` flags drift, hand the diff to this skill in refresh mode and apply the resulting proposed edits.

---

## Portability mapping

| Context file | Tool | Notes |
|---|---|---|
| `CLAUDE.md` | Claude Code | Native — read automatically on startup |
| `.cursorrules` | Cursor | Paste quick context block + condensed doc summaries |
| `.github/copilot-instructions.md` | GitHub Copilot | Workspace instructions — same structure works |
| `AI_CONTEXT.md` | Any tool | Universal fallback — reference manually |

The two foundation docs are tool-agnostic. Only the router filename changes per tool.
