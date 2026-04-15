# 🌳 skill-tree

> A personal library of AI-assisted developer skills. Model-agnostic, .NET-flavored, and always evolving.

---

## What is this?

Think of it as a `.dotfiles` repo — but for your AI workflow instead of your terminal.

Each skill is a folder containing Markdown instructions that tell an AI assistant *exactly* how to help you with a specific task. Point any tool at a skill file and it knows what to do: Claude, Cursor, Copilot, whatever's hot next month.

No vendor lock-in. Just plain text doing useful things.

---

## Using a skill

Reference a skill in your project's `CLAUDE.md` (or equivalent config file):

```md
## Skills

- Architecture review: ~/dev/skill-tree/architecture/improve-codebase-architecture/SKILL.md
- Quiz me on my code: ~/dev/skill-tree/learning/codebase-trivia/SKILL.md
- Grill my design: ~/dev/skill-tree/learning/grill-me/SKILL.md
- Plan a migration: ~/dev/skill-tree/dotnet/ef-migration-plan/SKILL.md
```

Then just tell your AI assistant to use it:

```
Run the codebase-trivia skill on this project.
```

---

## Folder structure

```
skill-tree/
├── workflow/           # Planning, PRDs, refactors, issue breakdown
│   ├── write-a-prd/
│   ├── prd-to-plan/
│   ├── prd-to-issues/
│   ├── request-refactor-plan/
│   └── write-a-skill/
├── architecture/       # Code quality, design, TDD, pre-commit hooks
│   ├── design-an-interface/
│   ├── improve-codebase-architecture/
│   ├── tdd/
│   ├── setup-pre-commit/
│   └── git-guardrails-claude-code/
├── debugging/          # Bug triage, QA, issue management
│   ├── triage-issue/
│   ├── qa/
│   └── github-triage/
├── dotnet/             # .NET specialist skills (this one grows fast)
│   ├── dotnet-api-design/
│   ├── ef-migration-plan/
│   └── claude-md-generator/
├── learning/           # Interview prep, design drills, domain modeling
│   ├── codebase-trivia/
│   ├── grill-me/
│   └── ubiquitous-language/
├── content/            # Writing, LinkedIn, blog posts
│   ├── edit-article/
│   └── linkedin-post/
└── README.md
```

---

## Skill index

### 🟢 Workflow & Planning

| Skill | What it does |
|---|---|
| `write-a-prd` | Turns a vague feature idea into a structured PRD via relentless interview. |
| `prd-to-plan` | Breaks a PRD into phased tracer-bullet vertical slices saved as a Markdown plan. |
| `prd-to-issues` | Converts a PRD into independently-grabbable GitHub issues, layer by layer. |
| `request-refactor-plan` | Plans a safe incremental refactor and files it as a GitHub issue with tiny commits. |
| `write-a-skill` | The meta-skill — scaffolds new skills with proper structure and progressive disclosure. |

### 🔵 Code Quality & Architecture

| Skill | What it does |
|---|---|
| `improve-codebase-architecture` | Surfaces architectural smells and proposes deep-module refactors as GitHub RFCs. |
| `design-an-interface` | Generates multiple radically different API designs so you can pick the best one. |
| `tdd` | Red-green-refactor loop tuned for xUnit, Moq, WebApplicationFactory, and TestContainers. |
| `setup-pre-commit` | Wires up pre-commit hooks with `dotnet format`, `dotnet build`, and `dotnet test` via Husky.Net. |
| `git-guardrails-claude-code` | Blocks dangerous git and EF Core migration commands before an AI agent can run them. |

### 🟣 Debugging & Issue Management

| Skill | What it does |
|---|---|
| `triage-issue` | Investigates a bug, traces the root cause, and files a TDD-based fix plan as a GitHub issue. |
| `qa` | Interactive QA session — you describe bugs conversationally, it files clean GitHub issues. |
| `github-triage` | Manages GitHub issues through a label-based state machine with a .NET-specific label taxonomy. |

### 🟠 .NET Specialist Skills

| Skill | What it does |
|---|---|
| `dotnet-api-design` | *(coming soon)* Designs ASP.NET Core minimal APIs following versioning, validation, and ProblemDetails standards. |
| `ef-migration-plan` | *(coming soon)* Plans EF Core migrations with rollback strategy and zero-downtime deployment patterns. |
| `claude-md-generator` | *(coming soon)* Bootstraps a `CLAUDE.md` for any .NET project — discovers architecture and wires up your skill library. |

### 🟡 Learning & Knowledge

| Skill | What it does |
|---|---|
| `codebase-trivia` | Quizzes you on your own codebase across 14 topics with Mermaid diagrams. Senior-interview difficulty available. |
| `grill-me` | Stress-tests your design decisions one relentless question at a time. |
| `ubiquitous-language` | Extracts a DDD glossary from conversation and writes it to `UBIQUITOUS_LANGUAGE.md`. |

### ⚪ Content & Communication

| Skill | What it does |
|---|---|
| `edit-article` | Restructures and tightens prose for blog posts and technical writing. |
| `linkedin-post` | *(coming soon)* Turns a learning session or project milestone into a punchy recruiter-friendly post. |

---

## Philosophy

- **Grounded in real code.** Skills read your actual codebase — not generic examples.
- **Model-agnostic.** Markdown files work everywhere.
- **Built for a returning .NET engineer** who treats every line of code as interview prep.
- **Living document.** A new skill gets added whenever a workflow gets painful enough to warrant one.

---

## Stack context

Most skills are tuned for the .NET ecosystem:

`ASP.NET Core` · `Entity Framework Core` · `xUnit` · `Moq` · `MediatR` · `DDD` · `Clean Architecture`

---

## Contributing

This is a personal repo, but if a skill solves a real problem you keep running into — PRs are welcome. Keep skills under 100 lines in `SKILL.md`. Reference files go in supporting `.md` files alongside it.

---

*Started in 2025. Built one painful workflow at a time.*