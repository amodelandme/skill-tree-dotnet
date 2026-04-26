# ISSUES

Local issue files are provided at the start of context. Two queues feed ralph:

- `chores/*.md` — standalone fixes, infra, refactors, polish. No PRD, no wrap-up.
- `features/*/issues/*.md` — tracer-bullet slices of a feature, parented to a PRD.

Parse them to understand what is open. Items already in `done/` subdirectories are completed — do not reopen them.

You will work on the **AFK** issues only (frontmatter `type: AFK`). Skip anything marked `type: HITL` — those wait for a human gate.

You've also been passed the last few commits. Review them to understand what work has been done and to avoid redoing it.

If all AFK tasks are complete, output `<promise>NO MORE TASKS</promise>` and stop.

# TASK SELECTION

Pick the next task. Prioritize:

1. Critical bugfixes
2. Development infrastructure (tests, types, dev scripts) — precursor work for features
3. Tracer bullets for new features
   - A tracer bullet is the thinnest possible end-to-end slice that crosses every layer it needs. Build the slice, validate the shape, then expand.
4. Polish and quick wins
5. Refactors

Within a tier, respect `blocked-by` in the frontmatter — never start an issue whose blockers are still open.

# EXPLORATION

Explore the repo before writing code. At minimum, read `docs/architecture.md` and `docs/conventions.md` if they exist — they pin layer rules and conventions you must not silently violate.

# IMPLEMENTATION

Use `/tdd` to complete the task. Cover every acceptance criterion with a test before writing the implementation.

# FEEDBACK LOOPS

Before committing, run the .NET feedback loops and make them pass:

- `dotnet build` — must be clean
- `dotnet test --filter "Category!=Integration"` — must be green
- `dotnet format --verify-no-changes` — must be clean

If any loop fails, fix it. Do not commit a red build.

# COMMIT

Make a git commit. The commit message must include:

1. Key decisions made during the slice
2. Files changed
3. Blockers or notes for the next iteration

# THE ISSUE

If the task is complete (every AC checked, feedback loops green, issue moved):

- Move the issue file into the sibling `done/` directory
  - `chores/<id>.md` → `chores/done/<id>.md`
  - `features/<slug>/issues/<id>.md` → `features/<slug>/issues/done/<id>.md`

If the task is not complete, append a note to the issue file describing what was done and what remains. Leave it in place for the next iteration.

# FINAL RULES

ONLY WORK ON A SINGLE TASK PER ITERATION.
