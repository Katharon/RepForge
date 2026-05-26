# Codex Workflow

## Goal

Codex should implement one precise slice at a time with minimal context usage and high correctness.

## Standard flow

1. Read the exact files listed in the slice prompt.
2. Inspect only directly relevant source files.
3. Write or update tests first where practical.
4. Implement the smallest complete production-quality change.
5. Run validation commands.
6. Update documentation if reality differs from docs.
7. Update `docs/05-codex/slice_status.md`.
8. Commit with the exact Conventional Commit message from the slice.
9. Report summary, tests, validation, changed files, commit hash, and follow-ups.

## Context minimization

Do not read the whole repository. Start with:

- `AGENTS.md`
- the slice file,
- only the domain/architecture/UX docs named by that slice.

For catalog-related slices, always include:

- `docs/02-architecture/exercise_catalog_distribution.md`

For recommendation/training-science slices, always include:

- `docs/01-domain/training_science_model.md`
- `docs/01-domain/recommendation_engine.md`
- `docs/01-domain/muscle_balance_model.md`

## Critical no-go

Do not introduce a cloud database for the official exercise catalog. Use bundled versioned JSON assets and local import.
