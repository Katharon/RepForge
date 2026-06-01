# Security and Privacy Threat Model

## Privacy stance

The app is local-first. The user can track workouts without an account and without sending training data to a backend.

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

### Health claim risk

Risk: recommendations are interpreted as medical advice.

Mitigations:

- use careful language,
- show disclaimer,
- label estimates,
- recommend professional advice for pain/illness.

## v5 health/training disclaimer and privacy boundary

The app handles personal training data and optional body metrics. Treat this as sensitive personal data even if it stays local.

Rules:

- Do not claim medical diagnosis.
- Mark recovery, calories, soreness, fatigue, and readiness as estimates.
- Avoid instructions that encourage training through pain.
- Keep local tracking usable without account creation.
- Do not send body metrics, workout history, or equipment inventory to remote services unless a future explicit sync feature asks for consent.
