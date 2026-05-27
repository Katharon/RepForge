# Slice 08 — Drift local database foundation

## Goal

Add Drift/SQLite local database schema for official catalog imports, custom exercises, workout groups, sets, labels, user profile, and preferences with migration test scaffolding.

## Slice 08 implementation note

The implemented Slice 08 scope was intentionally narrowed by the active
implementation prompt. Slice 08 now establishes only the minimal local Drift
foundation: dependencies, schema version 1, generated database code, and a
single `workout_sets` table that preserves stable exercise references and
display-name/catalog snapshots for historical logged sets.

Official catalog tables, custom exercise tables, workout groups, labels, user
profile, preferences, repository implementations, mappers, catalog import, UI,
BLoC/Cubit flows, sync, Firebase, backend services, ads, and payment runtime
services remain out of scope for this slice.

The database boundary lives at `lib/src/shared/data/local/` because the Drift
database is shared infrastructure that will be wired by the composition root in
a later slice. Domain code remains pure Dart and does not import Drift,
SQLite, Flutter, presentation, or generated localization code.

## Read first

1. `AGENTS.md`
2. `docs/02-architecture/data_persistence.md`
3. `docs/02-architecture/exercise_catalog_distribution.md`
4. `docs/01-domain/domain_map.md`
5. `docs/06-slices/slice_08_drift_local_database_foundation.md`

## Non-goals

- Do not implement cloud sync.
- Do not implement a cloud exercise database.
- Do not build full UI yet.

## TDD requirements

Write repository/database/migration tests first where possible. Add catalog import fixture tests if the importer starts in this slice.

## Implementation requirements

- Create local Drift database only.
- Represent official exercises separately from custom exercises and user overrides.
- Prepare schema for workout groups and group exercise assignment.
- Keep official catalog imports idempotent and version-aware.
- Follow `AGENTS.md`.
- Keep layer boundaries from the architecture docs.
- Handle loading, empty, error, and success states where UI is touched.
- Update affected docs if implementation decisions differ from the plan.

## Acceptance criteria

- Slice goal is implemented.
- Tests required by this slice are added or updated.
- Formatting passes.
- Static analysis passes.
- All relevant tests pass.
- `docs/05-codex/slice_status.md` is updated.
- No unrelated future feature is introduced.

## Validation commands

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

Add slice-specific commands if appropriate:

```bash
flutter test integration_test
flutter build apk --debug
```

## Documentation updates

Update these if changed by implementation:

- `docs/05-codex/slice_status.md`
- Any architecture/domain/UX document made stale by this slice
- `CHANGELOG.md` only for user-visible or release-relevant changes

## Commit message

```text
feat(data): add Drift local database foundation
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/02-architecture/data_persistence.md
3. docs/02-architecture/exercise_catalog_distribution.md
4. docs/01-domain/domain_map.md
5. docs/06-slices/slice_08_drift_local_database_foundation.md

Implement Slice 08: Drift local database foundation.

Goal:
Add Drift/SQLite local database schema for official catalog imports, custom exercises, workout groups, sets, labels, user profile, and preferences with migration test scaffolding.

Non-goals:
- Do not implement cloud sync.
- Do not implement a cloud exercise database.
- Do not build full UI yet.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Do not use a cloud database for the official exercise catalog.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
Write repository/database/migration tests first where possible. Add catalog import fixture tests if the importer starts in this slice.

Implementation requirements:
- Create local Drift database only.
- Represent official exercises separately from custom exercises and user overrides.
- Prepare schema for workout groups and group exercise assignment.
- Keep official catalog imports idempotent and version-aware.

Validation commands:
```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```
Run stronger commands if applicable:
```bash
flutter test integration_test
flutter build apk --debug
```

Documentation:
- Update docs/05-codex/slice_status.md.
- Update any affected docs if implementation reveals a stale or wrong assumption.

Commit:
Create one git commit with this exact message:
`feat(persistence): add Drift local database foundation`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
