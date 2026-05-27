# Slice 13 — Exercise detail set timeline

## Goal

Add the repository/domain foundation for exercise set timeline paging. For one
concrete exercise, RepForge can query historical `WorkoutSet` entries through
cursor/keyset paging without loading all historical sets at once.

## Implemented scope

- Added pure-Dart `WorkoutSetTimelineQuery`, `WorkoutSetTimelineCursor`, and
  `WorkoutSetTimelinePage`.
- Extended `WorkoutSetRepository` with `timelineForExercise`.
- Implemented Drift keyset paging in `DriftWorkoutSetRepository`.
- Timeline queries filter by stable exercise source and exercise ID, not display
  snapshots.
- Timeline ordering is newest-first by `performedAt`, then stable
  `workoutSetId`.
- Query implementation fetches `limit + 1` to derive `hasMore` and
  `nextCursor`.
- Existing persisted `WorkoutSet` snapshots and catalog-version snapshots are
  preserved exactly.

## Non-goals

- No UI, BLoC/Cubit, navigation, exercise detail screen, add/edit set form, or
  analytics charts.
- No schema change.
- No composition-root wiring.
- No cloud, backend, Firebase, ads, sync, payments, notifications, or paid
  runtime services.

## Implementation notes

Cursor/keyset paging uses the last returned set's `performedAt` and stable
`workoutSetId` as the next cursor. The Drift query applies the cursor in SQL and
does not load all rows before paging. This is the foundation for future exercise
detail screens and long histories.

## Validation commands

```bash
git status --short
git rev-parse --short HEAD
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
scripts/check.sh
```

Additional Slice 13 guardrails check timeline terms, domain purity, and
no-cloud/backend dependency bans.

## Commit message

```text
feat(training): add exercise set timeline paging
```
