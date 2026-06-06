# Slice 61 - Workout Session State and Completion Summary

## Goal

Add lightweight local workout-session state around the existing Train ->
Exercise Detail -> Log Set flow.

The slice should let users start a session from a Train category, see active
session progress while they navigate, attach newly logged sets to the active
session when possible, and complete the session with a compact local summary.

## Scope

In scope:

- In-memory app-owned workout session controller.
- Train category session starter.
- Active session banner/progress on Train, Today, and Exercise Detail.
- Quick-log attachment to the active `WorkoutSessionId`.
- Completion summary with duration, set count, exercise count, volume, and top
  exercise by session volume.
- English and German localization source strings.
- Focused application and widget coverage.

Out of scope:

- Full workout planner/editor.
- Periodization, templates, reordering, or prescribed set schemes.
- Social sharing, cloud sync, Firebase, analytics SDKs, wearables, payments, or
  coach/recommendation expansion.
- Drift schema changes. Slice 61 reuses the existing optional
  `workoutSessionId` on `WorkoutSet`.

## Implementation Notes

- `WorkoutSessionController` lives in the training-log application layer and
  emits `WorkoutSessionSnapshot` updates through a broadcast stream.
- `WorkoutSessionSummary` is a pure-Dart training-log domain value object. It
  derives duration, session set count, touched exercises, total volume, and top
  exercise from local `WorkoutSet` rows.
- The composition root owns the controller for the app lifetime and disposes it
  with other owned resources.
- `QuickLogSetController` keeps standalone logging unchanged and only passes a
  session ID when the shared controller has an active session.
- `WorkoutSessionStatusCard` is a reusable training-log presentation component
  for active and completed session states.
- The first implementation is intentionally volatile/in-memory. It uses existing
  persisted set session IDs for summary lookup but does not persist an active
  session record.

## Validation Status

Blocked in this run:

- `flutter gen-l10n` failed because Flutter attempted to write SDK cache files
  under `/home/luki/flutter/bin/cache` in the sandbox.
- `dart format ...` failed for the same SDK-cache reason.
- Required escalations were auto-rejected by the session usage limit, so
  generated localization files, formatting, analyzer, tests, scripts/check, APK,
  and commit are still pending.

Once Flutter SDK-cache access is available, run the normal slice validation:

```bash
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
dart run tool/validate_catalog.dart
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
scripts/check.sh
flutter build apk --debug
```

Expected commit message after validation:

```text
feat(training): add workout session state
```
