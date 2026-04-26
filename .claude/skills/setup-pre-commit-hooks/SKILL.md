---
name: setup-pre-commit
description: Set up Husky.Net pre-commit hooks with dotnet format, dotnet build, and dotnet test in a .NET repo. Also wires up automatic hook installation for teammates via Directory.Build.targets. Use when user wants to add pre-commit hooks, set up Husky.Net, add commit-time formatting, or enforce build/test gates on commit.
---

# Setup Pre-Commit Hooks (.NET)

## What This Sets Up

- **Husky.Net** pre-commit hook (dotnet tool, no Node required)
- **dotnet format** on staged `.cs` files only (fast, surgical)
- **dotnet build** — catches compile errors before commit
- **dotnet test --no-build** — runs tests, skips rebuild
- **Directory.Build.targets** — auto-installs hooks for teammates on `dotnet restore`

## Steps

### 1. Add Husky.Net as a local tool

```bash
dotnet new tool-manifest   # skip if .config/dotnet-tools.json already exists
dotnet tool install husky
dotnet husky install
```

### 2. Create the pre-commit hook

Write `.husky/pre-commit`:

```bash
#!/bin/sh
dotnet husky run --name "pre-commit"
```

Then: `chmod +x .husky/pre-commit`

### 3. Create the task runner config

Write `.husky/task-runner.json`:

```json
{
  "tasks": [
    {
      "name": "dotnet-format",
      "command": "dotnet",
      "args": ["format", "--include", "{staged}"],
      "include": ["**/*.cs"],
      "pathMode": "absolute"
    },
    {
      "name": "dotnet-build",
      "command": "dotnet",
      "args": ["build", "--no-restore", "-warnaserror"]
    },
    {
      "name": "dotnet-test",
      "command": "dotnet",
      "args": ["test", "--no-build", "--verbosity", "minimal"]
    }
  ]
}
```

`{staged}` passes only staged `.cs` files to `dotnet format`. `-warnaserror` promotes warnings to errors. `--no-build` skips the rebuild since build already ran.

### 4. Wire up auto-install for teammates

Create or merge into `Directory.Build.targets` at the solution root:

```xml
<Project>
  <Target Name="HuskyInstall" AfterTargets="Restore" Condition="'$(HUSKY)' != '0'">
    <Exec Command="dotnet tool restore" StandardOutputImportance="Low" />
    <Exec Command="dotnet husky install" StandardOutputImportance="Low" />
  </Target>
</Project>
```

Runs automatically after `dotnet restore`. Set `HUSKY=0` in CI to skip.

### 5. Verify

- [ ] `.husky/pre-commit` is executable
- [ ] `.husky/task-runner.json` exists
- [ ] `.config/dotnet-tools.json` includes `husky`
- [ ] `Directory.Build.targets` has `HuskyInstall` target
- [ ] `dotnet husky run` passes all three tasks

### 6. Commit

```
Add pre-commit hooks (Husky.Net + dotnet format/build/test)
```

This runs through the hooks as a smoke test.

## Notes

- Omit the test task if the repo has no test projects yet
- Always set `HUSKY=0` in CI pipelines to skip hook installation on build agents
- `dotnet format` is built into .NET 6+ — no extra package needed
