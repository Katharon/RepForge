# Slice 62 - Custom Exercises and Custom Training Folders MVP

## Goal

Add the first local-first MVP for user-created exercises and editable training
folders.

Users should be able to create their own exercises, see them beside official
catalog exercises, log sets against them, and organize official or custom
exercises into local folders/splits from the Train surface.

## Scope

In scope:

- Local custom exercise domain model and repository contract.
- Additive Drift schema for custom exercises with stable local IDs.
- Create, edit, and archive custom exercises from Exercises.
- Custom exercises shown beside official exercises with a visible custom badge.
- Search across official and custom exercises.
- Quick log support for custom exercise refs without official catalog versions.
- Local custom folders based on existing workout-group foundations.
- Create, edit, and archive custom folders from Train.
- Custom folder assignment of official and custom exercises.
- English and German localization, semantics, and focused tests.

Out of scope:

- Editing official exercises.
- Reordering folder exercises beyond the first deterministic assignment order.
- Full workout template planning, prescribed sets, periodization, or calendar
  scheduling.
- Persisted active workout sessions beyond Slice 61's lightweight session state.
- Cloud sync, Firebase, remote catalog databases, accounts, ads, wearables,
  social features, or payment changes.

## Implementation Notes

- `CustomExercise` lives in the exercise-catalog domain and stores name, optional
  notes, primary and secondary muscles, equipment, movement patterns, UTC
  created/updated timestamps, and optional archive timestamp.
- Drift schema v10 adds `custom_exercises` additively. Official catalog imports
  continue to write only official catalog tables and never mutate custom rows.
- `DriftExerciseCatalogRepository` now implements both the official catalog and
  custom-exercise repository contracts through the shared local database.
- UI code uses a unified `ExerciseListItemViewModel` with an `ExerciseSource`
  so official and custom exercises can share list, Train category, detail, and
  quick-log flows without losing stable source/id semantics.
- Archived custom exercises are excluded from normal list/search results, but
  historical workout sets preserve their `ExerciseRef.custom` display-name
  snapshot and remain readable.
- Custom training folders reuse the existing workout-group domain and Drift
  assignment tables. Folder archive is a soft archive; assignment snapshots are
  replaced only when editing that folder.

## Validation

Slice 62 should validate at least:

- `flutter gen-l10n`
- `dart run build_runner build --delete-conflicting-outputs`
- `dart run tool/validate_catalog.dart`
- `dart format --output=none --set-exit-if-changed .`
- `flutter analyze`
- focused exercise-catalog, Train/workout-groups, quick-log, and route/widget
  tests
- `flutter test`
- `scripts/check.sh`
- no new cloud/Firebase/sync/social/wearable/payment runtime surfaces
- `flutter build apk --debug`

## Completion

Implemented in this commit.
