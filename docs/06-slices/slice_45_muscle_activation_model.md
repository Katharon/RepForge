# Slice 45 — Muscle activation model

## Goal

Implement muscle IDs, activation weights, exercise activation profiles, and muscle-load calculation primitives.

## Read first

1. `AGENTS.md`
2. `docs/01-domain/training_science_model.md`
3. `docs/01-domain/muscle_balance_model.md`
4. `docs/01-domain/analytics_formulas.md`
5. `docs/06-slices/slice_45_muscle_activation_model.md`

## Non-goals

- Do not implement full dashboard UI.
- Do not claim exact physiological measurement.
- Do not add remote data.

## TDD requirements

Write pure domain tests for activation validation and muscle-load calculations first.

## Implementation requirements

- Add value objects for muscle ID and activation weight.
- Calculate estimated muscle load from sets and activation profiles.
- Return confidence/unknown states for exercises without activation data.
- Follow `AGENTS.md`.
- Keep layer boundaries from the architecture docs.
- Handle loading, empty, error, and success states where UI is touched.
- Update affected docs if implementation decisions differ from the plan.

## Acceptance criteria

- Slice goal is implemented.
- Tests required by this slice are added or updated.
- Formatting passes.
- Static analysis passes.
- All relevant tests pass.
- `docs/05-codex/slice_status.md` is updated.
- No unrelated future feature is introduced.

## Implementation note

Slice 45 adds a pure-Dart analytics-domain muscle activation foundation:

- `MuscleId`, `ActivationWeight`, and `MuscleActivationEntry` validate stable
  muscle identifiers and bounded `0.0..1.0` activation weights.
- `ExerciseActivationProfile` references existing `ExerciseRef`-compatible
  source/id pairs and supports both known profiles and explicit unavailable
  activation data.
- `MuscleLoadInput`, `MuscleLoad`, `MuscleLoadEstimate`, and
  `MuscleLoadEstimator` calculate deterministic estimated per-muscle load from
  logged set volume and activation weights.
- Missing activation profiles produce unavailable confidence and an explicit
  unknown exercise list; incomplete/bodyweight-style load inputs produce
  conservative confidence.

This slice does not persist muscle-load results, rewrite official catalog JSON,
build dashboard UI, body graphics, heatmaps, recommendations, recovery logic,
wearable inputs, calorie estimates, Firebase, sync, remote catalog fetching, or
cloud services.

## Validation commands

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

Add slice-specific commands if appropriate:

```bash
flutter test integration_test
flutter build apk --debug
```

## Documentation updates

Update these if changed by implementation:

- `docs/05-codex/slice_status.md`
- Any architecture/domain/UX document made stale by this slice
- `CHANGELOG.md` only for user-visible or release-relevant changes

## Commit message

```text
feat(training-science): add muscle activation model
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/01-domain/training_science_model.md
3. docs/01-domain/muscle_balance_model.md
4. docs/01-domain/analytics_formulas.md
5. docs/06-slices/slice_45_muscle_activation_model.md

Implement Slice 45: Muscle activation model.

Goal:
Implement muscle IDs, activation weights, exercise activation profiles, and muscle-load calculation primitives.

Non-goals:
- Do not implement full dashboard UI.
- Do not claim exact physiological measurement.
- Do not add remote data.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Do not use a cloud database for the official exercise catalog.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
Write pure domain tests for activation validation and muscle-load calculations first.

Implementation requirements:
- Add value objects for muscle ID and activation weight.
- Calculate estimated muscle load from sets and activation profiles.
- Return confidence/unknown states for exercises without activation data.

Validation commands:
```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```
Run stronger commands if applicable:
```bash
flutter test integration_test
flutter build apk --debug
```

Documentation:
- Update docs/05-codex/slice_status.md.
- Update any affected docs if implementation reveals a stale or wrong assumption.

Commit:
Create one git commit with this exact message:
`feat(training-science): add muscle activation model`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
