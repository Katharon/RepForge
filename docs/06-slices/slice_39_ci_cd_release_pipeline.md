# Slice 39 — CI/CD release pipeline

## Goal

Add GitHub Actions workflows for analyze/test/build/release artifacts.

## Implementation note

Slice 39 upgrades the GitHub Actions quality workflow into `RepForge CI`.
It runs on pull requests, pushes to `main`/`develop`, and manual
`workflow_dispatch`. The quality job installs Flutter dependencies, generates
localizations, runs `build_runner`, verifies generated `lib`/`test` files are
committed, checks formatting, analyzes, runs the full Flutter test suite, runs
the deterministic integration-style test folder, and runs `scripts/check.sh` for
local/CI parity.

The workflow also adds a dependent Android debug artifact job. It builds
`flutter build apk --debug` and uploads `repforge-debug-apk` through
`actions/upload-artifact`. It does not publish to app stores, add signing
secrets, commit keystores, configure Firebase, add cloud/backend integration, or
change app code.

## Read first

1. `AGENTS.md`
2. `docs/04-quality/ci_cd.md`
3. `docs/04-quality/release_management.md`
4. `docs/06-slices/slice_39_ci_cd_release_pipeline.md`

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

Validate YAML and run available local checks.

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
ci(flutter): add release-ready pipeline
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/04-quality/ci_cd.md
3. docs/04-quality/release_management.md
4. docs/06-slices/slice_39_ci_cd_release_pipeline.md

Implement Slice 39: CI/CD release pipeline.

Goal:
Add GitHub Actions workflows for analyze/test/build/release artifacts.

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
Validate YAML and run available local checks.

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
`ci(flutter): add release-ready pipeline`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
