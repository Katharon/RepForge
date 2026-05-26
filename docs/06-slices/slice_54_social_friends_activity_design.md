# Slice 54 — Friends and social activity design

## Goal

Design the future friends/activity feature while preserving local-first privacy and avoiding premature backend implementation.

## Read first

1. `AGENTS.md`
2. `docs/02-architecture/security_privacy_threat_model.md`
3. `docs/00-project/product_requirements.md`
4. `docs/06-slices/slice_54_social_friends_activity_design.md`

## Non-goals

- Do not implement backend/social UI yet.
- Do not require accounts for local tracking.
- Do not expose private training data by default.

## TDD requirements

Design-only slice unless explicitly approved. If code is added, tests must cover privacy defaults.

## Implementation requirements

- Define social bounded context.
- Define privacy defaults.
- Define what activity data can be shared later.
- Document backend questions.
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
docs(social): define friends activity boundary
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/02-architecture/security_privacy_threat_model.md
3. docs/00-project/product_requirements.md
4. docs/06-slices/slice_54_social_friends_activity_design.md

Implement Slice 54: Friends and social activity design.

Goal:
Design the future friends/activity feature while preserving local-first privacy and avoiding premature backend implementation.

Non-goals:
- Do not implement backend/social UI yet.
- Do not require accounts for local tracking.
- Do not expose private training data by default.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Do not use a cloud database for the official exercise catalog.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
Design-only slice unless explicitly approved. If code is added, tests must cover privacy defaults.

Implementation requirements:
- Define social bounded context.
- Define privacy defaults.
- Define what activity data can be shared later.
- Document backend questions.

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
`docs(social): define friends activity boundary`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
