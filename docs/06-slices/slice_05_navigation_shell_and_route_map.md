# Slice 05 — Navigation shell and route map

## Goal

Introduce main navigation destinations and route structure with placeholder screens.

## Read first

Use the read list from the active Slice 05 prompt. The implementation was based
on the current RepForge architecture, tech-stack, design-system, component,
workflow, slice-status, changelog, pubspec, app-shell, composition-root, and
widget-test files.

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

Add navigation smoke/widget tests for placeholder routes.

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

Slice 05 adds `go_router` because
`docs/02-architecture/tech_stack_and_packages.md` already identifies it as the
intended routing package. The implementation keeps routing minimal:

- stable pure-Dart route identifiers and paths in `AppRoute`,
- a small `MaterialApp.router` setup in the app shell,
- a mobile-first Material 3 bottom `NavigationBar`,
- localized English/German destination labels,
- placeholder pages only for Today, Groups, Exercises, Analytics, and Settings.

No feature behavior, persistence, catalog import, analytics logic, backend,
Firebase, ads, sync, payments, or remote services were introduced.

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
feat(navigation): add app shell and route map
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/03-design-ux/information_architecture.md
3. docs/03-design-ux/navigation.md
4. docs/02-architecture/architecture_overview.md
5. docs/06-slices/slice_05_navigation_shell_route_map.md

Implement Slice 05: Navigation shell and route map.

Goal:
Introduce main navigation destinations and route structure with placeholder screens.

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
Add navigation smoke/widget tests for placeholder routes.

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
`feat(navigation): add app shell and route map`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
