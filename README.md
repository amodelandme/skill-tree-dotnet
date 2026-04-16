# 🌳 skill-tree-dotnet

> A personal library of AI-assisted developer skills. Model-agnostic, .NET-flavored, and always evolving.

**Shout out to [Matt Pocock](https://github.com/mattpocock)! His skills repo was my inspiration for this project.**

I got tired of explaining the same things to AI assistants over and over.
So I wrote it down once, put it in a folder, and now I just point the AI at the folder.

If you're a .NET dev trying to get more out of AI tooling without burning a week
reading docs — clone it, steal what's useful, ignore the rest.

---

## What is this?

Think of it as a `.dotfiles` repo — but for your AI workflow instead of your terminal.

Each skill is a folder containing Markdown instructions that tell an AI assistant *exactly* how to help you with a specific task. Point any tool at a skill file and it knows what to do: Claude, Cursor, Copilot, whatever's hot next month.

No vendor lock-in. Just plain text doing useful things.

---



## Using a skill

### In Claude Code

Reference a skill in your project's `CLAUDE.md`:

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

### In Claude.ai

Upload the skill file(s) you want to use as project documents. Then reference them in conversation:

```
Use the improve-codebase-architecture skill on this codebase.
```

Skills that spawn parallel sub-agents (like `improve-codebase-architecture`) will run those steps sequentially in Claude.ai — the output is the same, just single-threaded. Each skill notes which mode it's running in and adapts accordingly.

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
│   └── project-context-bootstrap/
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
| `prd-to-issues` | Converts a PRD into independently-grabbable GitHub issues using tracer-bullet vertical slices with HITL/AFK classification. |
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
| `github-triage` | Manages GitHub issues through a label-based state machine with HITL/AFK classification. |

### 🟠 .NET Specialist Skills

| Skill | What it does |
|---|---|
| `dotnet-api-design` | *(coming soon)* Designs ASP.NET Core minimal APIs following versioning, validation, and ProblemDetails standards. |
| `ef-migration-plan` | *(coming soon)* Plans EF Core migrations with rollback strategy and zero-downtime deployment patterns. |
| `project-context-bootstrap` | *(coming soon)* Bootstraps a `CLAUDE.md` for any .NET project — discovers architecture and wires up your skill library. |

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

## HITL / AFK workflow

Several skills classify work as **HITL** (Human In The Loop) or **AFK** (Away From Keyboard):

- **HITL** — requires a human decision before it can progress: architectural choices, design reviews, ambiguous requirements
- **AFK** — fully specified and can be implemented autonomously by an agent

GitHub issues created by `prd-to-issues` and `github-triage` are labeled accordingly. An agent scanning the backlog can filter `label:afk` to find tickets it's allowed to pick up without waiting for human input.

See `debugging/github-triage/REFERENCE.md` for the one-time label setup command.

---

## Philosophy

- **Grounded in real code.** Skills read your actual codebase — not generic examples.
- **Model-agnostic.** Markdown files work everywhere: Claude Code, Claude.ai, Cursor, Copilot.
- **Draft first, human approves.** Every skill that creates a GitHub artifact shows a preview before filing. Conservative by default — easy to override.
- **Built for a returning .NET engineer** who treats every line of code as interview prep.
- **Living document.** A new skill gets added whenever a workflow gets painful enough to warrant one.

---

## Stack context

Most skills are tuned for the .NET ecosystem:

`ASP.NET Core` · `Entity Framework Core` · `xUnit` · `Moq` · `DDD` · `Clean Architecture`

---

## Contributing

This is a personal repo, but if a skill solves a real problem you keep running into — PRs are welcome. Keep skills under 100 lines in `SKILL.md`. Reference files go in supporting `.md` files alongside it.

---

*Started in 2025. Built one painful workflow at a time.*
