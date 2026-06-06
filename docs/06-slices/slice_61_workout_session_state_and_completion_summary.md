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

## Completion

Feature commit: `1b135cc feat(training): add workout session state`

Follow-up build/localization fix: `46e304d fix(training): complete workout session build`
