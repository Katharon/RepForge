# Slice 50 — Adaptive set suggestions and backoff logic

## Goal

Suggest next-set direction based on recent baseline, current performance, readiness, and progressive overload rules.

## Read first

1. `AGENTS.md`
2. `docs/01-domain/recovery_readiness_model.md`
3. `docs/01-domain/training_science_model.md`
4. `docs/01-domain/recommendation_engine.md`
5. `docs/06-slices/slice_50_adaptive_set_suggestions.md`

## Non-goals

- Do not force heavier loads.
- Do not implement medical diagnosis.
- Do not require RPE if not enabled.

## TDD requirements

Write domain tests for good readiness progression, low readiness reduction, strength-down backoff, and no-history starter behavior.

## Implementation requirements

- Recommend add weight/reps/maintain/backoff/stop alternatives.
- Explain reason.
- Keep user override possible.
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

## Implementation notes

Slice 50 is implemented as a pure domain/application extension of the
recommendations feature. It adds deterministic adaptive-set request, baseline,
current-performance, policy, suggestion, alternative, reason-code, suggester,
and use-case types under `lib/src/features/recommendations/`.

No presentation or persistence code was touched. RPE is not modeled in the
training-log domain yet, so adaptive suggestions do not require it and expose a
stable `rpeNotRequired` reason for current behavior.

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
feat(coach): add adaptive set suggestions
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/01-domain/recovery_readiness_model.md
3. docs/01-domain/training_science_model.md
4. docs/01-domain/recommendation_engine.md
5. docs/06-slices/slice_50_adaptive_set_suggestions.md

Implement Slice 50: Adaptive set suggestions and backoff logic.

Goal:
Suggest next-set direction based on recent baseline, current performance, readiness, and progressive overload rules.

Non-goals:
- Do not force heavier loads.
- Do not implement medical diagnosis.
- Do not require RPE if not enabled.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Do not use a cloud database for the official exercise catalog.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
Write domain tests for good readiness progression, low readiness reduction, strength-down backoff, and no-history starter behavior.

Implementation requirements:
- Recommend add weight/reps/maintain/backoff/stop alternatives.
- Explain reason.
- Keep user override possible.

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
`feat(coach): add adaptive set suggestions`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
