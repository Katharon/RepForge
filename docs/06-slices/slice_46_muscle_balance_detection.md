# Slice 46 — Muscle balance detection

## Goal

Implement focus-aware imbalance detection across rolling windows using muscle load and movement pattern coverage.

## Read first

1. `AGENTS.md`
2. `docs/01-domain/muscle_balance_model.md`
3. `docs/01-domain/training_science_model.md`
4. `docs/01-domain/recommendation_engine.md`
5. `docs/06-slices/slice_46_muscle_balance_detection.md`

## Non-goals

- Do not implement advanced UI charts.
- Do not shame or medically diagnose users.
- Do not add AI/cloud logic.

## TDD requirements

Write deterministic domain tests for push-heavy, leg-neglect, upper-focus, lower-focus, and balanced histories before implementation.

## Implementation requirements

- Produce explainable imbalance signals.
- Respect focus profile target ranges.
- Support empty/insufficient data states.
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
feat(training-science): detect muscle balance signals
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/01-domain/muscle_balance_model.md
3. docs/01-domain/training_science_model.md
4. docs/01-domain/recommendation_engine.md
5. docs/06-slices/slice_46_muscle_balance_detection.md

Implement Slice 46: Muscle balance detection.

Goal:
Implement focus-aware imbalance detection across rolling windows using muscle load and movement pattern coverage.

Non-goals:
- Do not implement advanced UI charts.
- Do not shame or medically diagnose users.
- Do not add AI/cloud logic.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Do not use a cloud database for the official exercise catalog.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
Write deterministic domain tests for push-heavy, leg-neglect, upper-focus, lower-focus, and balanced histories before implementation.

Implementation requirements:
- Produce explainable imbalance signals.
- Respect focus profile target ranges.
- Support empty/insufficient data states.

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
`feat(training-science): detect muscle balance signals`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
