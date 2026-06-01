# Slice 35 — Authentication abstraction

## Goal

Add auth domain/application boundary for future account/cloud features without forcing login for local use.

## Read first

1. `AGENTS.md`
2. `docs/02-architecture/payments_entitlements.md`
3. `docs/02-architecture/sync_cloud_backend_strategy.md`
4. `docs/06-slices/slice_35_authentication_abstraction.md`

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

Write fake auth gateway tests and ensure local-only use remains available.

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
feat(auth): add optional authentication boundary
```

## Implementation note

Slice 35 adds an optional pure-Dart auth boundary under `lib/src/features/auth/`
without adding a real auth provider, account requirement, backend, SDK, token
persistence, or login UI. The domain exposes `AuthUserId`, `AuthProvider`,
`AuthIdentity`, `AuthSession`, `AuthSessionState`, `AuthFailure`,
`AuthStatusSnapshot`, and the fakeable `AuthGateway` port.

Application code adds `GetAuthStatus`, `SignOut`, `AuthSessionPolicy`, and
`LocalOnlyAuthGateway`. The composition root uses `LocalOnlyAuthGateway` by
default, so RepForge reports a local-only session and keeps all local MVP
features usable without credentials. Auth state is deliberately independent of
entitlements and purchases: signing in does not unlock Premium, and purchase
verification does not require auth in this slice.

No persistence was added. Future auth/provider slices must keep tokens out of
domain, avoid storing secrets unprotected, and update privacy/security docs
before adding accounts, sync, restore, or remote provider behavior.

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/02-architecture/payments_entitlements.md
3. docs/02-architecture/sync_cloud_backend_strategy.md
4. docs/06-slices/slice_35_authentication_abstraction.md

Implement Slice 35: Authentication abstraction.

Goal:
Add auth domain/application boundary for future account/cloud features without forcing login for local use.

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
Write fake auth gateway tests and ensure local-only use remains available.

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
`feat(auth): add optional authentication boundary`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
