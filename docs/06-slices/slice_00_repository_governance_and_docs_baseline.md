# Slice 00 — Repository governance and docs baseline

## Goal

Establish the repository documentation, governance files, issue/PR templates, and slice workflow before any Flutter code.

## Read first

1. `AGENTS.md`
2. `README.md`
3. `docs/05-codex/codex_workflow.md`
4. `docs/05-codex/commit_conventions.md`
5. `docs/06-slices/index.md`

## Current assumptions

- Work from the current repository state.
- Keep changes limited to this slice.
- Keep documentation synchronized with implementation.
- Prefer the smallest production-quality increment over a broad prototype.

## Non-goals

- Do not create Flutter source code yet unless the repository already exists and needs doc references.
- Do not add external services.

## TDD requirements

No code tests yet. Validate markdown links where tooling exists.

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
docs(repo): add project governance and slice workflow
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. README.md
3. docs/05-codex/codex_workflow.md
4. docs/05-codex/commit_conventions.md
5. docs/06-slices/index.md

Implement Slice 00: Repository governance and docs baseline.

Goal:
Establish the repository documentation, governance files, issue/PR templates, and slice workflow before any Flutter code.

Non-goals:
- Do not create Flutter source code yet unless the repository already exists and needs doc references.
- Do not add external services.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
No code tests yet. Validate markdown links where tooling exists.

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
`docs(repo): add project governance and slice workflow`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
