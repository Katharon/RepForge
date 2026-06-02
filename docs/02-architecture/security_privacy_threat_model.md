# Security and Privacy Threat Model

## Privacy stance

The app is local-first. The user can track workouts without an account and without sending training data to a backend.

Store privacy copy must match that stance: for the current MVP baseline,
describe RepForge as local-first with no account requirement, no ads, no
analytics SDK, no cloud sync, and no developer collection of workout data.
Future sync, remote diagnostics, analytics, wearable import, support upload, or
push-provider registration must update this threat model and the store privacy
metadata before any data leaves the device.

## Sensitive data

Potentially sensitive:

- training history,
- body metrics,
- weight/bodyweight,
- age/sex/gender,
- soreness/readiness responses,
- health/wearable data later,
- friend/social activity later,
- purchase data later.

## Key decisions

- No cloud database for official exercise catalog.
- Local rest timers use local notifications.
- Optional sync is post-MVP.
- Wearable integration is opt-in and future-only.
- Social features are separate and opt-in.

## Risks and mitigations

### Local data exposure

Risk: device compromise exposes workout data.

Mitigations:

- use platform app sandbox,
- optional encrypted DB later,
- do not log sensitive data,
- allow export/delete.

### Broken backup import

Risk: malformed backup causes crashes or corrupts local data.

Mitigations:

- validate schema,
- import into transaction,
- keep migration tests,
- reject unknown destructive states.

Slice 24 implements this as JSON v1 validation plus additive/upsert import.
Backup services do not add cloud backup, remote storage, platform file pickers,
or sharing UI; future UI must warn users before exporting sensitive local data.

Slice 30 adds that local backup privacy warning at the application boundary,
keeps backup validation exception strings field-only for log safety, and
provides a backup JSON redactor for diagnostics. Redaction removes top-level
training history, workout groups, assignments, settings/profile, and onboarding
sections while retaining non-sensitive version metadata.

### Notification privacy

Risk: rest-timer notifications displayed on a lock screen expose exercise
names, loads, comments, pain/failure notes, or other training details.

Mitigations:

- schedule local notifications only,
- avoid remote push for MVP,
- sanitize rest-timer notification content before it reaches the platform
  gateway.

Slice 30 replaces workout-specific rest-timer notification title/body text with
generic completion content before scheduling. Future notification UI must keep
lock-screen previews generic unless a later explicit privacy setting changes
that behavior.

### Remote push privacy

Risk: a future Remote Push integration requests device tokens or sends account,
sync, social, news, or coaching notification metadata before the product has an
explicit provider, consent, and backend decision.

Mitigations:

- keep Remote Push disabled by default,
- do not request FCM/APNS tokens in the boundary slice,
- do not upload tokens or register a device with a backend,
- keep remote message handling outside the MVP,
- keep local rest timers on local notifications,
- require a later privacy review before any provider adapter sends identifiers
  or notification registration data off-device.

Slice 38 adds only pure-Dart Remote Push vocabulary, a fakeable gateway, and a
disabled/unavailable default registration path. It does not add Firebase
Messaging, token requests, token upload, backend APIs, account requirements,
sync activation, UI, or changes to local rest-timer notifications.

### Catalog patch corruption

Risk: bundled or downloaded catalog data is malformed.

Mitigations:

- schema validation,
- fixture tests,
- stable IDs,
- idempotent imports,
- signed/checksummed static updates if dynamic content is added later.

### Cloud sync misconfiguration later

Risk: wrong backend rules expose user data.

Mitigations:

- keep sync post-MVP,
- require threat-model update before implementation,
- never mix sync logic into local domain rules.

Slice 37 adds only pure-Dart sync metadata and conflict-policy types. It does
not add a sync engine, remote API, upload/download behavior, background jobs,
provider SDKs, Firebase, Firestore, accounts, UI, database schema changes, or a
cloud exercise catalog. The metadata boundary keeps local-only mode as the
default and models official catalog rows as non-user-data sync candidates.

Future sync implementation must update this threat model before any data leaves
the device. It must keep logged training history protected from silent overwrite,
use tombstones for deletes, keep account use optional and limited to the sync
feature, and keep local use available when sync, auth, or Firebase is
unavailable.

### Authentication privacy

Risk: future auth state is treated as required identity for local tracking or is
confused with purchase entitlement proof.

Mitigations:

- keep auth optional and separate from local workout data,
- keep local tracking usable without accounts,
- do not persist auth tokens in this slice,
- do not use auth state to unlock Premium,
- keep provider SDKs and backend APIs outside domain.

Slice 35 adds only a pure-Dart auth boundary plus a local-only default gateway.
It does not add login UI, provider SDKs, token persistence, backend calls,
cloud sync, account requirements, or auth-based Premium unlocks.

### Optional Firebase privacy

Risk: a future Firebase integration is accidentally treated as required
infrastructure or begins sending training, auth, notification, crash, analytics,
or configuration data before the product has an explicit consent and provider
decision.

Mitigations:

- keep Firebase disabled by default,
- expose only pure-Dart capability/configuration/status models in this slice,
- use an unavailable no-op initialization gateway as the default wiring,
- do not add Firebase SDK packages, options files, Firestore/cloud database,
  Firebase Auth, FCM behavior, Crashlytics upload, Remote Config fetch,
  analytics SDK events, sync, or account requirements,
- require a later explicit slice and privacy review before any real provider
  adapter sends data off-device.

Slice 36 adds only that optional boundary. Failed or unavailable Firebase
initialization must not block local workout logging, local notifications,
settings, backups, purchases, entitlements, or auth boundary behavior.

### Entitlement privacy

Risk: future purchase metadata could be confused with local training identity or
used to require an account for the free tracker.

Mitigations:

- keep entitlement decisions local and source-separated at the domain boundary,
- do not unlock Premium from an unverified local flag,
- do not require accounts, backend calls, or cloud services for local MVP
  features,
- keep purchase/store adapters out of domain until their explicit slices.

Slice 32 implements only pure-Dart gate decisions and a local/free entitlement
source. It does not persist purchase data, add payment SDKs, contact a backend,
or gate existing local MVP functionality.

Slice 33 adds app-store purchase plumbing through a gateway and official
`in_app_purchase` data adapter. Purchase events stay local to the app boundary
and are mapped to provisional/unverified entitlement state only. The slice does
not add accounts, backend calls, receipt/server verification, remote entitlement
storage, paywall UI, RevenueCat, Firebase, ads, sync, or trusted local purchase
flags.

Slice 34 adds a verification boundary and cache policy without adding a backend
or reading raw receipt bodies, purchase tokens, transaction IDs, or remote
entitlement payloads. The default verification source reports verification as
unavailable, so store events do not become trusted entitlement proof by default.
Only verified snapshots with `lastVerifiedAt` may enter the bounded cache, and
stale/expired cache entries do not silently unlock Premium.

### Health claim risk

Risk: recommendations are interpreted as medical advice.

Mitigations:

- use careful language,
- show disclaimer,
- label estimates,
- recommend professional advice for pain/illness.

Slice 40 store metadata must use non-medical wording such as `progress trends`,
`estimated`, `signals`, and `readiness`. Store screenshots and descriptions must
not promise diagnosis, injury prevention, guaranteed hypertrophy, or guaranteed
strength outcomes.

## v5 health/training disclaimer and privacy boundary

The app handles personal training data and optional body metrics. Treat this as sensitive personal data even if it stays local.

Rules:

- Do not claim medical diagnosis.
- Mark recovery, calories, soreness, fatigue, and readiness as estimates.
- Avoid instructions that encourage training through pain.
- Keep local tracking usable without account creation.
- Do not send body metrics, workout history, or equipment inventory to remote services unless a future explicit sync feature asks for consent.
