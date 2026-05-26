# Sync and Cloud Backend Strategy

## Current decision

Do not implement a cloud database for the official exercise catalog.

Do not implement cloud sync before the local training log, analytics, and recommendation MVP are stable.

## No-backend local MVP

The MVP works without accounts, internet, or a hosted database.

Local-first data:

- user profile,
- custom exercises,
- workout groups,
- training sessions,
- sets,
- settings,
- imported official catalog,
- analytics cache if needed.

Official catalog updates arrive through app releases / bundled content patches.

## What cloud may mean later

Cloud is split into separate concerns:

1. Optional user-data sync.
2. Optional purchase verification/entitlement backend.
3. Optional remote push/news.
4. Optional social/friends activity.
5. Optional static content update channel.

These must not be collapsed into one early backend.

## Optional sync model if implemented later

- Local database remains the source of truth for offline use.
- Add sync metadata: `createdAt`, `updatedAt`, `deletedAt`, `version`, `syncState`, `remoteId`.
- Use tombstones for deletes.
- Resolve conflicts explicitly.
- Never block local set logging because sync is unavailable.

## Catalog updates are not sync

Exercise catalog updates are content distribution, not user-data synchronization.

Default mechanism:

- bundled assets,
- app updates,
- local import.

Optional future mechanism:

- signed static JSON download,
- checksum/signature verification,
- local import.

No paid cloud database is needed for either.

## v5 clarification

The official exercise catalog does not require a cloud database. Catalog patches are bundled with app releases or, later, distributed as signed static JSON. Optional user sync is a separate future concern and must not be introduced into MVP tracker code.


## v6 cost boundary

No backend, sync service, cloud database, remote config, or cloud catalog is part of the MVP.

Any future sync must be optional, isolated behind ports, and introduced only after the local product is valuable. It must not be required for tracking, catalog access, workout groups, analytics, or local backup.
