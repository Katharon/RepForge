# Slice 23 — Onboarding, initial groups, and bundled sample data

## Goal

Implement onboarding that captures goal/focus/time/equipment and optionally creates starter workout groups from bundled local templates.

## Read first

1. `AGENTS.md`
2. `docs/03-design-ux/onboarding_settings.md`
3. `docs/01-domain/user_profile_and_goals.md`
4. `docs/02-architecture/exercise_catalog_distribution.md`
5. `docs/06-slices/slice_23_onboarding_and_sample_data.md`

## Non-goals

- Do not use remote onboarding or account creation.
- Do not download exercises from a cloud database.
- Do not implement payments.

## TDD requirements

Write onboarding flow widget/BLoC tests and use-case tests for starter group creation before implementation.

## Implementation requirements

- Keep onboarding skippable or minimal.
- Create local starter groups only from bundled catalog/templates.
- Preserve user control over focus and defaults.
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

Slice 23 added a compact local onboarding boundary with pure-Dart onboarding
status/draft types, skip/complete use cases, Drift schema v6 onboarding status
persistence, and a minimal localized setup flow shown before Today until skipped
or completed. Completion saves the Slice 22 settings subset: optional profile
name, focus profile, training frequency, session duration, and structured
equipment inventory.

Starter groups are created only when the user leaves the starter-groups option
enabled. The templates live in `assets/templates/starter_groups_v1.json` and
reference stable official catalog IDs/snapshots from the bundled catalog. The
starter use case writes local workout groups and assignments only; it does not
mutate official catalog rows or create custom exercises. Home-gym max-load
values remain a follow-up because Slice 22 does not yet persist max-load fields.

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
feat(onboarding): add profile onboarding and starter groups
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/03-design-ux/onboarding_settings.md
3. docs/01-domain/user_profile_and_goals.md
4. docs/02-architecture/exercise_catalog_distribution.md
5. docs/06-slices/slice_23_onboarding_and_sample_data.md

Implement Slice 23: Onboarding, initial groups, and bundled sample data.

Goal:
Implement onboarding that captures goal/focus/time/equipment and optionally creates starter workout groups from bundled local templates.

Non-goals:
- Do not use remote onboarding or account creation.
- Do not download exercises from a cloud database.
- Do not implement payments.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Do not use a cloud database for the official exercise catalog.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
Write onboarding flow widget/BLoC tests and use-case tests for starter group creation before implementation.

Implementation requirements:
- Keep onboarding skippable or minimal.
- Create local starter groups only from bundled catalog/templates.
- Preserve user control over focus and defaults.

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
`feat(onboarding): add profile onboarding and starter groups`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```

## v5 adjustment

Onboarding must collect profile basics, training frequency, session duration, equipment inventory, and max load for home-gym equipment where relevant. It must default to system language with English fallback.
