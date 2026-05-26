# Resilience Governance

## Goal

RepForge must protect user training history from accidental data loss, corrupted migrations, broken catalog patches, and avoidable runtime failures. Because the app is local-first, resilience is primarily local product engineering, not cloud operations.

## Principles

- Local-first does not mean disposable. The local database is the user's source of truth.
- Drift migrations must be deterministic, tested, and backward-compatible where possible.
- Catalog patches must never overwrite user-created exercises or user overrides.
- Import/export must be predictable and documented.
- Every release must have a rollback-aware migration strategy.
- Every destructive action needs clear UX, confirmation, and undo/export paths where feasible.

## Resilience areas

### 1. Database resilience

- Use Drift migrations with tests.
- Every schema migration must have fixtures for old and new schema states.
- Add migration tests before changing production tables.
- Do not delete user data columns without a documented migration/export path.
- Prefer additive schema changes during early product evolution.

### 2. Catalog resilience

- Official catalog source of truth: versioned JSON assets.
- Runtime projection: local Drift/SQLite tables.
- Importer must be idempotent.
- Catalog entries need stable IDs.
- User-created exercises and user overrides must survive catalog updates.
- A failed catalog import must not block access to existing user logs.

### 3. App-state resilience

- In-progress workout sessions should survive app pause/resume and process death when feasible.
- Rest timers should behave safely after app restart.
- Never rely only on in-memory Cubit/BLoC state for important user-entered logs.

### 4. Backup and export

- Provide local export before cloud sync is considered.
- Export format should be documented and versioned.
- Import must validate data before writing.
- Imports should support dry-run validation in later versions.

### 5. Release resilience

Before each release:

- Run unit, widget, integration, and migration tests.
- Validate catalog JSON schema.
- Validate localization completeness for English and German.
- Validate no Premium-only dependency breaks the free local core.
- Update `CHANGELOG.md`, slice status, and release checklist.

## Non-goals for MVP

- No cloud failover.
- No remote sync conflict resolution.
- No remote observability pipeline.
- No paid crash analytics dependency.
