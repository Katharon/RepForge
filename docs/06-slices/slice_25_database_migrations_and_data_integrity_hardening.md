# Slice 25 — Database migrations and data integrity hardening

## Goal

Add migration tests, integrity checks, archive/delete rules, and repair utilities.

## Read first

1. `AGENTS.md`
2. `docs/02-architecture/data_persistence.md`
3. `docs/02-architecture/migrations_import_export.md`
4. `docs/04-quality/acceptance_criteria.md`
5. `docs/06-slices/slice_25_database_migrations_data_integrity_hardening.md`

Note: the canonical slice file is
`docs/06-slices/slice_25_database_migrations_and_data_integrity_hardening.md`.
The path above is a stale planning reference.

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

Write repository/database/migration tests first where possible.

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

## Implementation note

Slice 25 implemented a local-only persistence hardening pass:

- pinned Drift schema version 6, expected table names, current schema
  validation, and a non-empty schema v1 migration fixture;
- added constraint coverage for workout sets, catalog metadata, workout groups,
  assignments, settings, and onboarding;
- added deterministic integrity findings under shared local data with severity,
  code, message, affected table/entity id, and safe-repair availability;
- added report-only-by-default repair behavior with explicit safe normalization
  of legacy blank workout-set labels to `NULL`;
- added archive/delete policy tests for workout-set deletion, historical
  snapshots, assignment removal, settings/onboarding isolation, and backup
  import upsert safety.

Historical generated Drift schema snapshots did not exist before this slice, so
the migration coverage is an honest foundation rather than a claim of complete
history replay. Future schema bumps should add generated historical snapshots or
fixtures at the time the schema changes.

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
test(persistence): harden migrations and data integrity
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/02-architecture/data_persistence.md
3. docs/02-architecture/migrations_import_export.md
4. docs/04-quality/acceptance_criteria.md
5. docs/06-slices/slice_25_database_migrations_data_integrity_hardening.md

Implement Slice 25: Database migrations and data integrity hardening.

Goal:
Add migration tests, integrity checks, archive/delete rules, and repair utilities.

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
Write repository/database/migration tests first where possible.

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
`test(persistence): harden migrations and data integrity`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
