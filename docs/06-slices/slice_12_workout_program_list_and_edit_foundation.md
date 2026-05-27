# Slice 12 — Workout groups and exercise assignment foundation

## Goal

Implement the first local-first workout group foundation: pure-Dart
workout-group and assignment domain types, additive Drift persistence,
mapper/repository support, deterministic assignment ordering, and focused tests.

## Implemented scope

- Added `lib/src/features/workout_groups/` with pure-Dart domain entities,
  value objects, paginated query/page types, and repository contract.
- Added Drift schema version `3` with `workout_groups` and
  `workout_group_exercise_assignments`.
- Added repository support for saving/finding/listing groups, saving/removing
  assignments, and listing assignments with explicit `limit`/`offset`.
- Reused `ExerciseRef` semantics for assignment references so official and
  future custom exercises keep stable source/id and display-name snapshots.
- Preserved official assignment `catalogVersionSnapshot` values and rejected
  invalid persisted custom assignment rows that contain catalog snapshots.
- Stored `archivedAt` only as a nullable UTC timestamp; no archive workflow was
  implemented.

## Non-goals

- No UI, BLoC/Cubit, forms, navigation changes, or composition-root wiring.
- No app-start group behavior.
- No workout-set history paging implementation.
- No custom exercise creation/editing flow.
- No recommendation ordering, planning engine, analytics UI, sync, backend,
  Firebase, ads, payments, notifications, cloud services, or remote catalog
  fetching.

## Implementation notes

Workout groups and assignments are local user data. Assignment rows intentionally
store stable exercise references and snapshots instead of foreign keys to
official catalog rows, so catalog imports and future catalog updates cannot
destroy or reinterpret group assignments.

List APIs use explicit offset pagination for the small group/assignment
foundation. Future large workout-set history lists should prefer cursor/keyset
paging over `performedAt` plus stable ID rather than large offset paging.

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

Additional Slice 12 guardrails check group identifiers, pagination terms,
cloud/backend dependency bans, and domain purity.

## Commit message

```text
feat(groups): add workout group assignment foundation
```
