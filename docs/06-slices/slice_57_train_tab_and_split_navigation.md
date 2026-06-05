# Slice 57 - Train Tab and Split/Folder Navigation

## Goal

Transform the visible Groups surface into a user-centered Train entry point
while preserving RepForge's local-first architecture. The Train tab should feel
like a fast training start surface with split/folder-style categories, not an
internal workout-group database.

This slice is focused on navigation and list UX. It must not add a full workout
session engine, exercise-detail dashboard, charts, adaptive next-set UI, custom
split editor, custom exercise creation, group editor, cloud services, Firebase,
sync, social runtime, health/wearable runtime, ads, payment changes, or broad
architecture rewrites.

## Implementation Summary

- Relabels the visible second navigation tab from Groups/Gruppen to
  Train/Training while keeping the internal `groups` route stable.
- Replaces the old group-list-first surface with a Train landing page:
  disabled/future `New workout`, training split categories, and optional
  starter-group previews.
- Adds deterministic presentation-level split categories:
  My Exercises, Full Body, Upper Body, Lower Body, Push, Pull, Legs, and Core.
- Lets users open a category to see matching local catalog exercises with a
  category-scoped search field and compact metadata chips.
- Keeps category filtering in presentation read models using existing catalog
  exercise metadata. No catalog schema, domain algorithm, or database migration
  changes are introduced.
- Keeps the Exercises tab as the full local catalog/library.

## Category Filtering

The Train classifier is deterministic and small:

- My Exercises: all available local catalog exercises.
- Full Body: broad compound movement patterns or exercises spanning upper and
  lower muscle metadata.
- Upper Body: push/pull/accessory upper-body movement patterns or upper-body
  muscles.
- Lower Body and Legs: squat, knee-dominant, hinge, lunge, glute, quad,
  hamstring, calf, and related lower-body metadata.
- Push: horizontal/vertical push, elbow extension, accessory push, chest,
  shoulders, front delts, and triceps.
- Pull: horizontal/vertical pull, elbow flexion, accessory pull, lats, upper
  back, rear delts, biceps, traps, and forearms.
- Core: core pattern or core muscle metadata.

These filters are navigation helpers, not coaching claims. They do not mutate
workout sets, catalog rows, readiness check-ins, settings/profile data,
recommendations, analytics, or workout groups.

## Validation Result

Passed:

```bash
git status --short
git rev-parse --short HEAD
git log --oneline -12
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
dart run tool/validate_catalog.dart
git diff --check
git diff --exit-code -- lib test || true
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter test test/src/features/workout_groups || true
flutter test test/src/features/exercise_catalog
flutter test test/src/features/recommendations
flutter test test/src/features/today
flutter test test/goldens || true
flutter test test/src/integration
scripts/check.sh
flutter build apk --debug
```

Notes:

- `git diff --exit-code -- lib test` reported the intentional Slice 57 lib/test
  diffs.
- `build_runner` repeated the known ignored `--delete-conflicting-outputs`
  warning.
- `flutter build apk --debug` repeated the existing `in_app_purchase_android`
  Kotlin Gradle Plugin warning and built the debug APK successfully.
- Train/UI guardrails hit the expected UI, localization, test, and docs text;
  cloud/backend guardrails hit existing boundary docs/fake gateways only; domain
  purity guardrails found no Drift/SQLite/Flutter imports in feature domains.

## Follow-ups

- Build the real workout-session start flow in a later explicit slice.
- Add custom split/folder editing only in a later explicit slice.
- Add exercise detail/timeline navigation only in a later explicit slice.
- Keep future coach/adaptive set UI advisory, local-first, and separate from
  this navigation layer.
