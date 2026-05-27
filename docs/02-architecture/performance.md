# Performance Guidelines

## Workout logging performance

- Opening an exercise detail should feel immediate.
- Adding a set should not block on analytics recomputation.
- Use optimistic UI carefully only when persistence failure can be recovered.

## Database performance

- Index `workout_sets.exercise_id` and `performed_at`.
- Query analytics by date range in SQL where practical.
- Avoid loading all historical sets for every chart if aggregation can be done in the database.
- Exercise set timelines page with keyset/cursor queries over
  `performedAt` plus stable `workoutSetId`, ordered newest-first. UI-facing
  timelines must not load all historical sets and page in memory.

## Widget performance

- Use `ListView.builder` for long set histories.
- Use immutable view states.
- Use `BlocSelector` or split widgets when only a small part changes.
- Avoid rebuilding the entire exercise detail screen every second because of the timer. Isolate countdown display.

## Chart performance

- Pre-aggregate chart points in application/data layer.
- Limit point density for long periods.
- Cache expensive aggregation results if needed.

## Startup performance

- Initialize only mandatory services at startup.
- Lazy-load premium/cloud/Firebase services until needed.
