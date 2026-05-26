# Contributing

## Workflow

1. Pick the next open slice from `docs/06-slices/index.md`.
2. Read the exact files listed in the slice.
3. Write or update tests first where applicable.
4. Implement the smallest complete increment.
5. Run validation commands.
6. Update affected documentation and `docs/05-codex/slice_status.md`.
7. Commit using Conventional Commits.

## Commit format

Use Conventional Commits:

```text
feat(domain): add workout set model
fix(timer): prevent stale rest timer notification
test(analytics): cover period comparison edge cases
docs(slices): update slice status
chore(ci): add Flutter analyze workflow
```

## Pull requests

A PR must include:

- What changed.
- Which slice it implements.
- Validation commands run.
- Screenshots or recordings for UI changes.
- Notes about migrations, breaking changes, or deferred work.
