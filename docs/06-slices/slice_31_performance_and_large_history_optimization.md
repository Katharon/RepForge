# Slice 31 — Performance and large-history optimization

## Goal

Optimize queries, screen rebuilds, chart aggregation, and large set histories.

## Read first

1. `AGENTS.md`
2. `docs/02-architecture/performance.md`
3. `docs/02-architecture/data_persistence.md`
4. `docs/04-quality/test_strategy.md`
5. `docs/06-slices/slice_31_performance_and_large_history_optimization.md`

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

Add benchmark-like tests only if stable; otherwise add query tests and rebuild isolation tests.

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

Slice 31 adds Drift schema v7 performance indexes for workout-set timeline,
history, and session-order queries; keeps timeline/history reads bounded by
existing query limits; caps exercise analytics scans at 2,000 sets; and wires
the Today dashboard's existing set-count, volume, and last-set cards to a
bounded local daily summary query. Large-seed tests cover deterministic history
pagination, cursor timeline paging, daily aggregation, analytics scan limits,
and additive index migration behavior.

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
perf(app): optimize large workout histories
```

## Ready-to-use Codex prompt

```text
You are working in the `RepForge` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/02-architecture/performance.md
3. docs/02-architecture/data_persistence.md
4. docs/04-quality/test_strategy.md
5. docs/06-slices/slice_31_performance_and_large_history_optimization.md

Implement Slice 31: Performance and large-history optimization.

Goal:
Optimize queries, screen rebuilds, chart aggregation, and large set histories.

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
Add benchmark-like tests only if stable; otherwise add query tests and rebuild isolation tests.

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
`perf(app): optimize large workout histories`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
