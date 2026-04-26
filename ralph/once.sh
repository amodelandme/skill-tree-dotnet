#!/bin/bash

shopt -s nullglob
files=(chores/*.md features/*/issues/*.md)
shopt -u nullglob

if [ ${#files[@]} -eq 0 ]; then
  issues="No issues found"
else
  issues=$(cat "${files[@]}")
fi

commits=$(git log -n 5 --format="%H%n%ad%n%B---" --date=short 2>/dev/null || echo "No commits found")
prompt=$(cat ralph/prompt.md)

claude --permission-mode acceptEdits \
  "Previous commits: $commits Issues: $issues $prompt"
