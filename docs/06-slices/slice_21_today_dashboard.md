# Slice 21 — Today dashboard

## Goal

Create the Today dashboard with recent activity, active rest timer, next suggested group placeholder, quick logging entry points, and readiness placeholder states.

## Read first

1. `AGENTS.md`
2. `docs/03-design-ux/information_architecture.md`
3. `docs/03-design-ux/design_system.md`
4. `docs/01-domain/training_science_model.md`
5. `docs/06-slices/slice_21_today_dashboard.md`

## Non-goals

- Do not implement full recommendation engine yet.
- Do not implement wearables/social/payments.
- Do not require internet.

## TDD requirements

Write BLoC/widget tests for dashboard loading, empty state, active rest timer display, and recent activity summary before implementation.

## Implementation requirements

- Show useful local information from existing logs.
- Include placeholders that can later be backed by recommendation/readiness use cases.
- Keep Today fast and action-oriented.
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
feat(today): add training dashboard
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/03-design-ux/information_architecture.md
3. docs/03-design-ux/design_system.md
4. docs/01-domain/training_science_model.md
5. docs/06-slices/slice_21_today_dashboard.md

Implement Slice 21: Today dashboard.

Goal:
Create the Today dashboard with recent activity, active rest timer, next suggested group placeholder, quick logging entry points, and readiness placeholder states.

Non-goals:
- Do not implement full recommendation engine yet.
- Do not implement wearables/social/payments.
- Do not require internet.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Do not use a cloud database for the official exercise catalog.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
Write BLoC/widget tests for dashboard loading, empty state, active rest timer display, and recent activity summary before implementation.

Implementation requirements:
- Show useful local information from existing logs.
- Include placeholders that can later be backed by recommendation/readiness use cases.
- Keep Today fast and action-oriented.

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
`feat(today): add training dashboard`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
