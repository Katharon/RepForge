# Slice 56 — Data Versioning and Backward Compatibility Hardening

## Purpose

Make RepForge explicitly safe for long-term user data evolution. This slice verifies and hardens catalog IDs, Drift migrations, import/export format versioning, exercise references, and analytics formula versioning so future app changes do not break existing user history.

## Read first

- `AGENTS.md`
- `docs/00-project/project_memory_brief.md`
- `docs/02-architecture/architecture_overview.md`
- `docs/02-architecture/data_persistence.md`
- `docs/02-architecture/exercise_catalog_distribution.md`
- `docs/02-architecture/data_versioning_backward_compatibility.md`
- `docs/02-architecture/migrations_import_export.md`
- `docs/04-quality/test_strategy.md`
- `docs/05-codex/codex_workflow.md`
- `docs/06-slices/index.md`

## Scope

- Add or harden stable exercise reference modeling.
- Ensure logged sets keep a display-name snapshot and stable exercise reference.
- Ensure official catalog entities support deprecation instead of deletion.
- Add migration tests for existing sessions, custom exercises, official exercises, and user overrides.
- Add backup/export format version metadata if not already present.
- Add formula-version metadata for stored derived analytics if analytics snapshots exist.
- Update docs and slice status.

## Non-goals

- Do not add cloud sync.
- Do not add accounts.
- Do not add AI coach behavior.
- Do not introduce a cloud catalog database.
- Do not rewrite the whole persistence layer unless tests prove it is necessary.

## TDD requirements

Write failing tests first for:

1. logged sessions survive an official exercise rename,
2. logged sessions survive official exercise deprecation,
3. custom exercises are not overwritten by catalog import,
4. catalog importer refuses unsupported schema versions before modifying Drift,
5. migration preserves set entries and exercise references.

## Validation commands

```bash
flutter pub get
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

If Drift code generation is affected:

```bash
dart run build_runner build --delete-conflicting-outputs
flutter test
```

## Documentation updates

Update:

- `docs/02-architecture/data_versioning_backward_compatibility.md`
- `docs/02-architecture/exercise_catalog_distribution.md`
- `docs/02-architecture/migrations_import_export.md`
- `docs/05-codex/slice_status.md`
- `docs/06-slices/index.md`

## Commit message

```text
feat(data): harden versioning and backward compatibility
```
