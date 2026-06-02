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

1. Optional authentication/account identity.
2. Optional user-data sync.
3. Optional purchase verification/entitlement backend.
4. Optional remote push/news.
5. Optional social/friends activity.
6. Optional static content update channel.

These must not be collapsed into one early backend.

## Optional auth boundary

Slice 35 adds a pure-Dart auth boundary for future account, sync, restore,
device-link, or provider features. The default implementation is
`LocalOnlyAuthGateway`, which reports local-only usage and does not require
network, provider SDKs, credentials, token storage, or a backend.

Auth is not required for local tracking, catalog access, workout groups,
analytics, settings, backup/export/import, onboarding, rest timers, purchases,
or entitlement checks. Auth state must not unlock Premium and entitlement state
must not imply a user identity.

## Optional Firebase boundary

Slice 36 adds a pure-Dart Firebase integration boundary for possible future
Firebase Auth, remote push/FCM, Crashlytics, Remote Config, or analytics-event
infrastructure. The boundary is disabled by default and backed by an unavailable
no-op gateway in the composition root.

Firebase is not initialized at app start. No Firebase packages, config files,
Firestore/cloud database, sync behavior, Firebase Auth flow, FCM behavior,
Crashlytics upload, Remote Config fetch, analytics SDK event tracking, or
account requirement is introduced by this boundary.

Local tracking, workout groups, custom exercises, official catalog import,
settings/profile, onboarding, base analytics, local backup/export/import, rest
timers, local notifications, purchases, entitlements, and auth status all remain
usable without Firebase.

## Optional sync model if implemented later

Slice 37 adds only a pure-Dart sync metadata and conflict-policy boundary. It
does not add production sync, a sync engine, background jobs, remote transport,
upload/download behavior, provider SDKs, Firebase, Firestore, accounts, UI, or
database schema changes.

Local database remains the source of truth for offline use. Local tracking,
groups, custom exercises, settings/profile, onboarding, analytics, local
backups, purchases, entitlements, auth status, rest timers, and local
notifications must continue to work with no account and no sync metadata.

Future user-data sync may attach metadata to user-owned entities only:

- `createdAt`,
- `updatedAt`,
- `deletedAt` for tombstones,
- local version,
- optional `remoteId`,
- sync state such as `localOnly`, `pendingUpload`, `synced`, `conflict`,
  `tombstoned`, `failed`, or `unavailable`.

Auth, if used, is optional and may be required only for the optional sync
feature itself. Auth must not be required for local logging, local backup/export,
settings, catalog access, purchases, or entitlement checks.

Firebase is also optional and disabled/unavailable by default. The sync boundary
does not depend on Firebase activation, and Firebase unavailability must not
block local-only use.

Future sync deletes must use tombstones and conflict resolution must be explicit.
No automatic merge should silently overwrite logged set history. Same-entity
version conflicts should default to manual review unless a later explicit sync
slice introduces and tests a narrower safe rule.

## Catalog updates are not sync

Exercise catalog updates are content distribution, not user-data synchronization.

Official catalog and official exercise rows are not cloud-synced user data.
They do not require sync metadata for import or local use.

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
