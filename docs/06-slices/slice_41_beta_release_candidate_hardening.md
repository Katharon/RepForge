# Slice 41 — Beta release candidate hardening

## Goal

Run full QA checklist, fix release blockers, update changelog, and prepare beta tag.

## Read first

1. `AGENTS.md`
2. `docs/04-quality/acceptance_criteria.md`
3. `docs/04-quality/release_management.md`
4. `docs/05-codex/slice_status.md`
5. `docs/06-slices/slice_41_beta_release_candidate_hardening.md`

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

Validate docs, changelog, metadata, and build commands where possible.

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

## Implementation notes

Slice 41 aligns the beta release-candidate metadata around app version
`0.9.0+1` and proposed tag `v0.9.0-beta.1`. It documents the tag command but
does not create or push a tag.

The hardening pass verifies:

- RepForge display names and local-first store copy remain consistent.
- CI and local validation expectations include generated-code freshness.
- The Android debug APK remains an inspection artifact, not a store release.
- Store signing, TestFlight/App Store/Play upload, Firebase config, cloud sync,
  ads, backend activation, and paid runtime services remain future work.

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
chore(release): prepare beta release candidate
```

## Ready-to-use Codex prompt

```text
You are working in the `RepForge` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/04-quality/acceptance_criteria.md
3. docs/04-quality/release_management.md
4. docs/05-codex/slice_status.md
5. docs/06-slices/slice_41_beta_release_candidate_hardening.md

Implement Slice 41: Beta release candidate hardening.

Goal:
Run full QA checklist, fix release blockers, update changelog, and prepare beta tag.

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
Validate docs, changelog, metadata, and build commands where possible.

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
`chore(release): prepare beta release candidate`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
