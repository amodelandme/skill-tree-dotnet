# Conventions

> Pinned versions, formatting, DVR rules, naming, error-handling style. The durable rules of the codebase that aren't captured by `architecture.md` (which is *where things go*) or by code (which is *what is*).

---

## Pinned versions

- .NET SDK: <e.g. 8.0.x>
- Target framework(s): <net8.0, net8.0;netstandard2.1, ...>
- Key packages with explicit pins (Why pinned: …):
  - `EntityFrameworkCore`: <version>
  - `Serilog`: <version>
  - `xUnit`: <version>

## Formatting

- `dotnet format` is authoritative. Pre-commit hook runs `dotnet format --verify-no-changes`.
- `.editorconfig` rules win over personal preference.
- File-scoped namespaces.
- `var` policy: <when implicit, when explicit>.

## Don't Repeat Yourself (DVR)

- Shared abstractions live in `<project>.Shared` / `<project>.Core`.
- Pre-existing helpers must be searched before introducing a new one.
- Three similar lines is fine. The fourth is a refactor.

## Naming

- Projects: `<Solution>.<Layer>` (`MyApp.Api`, `MyApp.Application`, `MyApp.Domain`, `MyApp.Infrastructure`).
- Interfaces: `I<Name>`.
- Async methods: `<Name>Async`.
- Test classes: `<ClassUnderTest>Tests`. Test methods: `Method_State_Expectation` or `Should_<expectation>_When_<state>` — pick one and stick.

## Error handling

- Domain errors: explicit result types or domain exceptions, never bare `Exception`.
- Infrastructure failures: bubble up; do not swallow.
- Never `catch (Exception)` without rethrow or specific handling.
- Logging on the way out, not on the way through.

## Testing

- Framework: xUnit + FluentAssertions (+ Moq when needed).
- Unit tests are the default. Integration tests are tagged `Category=Integration` and skipped by ralph.
- Every AC ships with a test before the implementation lands.

## Commit messages

- Imperative mood: "add", "fix", "remove".
- Body explains *why*, not *what*.
- Reference the issue id (`features/<slug>/issues/003` or `chores/<id>`) in the trailer.

## Review style

- Reviews anchor against the PRD success criteria (features) or the chore Intent (chores).
- The `/review` report is the PR body.
- No force-push without explicit user say-so. No `--no-verify`.
