# Slice 30 — Security and privacy hardening

## Goal

Review storage, notifications, permissions, logs, exports, and privacy settings.

## Read first

1. `AGENTS.md`
2. `docs/02-architecture/security_privacy_threat_model.md`
3. `docs/02-architecture/error_handling_observability.md`
4. `docs/03-design-ux/onboarding_settings.md`
5. `docs/06-slices/slice_30_security_and_privacy_hardening.md`

## Implementation note

Slice 30 keeps hardening local-first and dependency-free:

- Backup export exposes a local privacy warning before future UI chooses a
  destination.
- Backup validation exception strings are log-safe and list fields only, while
  detailed validation errors remain structured for UI and tests.
- Backup diagnostics can redact sensitive top-level training, group,
  assignment, settings, and onboarding sections before a JSON snippet is logged.
- Rest-timer notifications replace workout-specific title/body text with a
  generic completion message before scheduling, so lock screens do not expose
  exercise names, loads, comments, or pain/failure notes.

No database schema, native permission, UI, cloud, analytics SDK, crash
reporting, file picker, sync, or encrypted storage change is introduced.

## Current assumptions

- Work from the current repository state.
- Keep changes limited to this slice.
- Keep documentation synchronized with implementation.
- Prefer the smallest production-quality increment over a broad prototype.

## Non-goals

- Do not implement later slices.
- Do not change unrelated architecture decisions.
- Do not add packages unless necessary for this slice.

## TDD requirements

Add tests for privacy settings, notification privacy, and export safeguards where applicable.

If strict TDD is impractical because this is a repository/bootstrap slice, explain why and add the earliest possible smoke test.

## Implementation requirements

- Follow `AGENTS.md`.
- Keep layer boundaries from the architecture docs.
- Use explicit, readable names from the ubiquitous language.
- Handle loading, empty, error, and success states where this slice touches UI.
- Add fakes/mocks instead of using real platform services in unit tests.
- Update affected docs if implementation decisions differ from the initial plan.

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

Add slice-specific commands if appropriate, such as:

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
feat(security): harden privacy and local data handling
```

## Ready-to-use Codex prompt

```text
You are working in the `RepForge` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/02-architecture/security_privacy_threat_model.md
3. docs/02-architecture/error_handling_observability.md
4. docs/03-design-ux/onboarding_settings.md
5. docs/06-slices/slice_30_security_and_privacy_hardening.md

Implement Slice 30: Security and privacy hardening.

Goal:
Review storage, notifications, permissions, logs, exports, and privacy settings.

Non-goals:
- Do not implement later slices.
- Do not change unrelated architecture decisions.
- Do not add packages unless necessary for this slice.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
Add tests for privacy settings, notification privacy, and export safeguards where applicable.

Implementation requirements:
- Make the smallest complete production-quality change for this slice.
- Keep naming aligned with the ubiquitous language and docs.
- Add loading/empty/error handling for UI touched by this slice.
- Use fakes/mocks for platform services in tests.

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
`feat(security): harden privacy and local data handling`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
