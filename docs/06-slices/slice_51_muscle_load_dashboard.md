# Slice 51 — Muscle load and balance dashboard

## Goal

Implement UI/read models for weekly and rolling-window muscle load, imbalance signals, and focus-aware explanations.

## Read first

1. `AGENTS.md`
2. `docs/01-domain/muscle_balance_model.md`
3. `docs/03-design-ux/design_system.md`
4. `docs/03-design-ux/component_catalog.md`
5. `docs/06-slices/slice_51_muscle_load_dashboard.md`

## Non-goals

- Do not implement 3D body model yet.
- Do not claim exact muscle fatigue.
- Do not add social comparison.

## TDD requirements

Write BLoC/widget tests for loading, empty state, on-track, under-target, and recovery-limited states before implementation.

## Implementation requirements

- Show simple understandable status.
- Link warnings to suggested actions.
- Keep visual style consistent with dark dashboard UI.
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
feat(analytics): add muscle load dashboard
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/01-domain/muscle_balance_model.md
3. docs/03-design-ux/design_system.md
4. docs/03-design-ux/component_catalog.md
5. docs/06-slices/slice_51_muscle_load_dashboard.md

Implement Slice 51: Muscle load and balance dashboard.

Goal:
Implement UI/read models for weekly and rolling-window muscle load, imbalance signals, and focus-aware explanations.

Non-goals:
- Do not implement 3D body model yet.
- Do not claim exact muscle fatigue.
- Do not add social comparison.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Do not use a cloud database for the official exercise catalog.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
Write BLoC/widget tests for loading, empty state, on-track, under-target, and recovery-limited states before implementation.

Implementation requirements:
- Show simple understandable status.
- Link warnings to suggested actions.
- Keep visual style consistent with dark dashboard UI.

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
`feat(analytics): add muscle load dashboard`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
