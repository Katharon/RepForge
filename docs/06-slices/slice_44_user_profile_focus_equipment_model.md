# Slice 44 — User profile, focus, and equipment domain model

## Goal

Implement domain/application model for sex/gender, goals, focus profiles, training frequency, session duration, equipment, recovery sensitivity, and coaching strictness.

## Read first

1. `AGENTS.md`
2. `docs/01-domain/user_profile_and_goals.md`
3. `docs/01-domain/training_science_model.md`
4. `docs/02-architecture/data_persistence.md`
5. `docs/06-slices/slice_44_user_profile_focus_equipment_model.md`

## Non-goals

- Do not implement full recommendation engine.
- Do not hard-code stereotypes as rules.
- Do not add wearables.

## TDD requirements

Write value-object/use-case/repository tests first for validation and persistence.

## Implementation requirements

- Use user-overridable defaults.
- Represent focus profile explicitly.
- Persist locally.
- Prepare settings/onboarding integration.
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
feat(profile): add training profile model
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/01-domain/user_profile_and_goals.md
3. docs/01-domain/training_science_model.md
4. docs/02-architecture/data_persistence.md
5. docs/06-slices/slice_44_user_profile_focus_equipment_model.md

Implement Slice 44: User profile, focus, and equipment domain model.

Goal:
Implement domain/application model for sex/gender, goals, focus profiles, training frequency, session duration, equipment, recovery sensitivity, and coaching strictness.

Non-goals:
- Do not implement full recommendation engine.
- Do not hard-code stereotypes as rules.
- Do not add wearables.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Do not use a cloud database for the official exercise catalog.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
Write value-object/use-case/repository tests first for validation and persistence.

Implementation requirements:
- Use user-overridable defaults.
- Represent focus profile explicitly.
- Persist locally.
- Prepare settings/onboarding integration.

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
`feat(profile): add training profile model`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```

## v5 adjustment

Include sex/gender, age/birth year, body weight, optional height, focus profile, training days, session duration, equipment inventory, max load, and increments.
