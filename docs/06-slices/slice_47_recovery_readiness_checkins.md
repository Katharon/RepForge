# Slice 47 — Recovery and readiness check-ins

## Goal

Implement local readiness/soreness check-ins and readiness scoring use cases.

## Read first

1. `AGENTS.md`
2. `docs/01-domain/recovery_readiness_model.md`
3. `docs/01-domain/training_science_model.md`
4. `docs/02-architecture/data_persistence.md`
5. `docs/06-slices/slice_47_recovery_readiness_checkins.md`

## Non-goals

- Do not implement medical advice.
- Do not integrate wearables yet.
- Do not block logging based on readiness.

## TDD requirements

Write domain/use-case tests for soreness input, readiness scoring, high soreness behavior, and empty state before implementation.

## Implementation requirements

- Persist check-ins locally.
- Use careful wording.
- Expose readiness read model for Today and recommendations.
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
feat(recovery): add readiness check-ins
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/01-domain/recovery_readiness_model.md
3. docs/01-domain/training_science_model.md
4. docs/02-architecture/data_persistence.md
5. docs/06-slices/slice_47_recovery_readiness_checkins.md

Implement Slice 47: Recovery and readiness check-ins.

Goal:
Implement local readiness/soreness check-ins and readiness scoring use cases.

Non-goals:
- Do not implement medical advice.
- Do not integrate wearables yet.
- Do not block logging based on readiness.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Do not use a cloud database for the official exercise catalog.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
Write domain/use-case tests for soreness input, readiness scoring, high soreness behavior, and empty state before implementation.

Implementation requirements:
- Persist check-ins locally.
- Use careful wording.
- Expose readiness read model for Today and recommendations.

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
`feat(recovery): add readiness check-ins`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
