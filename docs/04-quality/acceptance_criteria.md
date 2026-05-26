# Acceptance Criteria

## General slice acceptance

A slice is done when:

- The requested behavior is implemented.
- Relevant tests exist and pass.
- `dart format` passes.
- `flutter analyze` passes.
- Docs are updated if needed.
- `docs/05-codex/slice_status.md` is updated.
- A git commit exists unless the user explicitly asked not to commit.

## UI slice acceptance

A UI slice is done when:

- Loading, empty, error, and loaded states are handled where applicable.
- Main actions are reachable with sensible touch targets.
- No business logic is embedded in widgets.
- Widget tests cover the main state.

## Data slice acceptance

A data slice is done when:

- Repositories implement application contracts.
- Mappers are tested.
- Migrations are tested if schema changed.
- No user data is silently lost.

## Payment/cloud slice acceptance

A payment/cloud slice is done only when security and privacy docs are updated, local-only features still work without cloud, and tests/fakes exist for offline or unavailable service states.
