# Slice 60 - In-session Logging and Adaptive Coach UI

## Goal

Show a compact, advisory next-set signal after a user logs a set from Exercise
Detail.

This slice connects the existing adaptive-set suggestion foundation to the
current local logging surface. It does not add a workout-session engine, full
coach screen, custom exercise editing, custom split editing, Today adaptive
cards, remote recommendations, cloud services, Firebase, sync, social runtime,
wearable/health runtime, ads, payment changes, schema migrations, or new
training-science formulas.

## Implementation Summary

- Adds an Exercise Detail adaptive suggestion presentation loader over bounded
  local set timeline data.
- Uses the latest logged set as the current set and, when available, the prior
  local set for the same exercise as a comparable baseline.
- Passes optional local readiness and settings equipment constraints into the
  existing deterministic adaptive-set suggester.
- Shows the suggestion only after a successful Exercise Detail Log Set save and
  history refresh.
- Keeps the suggestion dismissible, non-modal, and user-overridable.
- Localizes all visible English and German strings.
- Adds focused adapter and widget coverage for insufficient history, add
  weight, add reps, maintain, backoff, dismiss behavior, history refresh,
  localization, and semantics.

## Boundaries

- The UI never blocks set logging.
- The suggestion card is advisory copy only; it does not mutate sets, plans,
  groups, readiness check-ins, settings, or catalog rows.
- The adapter requests at most the latest two local sets for the selected
  exercise.
- Readiness is treated as an estimated local signal. Copy avoids medical
  certainty and injury-prevention promises.
- Official exercise catalog data remains bundled asset data imported into local
  Drift storage; no remote catalog source is introduced.

## Validation Result

Slice validation was run before commit. See `docs/05-codex/slice_status.md` for
the command list and any environment notes.

## Follow-ups

- Keep richer alternatives UI for a later explicit coach slice.
- Keep Today quick-log adaptive cards separate unless a future slice requests
  them directly.
- Keep workout-session start/stop and session-coach flows separate from this
  compact post-save signal.
