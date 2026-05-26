# Domain Rules

## Logging rules

- Repetitions must be greater than zero.
- Load must be greater than or equal to zero.
- Sets can be edited, but edits should preserve audit-relevant timestamps if later needed.
- Exercises with historical sets should be archived, not physically deleted, unless the user explicitly purges data.
- A set must reference either an official exercise or a custom exercise.
- A set exercise reference must keep a non-empty display name snapshot.
- Official exercise references may keep a catalog version snapshot for historical readability.
- A logged-set comment is optional, but must be non-empty when present.

## Workout group rules

- Workout group names must be non-empty.
- A group can contain official and custom exercises.
- An exercise can belong to multiple groups.
- Group order is user-controlled.
- Archived exercises should not be recommended by default.

## Catalog rules

- Official catalog data is versioned and bundled with the app.
- Official catalog imports are idempotent.
- Official catalog imports must not overwrite user overrides.
- Official exercise IDs must be stable.
- Corrections to official exercises must be represented as versioned changes.
- Custom exercise names may collide with official names, but UI should disambiguate source.

## Analytics rules

- Empty periods produce empty/zero states, not errors.
- Percentage deltas must handle zero baselines explicitly and remain unavailable
  when the previous value is absent or zero.
- Analytics formulas must not mutate raw logged sets.
- Visible estimated metrics should carry enough formula identity/version context
  to explain future formula changes.
- Estimated 1RM is hidden or marked low-confidence for unsuitable rep ranges.
- kg/rep is derived from total volume divided by total repetitions.
- Muscle load is an estimate and must not be presented as exact physiology.

## Recommendation rules

- Recommendations must be explainable.
- The engine must respect user focus, available equipment, available time, soreness, recent muscle load, and exercise availability.
- It must not force balanced training when the user intentionally chooses a specialization profile, but it should still warn about extreme neglect.
- It should avoid recommending high-load work for heavily sore muscles unless the user overrides.
- If top-set strength is unexpectedly down, the engine may suggest lower-load backoff volume, an easier alternative, or ending the exercise depending on readiness and goal.
- Quick Session mode prioritizes high-value compound or efficient exercises, but still protects against repeated neglect of important movement patterns.

## Safety wording rules

- Use `estimated`, `suggested`, `likely`, `signal`, `trend`, or `recommendation`.
- Do not say the app prevents injuries.
- Do not diagnose medical problems.
- Encourage professional advice for pain, illness, or unusual symptoms.
