# Slice 22 — Settings and user profile foundation

## Goal

Implement settings for units, theme, default rest time, user profile, focus profile, training frequency, session duration, and available equipment.

## Read first

1. `AGENTS.md`
2. `docs/01-domain/user_profile_and_goals.md`
3. `docs/03-design-ux/onboarding_settings.md`
4. `docs/02-architecture/data_persistence.md`
5. `docs/06-slices/slice_22_settings_foundation.md`

## Non-goals

- Do not implement onboarding wizard if reserved for Slice 23.
- Do not implement recommendation engine.
- Do not implement account/sync.

## TDD requirements

Write use-case/BLoC/widget tests for loading, editing, validating, and saving profile/settings before implementation.

## Implementation requirements

- Persist profile locally.
- Use focus profiles from docs.
- Represent equipment as structured values.
- Make all personalization user-overridable.
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

Slice 22 added a local-first settings/profile feature boundary with pure-Dart
settings domain types, load/save/reset use cases, Drift schema v5 persistence,
repository mappers, composition-root wiring, and a compact localized Settings
tab. The implemented MVP fields are language override, units, theme preference,
default rest time, optional profile display name, focus profile, training
frequency, session duration, and structured equipment inventory. Existing
workout sets, workout groups, and official catalog rows are not modified by
settings saves.

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
feat(settings): add user profile settings
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/01-domain/user_profile_and_goals.md
3. docs/03-design-ux/onboarding_settings.md
4. docs/02-architecture/data_persistence.md
5. docs/06-slices/slice_22_settings_foundation.md

Implement Slice 22: Settings and user profile foundation.

Goal:
Implement settings for units, theme, default rest time, user profile, focus profile, training frequency, session duration, and available equipment.

Non-goals:
- Do not implement onboarding wizard if reserved for Slice 23.
- Do not implement recommendation engine.
- Do not implement account/sync.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Do not use a cloud database for the official exercise catalog.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
Write use-case/BLoC/widget tests for loading, editing, validating, and saving profile/settings before implementation.

Implementation requirements:
- Persist profile locally.
- Use focus profiles from docs.
- Represent equipment as structured values.
- Make all personalization user-overridable.

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
`feat(settings): add user profile settings`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```

## v5 adjustment

Settings must be prepared for language override, profile basics, units, and equipment inventory editing.
