# Slice 49 — Quick session mode

## Goal

Implement quick-session generation for limited-time workouts using profile, equipment, recent muscle load, selected group, and readiness.

## Read first

1. `AGENTS.md`
2. `docs/01-domain/recommendation_engine.md`
3. `docs/01-domain/training_science_model.md`
4. `docs/03-design-ux/information_architecture.md`
5. `docs/06-slices/slice_49_quick_session_mode.md`

## Non-goals

- Do not implement advanced wearables.
- Do not require internet.
- Do not replace normal group sessions.

## TDD requirements

Write tests for 15/25/35-minute generation, limited equipment, high soreness, and balanced fallback before implementation.

## Implementation requirements

- Generate concise plan with 2–5 exercises.
- Show covered/skipped muscles.
- Keep UX fast from Today and Group screens.
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
feat(coach): add quick session mode
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/01-domain/recommendation_engine.md
3. docs/01-domain/training_science_model.md
4. docs/03-design-ux/information_architecture.md
5. docs/06-slices/slice_49_quick_session_mode.md

Implement Slice 49: Quick session mode.

Goal:
Implement quick-session generation for limited-time workouts using profile, equipment, recent muscle load, selected group, and readiness.

Non-goals:
- Do not implement advanced wearables.
- Do not require internet.
- Do not replace normal group sessions.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Do not use a cloud database for the official exercise catalog.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
Write tests for 15/25/35-minute generation, limited equipment, high soreness, and balanced fallback before implementation.

Implementation requirements:
- Generate concise plan with 2–5 exercises.
- Show covered/skipped muscles.
- Keep UX fast from Today and Group screens.

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
`feat(coach): add quick session mode`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
