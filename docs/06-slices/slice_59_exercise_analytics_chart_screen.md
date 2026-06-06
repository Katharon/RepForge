# Slice 59 - Exercise Analytics Chart Screen

## Goal

Add a Setgraph-inspired, RepForge-native per-exercise analytics chart screen
reachable from the Exercise Detail `Analytics` and `1RM` entry cards.

This slice focuses only on exercise-level chart inspection. It does not add
in-session coach UI, adaptive next-set UI, custom exercise editing, custom split
editing, body heatmaps, cloud services, Firebase, sync, social runtime,
wearable/health runtime, ads, payment changes, new analytics formulas, or schema
migrations.

## Implementation Summary

- Adds a nested Exercise Analytics route below Exercise Detail for both Train
  and Exercises entry paths.
- Makes the Exercise Detail `Analytics` card open the chart with Volume
  selected by default.
- Makes the Exercise Detail `1RM` card open the same chart with Estimated 1RM
  selected.
- Adds localized metric chips for Sets, Reps, Volume, kg/rep, and Estimated 1RM.
- Adds compact Setgraph-like ranges: D, W, 2W, M, 3M, 6M, and All.
- Renders loading, empty, one-point, multi-point, error, limited-history, and
  estimated-1RM-unavailable states.
- Shows a selected point summary with metric value, local date/time, reps, and
  load.
- Uses a lightweight `CustomPaint` chart and existing theme/card primitives
  without adding a chart dependency.

## Boundaries

- The chart loader is a presentation adapter over the existing bounded
  `timelineForExercise` repository API.
- The UI never calls unbounded `historyForExercise`.
- Each chart load is capped at the latest 100 local sets for the selected
  exercise. The All range means all data inside that bounded load; if more local
  sets exist, the UI shows a limited-history notice.
- Per-set display values use existing documented formulas:
  `volume = load * repetitions`, `kg/rep = load`, and Epley v1 for estimated
  1RM.
- Raw workout sets, catalog rows, profile data, readiness check-ins,
  recommendations, and groups are not mutated.

## Validation Result

Slice validation was run before commit. See `docs/05-codex/slice_status.md` for
the command list and any environment notes.

## Follow-ups

- Keep deeper timeline pagination separate from this chart screen.
- Add custom-exercise chart deep links only when custom exercise creation exists.
- Keep coach/adaptive set suggestions advisory and scoped to later explicit
  slices.
