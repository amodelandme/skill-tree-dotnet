# SkillTree — Session Handoff

> Working document. Pass this file to a fresh model session to continue the rebuild.
> Delete once migration is complete.

---

## What this is

SkillTree is being rebuilt from a two-agent (architect / engineer) design into a **skills-first OS** with ralph as the AFK worker. The previous architect agent file was empty (0 bytes) and the workflow had unresolved overlaps between `prd-to-plan`, `prd-to-issue`, `write-a-design`, `write-a-spec`, and `spec-review`.

The new shape was driven through a 16-question grill-me-style interview. Every decision is locked below.

**Current artifact state:**
- `README.md` — **rewritten and done.** Three Mermaid flowcharts (feature with phased subgraphs LR, chore TD, gates LR). Voice: "Skills first. Agents second. Humans at the gates."
- Everything else — **not started.**

---

## Locked design (one line each)

1. **Scope:** Single-repo first; multi-repo reachable later.
2. **Actors:** Skills-first. No agent persona files. Three HITL gates + one AFK loop runner.
3. **Layout:** Slim `CLAUDE.md` → `.claude/skills/` (flat directory) → `.agents/` mirror for cross-model portability.
4. **Issue ↔ spec:** Collapsed. Issue body **is** the slice contract. No `docs/decisions/<branch>/`.
5. **Feature pipeline:** `idea → /write-a-prd → prd.md → /prd-to-issues → [HITL gate] → ralph loop → /wrap-up → changelog.md → /review → [HITL gate] → push → PR`.
6. **Chore pipeline:** `intake skill → chores/<id>.md → ralph → /review → push → PR`. No PRD, no wrap-up.
7. **AFK concurrency:** Sequential today. Parallel via worktrees later (not v1).
8. **Issue schema:** Frontmatter `id, title, type: AFK|HITL, status, blocked-by, parent-prd`. Body: `intent + ACs + layers crossed + DoD`. No "files touched", no "technical notes" — derived from foundation docs.
9. **PRD shape:** 8 sections — title, one-sentence intent, beneficiaries, success criteria, layers/interfaces, out of scope, dependencies/unknowns, interview notes. Frontmatter: `slug, status, created`.
10. **write-a-prd:** New skill. Wraps grill-me's interview pattern + the 8-section template. `grill-me` itself stays unchanged (general-purpose).
11. **wrap-up:** New skill. Pure synthesis (no accretive layer during AFK). Reads PRD + completed issues + git log → writes criterion-anchored `changelog.md`.
12. **changelog.md:** Narrative organized by PRD success criteria. Frontmatter carries the audit trail. No per-issue ledger (redundant with `done/` + git log).
13. **/review:** Hybrid (b+c) — model produces structured report anchored to PRD success criteria. Sections: coverage of criteria, scope outside criteria, foundation-doc drift, pre-push checklist, decision. Report becomes PR body on push.
14. **HITL gates (three):** (1) PRD content during write-a-prd; (2) issue-list approval inside prd-to-issues; (3) `/review`. Gate 3 is load-bearing.
15. **Foundation docs:** Two only — `docs/architecture.md` (durable shape, layer rules) + `docs/conventions.md` (pinned versions, formatting, DVR). `current-state.md` and `roadmap.md` killed; the queue (`features/`, `chores/`) replaces both.
16. **prd-to-issues:** One skill, not two. Slicing + file-writing in same skill, HITL gate between drafting list and writing files.

---

## Folder layout (target state)

```
.
├── CLAUDE.md                       slim pointer to .claude/skills/
├── README.md                       done (rewritten)
├── HANDOFF.md                      this file (transient — delete after migration)
├── .claude/skills/                 flat, all skills
├── .agents/                        mirror of .claude/skills/
├── ralph/{afk.sh, once.sh, prompt.md}
├── docs/{architecture.md, conventions.md}
├── features/<slug>/{prd.md, issues/, issues/done/, changelog.md}
└── chores/{*.md, done/}
```

---

## Migration map (21 existing skills)

### Survives unchanged
`tdd`, `git-guardrails-claude-code`, `setup-pre-commit-hooks`, `ef-migration-plan`, `grill-me`, `codebase-trivia`, `zoom-out`, `edit-article`, `linkedin-post`.

### Mutates (surgery or output redirect)
- **`project-context-bootstrap`** — drop `current-state.md` + `roadmap.md` from doc set; add `conventions.md`; expose refresh mode as callable from `/review`.
- **`improve-codebase-architecture`** — outputs to `chores/<id>.md` instead of `gh issue create`.
- **`triage-issue`** — outputs to `chores/<id>.md` instead of `gh issue create`.
- **`qa`** — outputs to multiple `chores/*.md`.
- **`dotnet-api-design`** — audit-mode "gap → GitHub issue" becomes "gap → chore file." Greenfield mode unchanged.
- **`design-an-interface`** — file has duplicate content (lines 1-75 and 76-150 are near-dupes). **Dedupe during migration.**
- **`ubiquitous-language`** — wire into `/review` for terminology drift detection.
- **`write-a-skill`** — relocate from "Workflow & Planning" to flat structure.

### Replaced by new pipeline (delete)
`prd-to-plan`, `prd-to-issue` (old), `request-refactor-plan`, `spec-review`, `write-a-design`, `write-a-spec`.

### Genuinely dies
`github-triage` — entire skill is a GitHub-label state machine; in new model labels become frontmatter, the state machine becomes `grep`.

### Agent files (delete entirely)
`Agents/architect/` (file was empty), `Agents/engineer/` (logic absorbed into skills + ralph).

### Top-level
- `README.md` — done.
- `WORKFLOWS.md` — delete (absorbed into README).

---

## Drafting order remaining

1. **`ralph/prompt.md`** update — replace `npm run test` / `npm run typecheck` with `dotnet build` / `dotnet test --filter "Category!=Integration"` / `dotnet format --verify-no-changes`. Point at `chores/*.md` + `features/*/issues/*.md`. Keep `<promise>NO MORE TASKS</promise>` sentinel.
2. **`write-a-prd/SKILL.md`** — wraps grill-me + 8-section PRD template.
3. **`prd-to-issues/SKILL.md`** — PRD → tracer-bullet issues, HITL list-approval gate, writes files.
4. **`wrap-up/SKILL.md`** — synthesizes `changelog.md` after AFK.
5. **`review/SKILL.md`** — load-bearing HITL; criterion-anchored review report; becomes PR body.
6. **`project-context-bootstrap/SKILL.md`** surgery (drop/add per migration map).
7. **Mutation pass** on the 7 other skills (output redirects, dedupe).
8. **Migration execution** — delete dead skills, flatten directory, set up `.claude/skills/` ↔ `.agents/` sync.

---

## Templates to use when drafting

### Issue file template (features and chores)

```markdown
---
id: 003
title: User can submit feedback form
type: AFK
status: open
blocked-by: [001, 002]
parent-prd: features/user-feedback/prd.md   # null for chores
---

## Intent
<one paragraph: end-to-end behavior this slice delivers>

## Acceptance criteria
- [ ] <observable behavior 1>
- [ ] <observable behavior 2>
- [ ] <error case>
- [ ] <edge case>

## Layers crossed
Api → Application → Domain → Infrastructure   # whichever apply

## Definition of done
- All ACs covered by tests
- dotnet build/test/format clean
- Issue moved to `done/`
```

### PRD template

```markdown
---
slug: user-feedback
status: drafted    # drafted | issues-generated | implementing | review | done
created: 2026-04-26
---

# <feature title>

## One-sentence intent
<single sentence>

## Who benefits, and how
<actor + observable outcome>

## Success criteria
<2-5 observable behaviors that prove this is done — feeds issue ACs>

## Layers and interfaces
<which architectural layers; new/modified interfaces>

## Explicitly out of scope
<what this PRD does NOT cover, and where those concerns belong>

## Dependencies and unknowns
<blocked-by features; [VERIFY] flags; known unknowns>

## Notes from interview
<anything from grill-me that doesn't fit above>
```

### changelog.md template

```markdown
---
feature: user-feedback
prd: features/user-feedback/prd.md
issues-completed: [001, 002, 003, 004]
generated: 2026-04-26
---

# User feedback — what was built

## <success criterion 1, verbatim from PRD>
<one paragraph: what now satisfies this, where the code lives, what tests prove it>

## <success criterion 2>
<...>

## Beyond the criteria
<commits or files not traced to a criterion; default empty>

## Foundation-doc impact
<empty by default; if patterns/conventions changed: candidate edits to architecture.md / conventions.md>
```

### /review report template

```markdown
# Review — <feature-slug or chore-id>

## Coverage of success criteria
- ✅/⚠️/❌ <criterion text>
  - Evidence: <files/lines>
  - Concerns: <none | list>

## Scope outside the criteria
<files/lines not traced to any criterion; "intentional" or "scope creep candidate">

## Foundation-doc drift
<empty by default; proposed edits to architecture.md / conventions.md inline>

## Pre-push checklist
- [ ] dotnet build clean
- [ ] dotnet test --filter "Category!=Integration" passing
- [ ] dotnet format --verify-no-changes clean
- [ ] git-guardrails-claude-code reviewed any destructive ops

## Decision
<approve | request changes | block>
```

---

## Naming and voice

- **Product brand:** "SkillTree" (dropped "Dotnet" from the brand; repo folder is still `SkillTreeDotnet`).
- **Survives:** "PRD", "issue", "chore", "feature", "ralph" (lowercase).
- **Dead:** "spec", "design doc", "RFC", "agent" (as a persona).
- **Voice:** punchy, slightly opinionated, not corporate. No emojis unless user explicitly asks.
- **Slug format:** kebab-case for feature directories.

---

## Working discipline

- **One question at a time** during design conversations (grill-me discipline).
- For every question, present a model recommendation **with rationale**.
- Don't add sections to artifacts that don't earn their keep.
- The user pushes back when wrong; respect it, fold the correction in.

---

## Known open items / deferred decisions

- **Multi-repo expansion** — single-repo first, but skills should not bake in single-repo assumptions.
- **`.claude/skills/` ↔ `.agents/` sync** — script vs symlink not picked. Symlink is one-line; script is portable across non-Unix.
- **"PRD" terminology** — user noted it feels corporate but kept it. Open to revisit.
- **Ralph's `docker sandbox run claude`** — non-standard wrapper. Confirm what it is before relying on it in production prompts.
- **Issue file numbering** — convention not picked (zero-padded `001`, hash, ULID, etc.).

---

## Reference: skills that already exist (full inventory)

| Skill | Path | Disposition |
|---|---|---|
| grill-me | `Learning & Knowledge/grill-me/` | unchanged |
| codebase-trivia | `Learning & Knowledge/codebase-trivia/` | unchanged |
| ubiquitous-language | `Learning & Knowledge/ubiquitous-language/` | mutate (wire into /review) |
| zoom-out | `Learning & Knowledge/zoom-out/` | unchanged |
| tdd | `Code Quality & Architecture/tdd/` | unchanged |
| git-guardrails-claude-code | `Code Quality & Architecture/git-guardrails-claude-code/` | unchanged |
| setup-pre-commit-hooks | `Code Quality & Architecture/setup-pre-commit-hooks/` | unchanged |
| design-an-interface | `Code Quality & Architecture/design-an-interface/` | mutate (dedupe file) |
| improve-codebase-architecture | `Code Quality & Architecture/improve-codebase-architecture/` | mutate (output to chores/) |
| dotnet-api-design | `.NET/dotnet-api-design/` | mutate (output to chores/) |
| ef-migration-plan | `.NET/ef-migration-plan/` | unchanged |
| project-context-bootstrap | `.NET/project-context-bootstrap/` | mutate (drop 2 docs, add conventions.md) |
| triage-issue | `Debugging & Issue Management/triage-issue/` | mutate (output to chores/) |
| qa | `Debugging & Issue Management/qa/` | mutate (output to chores/) |
| github-triage | `Debugging & Issue Management/github-triage/` | **delete** |
| edit-article | `Content & Communication/edit-article/` | unchanged |
| linkedin-post | `Content & Communication/linkedin-post/` | unchanged |
| write-a-skill | `Workflow & Planning/write-a-skill/` | relocate to flat |
| prd-to-issue | `Workflow & Planning/prd-to-issue/` | **delete** (replaced) |
| prd-to-plan | `Workflow & Planning/prd-to-plan/` | **delete** (replaced) |
| request-refactor-plan | `Workflow & Planning/request-refactor-plan/` | **delete** |
| spec-review | `Workflow & Planning/spec-review/` | **delete** |
| write-a-design | `Workflow & Planning/write-a-design/` | **delete** |
| write-a-spec | `Workflow & Planning/write-a-spec/` | **delete** |
| Agents/architect | `Agents/architect/` | **delete** (was empty) |
| Agents/engineer | `Agents/engineer/` | **delete** (logic into skills + ralph) |

### To create (new)
- `write-a-prd`
- `prd-to-issues`
- `wrap-up`
- `review`

---

## Resume instruction for the next session

> "Read `HANDOFF.md` end to end. Then start with item 1 of the drafting order: update `ralph/prompt.md` to use the .NET feedback loops and point at `chores/` + `features/*/issues/`. Confirm the changes with me before moving to item 2."
