# Slice 53 — Wearable and calorie estimation design spike

## Goal

Design and optionally prototype boundaries for rough calorie estimation and future wearable heart-rate integration without shipping invasive permissions by default.

## Read first

1. `AGENTS.md`
2. `docs/02-architecture/wearables_health_integration.md`
3. `docs/02-architecture/security_privacy_threat_model.md`
4. `docs/01-domain/training_science_model.md`
5. `docs/06-slices/slice_53_wearable_calorie_estimation_spike.md`

## Non-goals

- Do not request production health permissions yet unless explicitly approved.
- Do not upload health data.
- Do not claim exact calorie burn.

## TDD requirements

If code is added, write tests for calorie estimate formulas and normalized sample mapping first. A design-only slice may update docs only.

## Implementation requirements

- Keep integration opt-in.
- Define ports and privacy constraints.
- Label calories as rough estimates.
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
docs(wearables): define calorie and wearable boundary
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/02-architecture/wearables_health_integration.md
3. docs/02-architecture/security_privacy_threat_model.md
4. docs/01-domain/training_science_model.md
5. docs/06-slices/slice_53_wearable_calorie_estimation_spike.md

Implement Slice 53: Wearable and calorie estimation design spike.

Goal:
Design and optionally prototype boundaries for rough calorie estimation and future wearable heart-rate integration without shipping invasive permissions by default.

Non-goals:
- Do not request production health permissions yet unless explicitly approved.
- Do not upload health data.
- Do not claim exact calorie burn.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Do not use a cloud database for the official exercise catalog.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
If code is added, write tests for calorie estimate formulas and normalized sample mapping first. A design-only slice may update docs only.

Implementation requirements:
- Keep integration opt-in.
- Define ports and privacy constraints.
- Label calories as rough estimates.

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
`docs(wearables): define calorie and wearable boundary`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
