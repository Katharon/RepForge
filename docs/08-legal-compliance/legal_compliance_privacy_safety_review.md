# Legal, Compliance, Privacy, and Safety Review

## Status

Slice 55 review baseline. This is an engineering and product compliance review,
not legal advice. It does not finalize a privacy policy, terms, subscription
copy, data-safety declaration, age rating, or store submission. Release-owner
and, where appropriate, qualified legal review are still required before public
release.

## Current Product Stance

Current RepForge documentation and runtime metadata support this baseline:

- RepForge is a local-first workout tracker.
- Local tracking, groups, catalog access, settings/profile, readiness
  check-ins, analytics, recommendations, quick sessions, adaptive suggestions,
  backup/export/import, purchases, and entitlements remain usable without an
  account.
- Official exercise catalog content is bundled as versioned local assets and
  imported locally. It is not a cloud database.
- The current MVP baseline does not include cloud sync, Firebase initialization,
  Firestore, backend APIs, remote analytics, ads, crash reporting, remote push
  runtime, social runtime, wearable runtime, health permissions, or health-data
  upload.
- Android currently declares local notification permission for rest-timer
  notifications. iOS metadata does not declare health permissions or special
  health/social/cloud capabilities.
- `pubspec.yaml` includes `in_app_purchase` and
  `flutter_local_notifications`, but no Firebase, ads, wearable, health,
  backend, or analytics SDK package.

## Not Legal Advice

These documents are product and engineering guardrails. Before production
release, the owner must review and finalize:

- privacy policy in English and German,
- terms/safety disclaimer,
- app-store privacy/data-safety forms,
- support contact and deletion request path,
- app category and age/content rating,
- screenshots, promotional text, and store claims,
- subscription/trial/renewal disclosures if Premium is enabled,
- open-source license notices,
- trademark and store-name availability for `RepForge`.

## Claim Review

Acceptable claim posture:

- `local-first`,
- `no account required` for the current local MVP,
- `no ads`, `no analytics SDK`, and `no cloud sync` for the current baseline,
- `progress trends`, `readiness estimate`, `estimated muscle load`,
  `rough calorie estimate` for future calories, and `advisory suggestions`.

Avoid or block:

- exact calorie burn or exact fatigue measurement,
- medical diagnosis, treatment, rehabilitation, medical decision-making, or
  injury-prevention claims,
- guaranteed hypertrophy, fat loss, strength gain, or safety outcomes,
- mandatory or coercive instructions such as `must train`, `must stop`, or
  `force heavier`,
- shaming, body-comparison, or public ranking language,
- claims that cloud sync, Firebase, social feeds, wearable integration, remote
  push, or health permissions are active before explicit implementation slices
  ship them.

## Data and Privacy Review

### Local MVP Data

Treat these as sensitive even when local-only:

- workout history, sets, loads, repetitions, timestamps, comments, and labels,
- custom exercises and workout groups,
- body weight, height, age/birth year, sex/gender preference, goals, and
  equipment constraints,
- readiness, soreness, sleep, energy, stress, motivation, pain/injury context,
- local backups and export files,
- purchase and entitlement state,
- future wearable/health data, heart rate, calories, active energy, and social
  activity.

### Developer Collection

The current baseline should be documented as no developer collection of workout
history or profile data. If diagnostics, analytics SDKs, support uploads, sync,
Firebase, backend services, remote push token registration, social sharing, or
wearable/health integrations are added later, all affected privacy and store
documents must be updated before release.

### Export and Backup

Backup/export/import remains user-controlled and local-first. Release copy must
warn that exported files can contain sensitive training/profile data and that
the user controls where exported files are stored or shared. If future
wearable/health or social data is included in exports, the export schema and
privacy copy must say so explicitly before shipping.

## Training and Safety Review

Training guidance must stay advisory:

- readiness is an estimate based on local check-ins, not a diagnosis,
- muscle load and balance are estimated training signals, not exact fatigue
  measurement,
- recommendations, quick sessions, and adaptive set suggestions are optional and
  user-overridable,
- low readiness, soreness, or strength-down states may suggest lighter work,
  alternatives, or rest, but must not block logging,
- pain, injury symptoms, dizziness, pregnancy, medical conditions, or safety
  uncertainty should point users toward qualified professionals.

Future UI/store copy should prefer:

- `consider`,
- `may be useful`,
- `appears`,
- `estimated`,
- `based on your logged data`,
- `rough estimate`,
- `trend`,
- `advisory`.

## Future Feature Gates

### Health and Wearables

Before any health/wearable runtime ships:

- define exact data categories and permission scopes,
- add localized opt-in, disconnect, delete, and export wording,
- update privacy policy, store privacy/data-safety forms, threat model, release
  checklist, and tests,
- confirm no account, sync, Firebase, backend, cloud analytics, or upload is
  required for local tracking,
- label calorie outputs as rough estimates only.

### Social and Friends

Before any social runtime ships:

- keep social off by default and private by default,
- define shareable versus sensitive fields,
- add localized opt-in, first-share preview, revoke, delete/unshare, block,
  mute, report, and account-deletion wording,
- define moderation, abuse prevention, retention, export, deletion, and
  operator-access rules,
- confirm raw workout logs, exact sets/reps/loads, comments, notes, body
  metrics, readiness, soreness, wearable/health data, backups, location, and
  precise timestamps are excluded by default.

### Remote Push

Remote push is only for future server-driven notifications. It must not replace
local rest-timer notifications and must not request or upload tokens before the
feature has provider, backend, consent/account, and privacy review decisions.

### Premium and Payments

Core local tracking, groups, base analytics, custom exercises, and
backup/export/import remain free. If Premium is enabled, release copy must
clearly disclose:

- what is free,
- what is Premium,
- trial length if any,
- price and billing period,
- renewal behavior,
- cancellation path through app-store mechanisms,
- restore-purchase behavior,
- terms and privacy links.

Entitlement state is not account identity, and provisional/unverified purchase
events must not be marketed as trusted proof of Premium access.

## Release Owner Checklist

Before public release, confirm:

- [ ] Exact shipped binary matches store privacy/data-safety declarations.
- [ ] Privacy policy drafts are finalized in English and German.
- [ ] Terms/safety disclaimer is finalized.
- [ ] Support contact and deletion request path are live.
- [ ] Open-source license notices are available.
- [ ] App category and age/content rating are reviewed.
- [ ] Store screenshots show only shipped behavior.
- [ ] Store copy avoids medical, exact-measurement, injury-prevention,
  guaranteed-result, shaming, and coercive claims.
- [ ] Backup/export privacy warning matches the shipped export format.
- [ ] Premium/subscription claims are disabled or fully configured and reviewed.
- [ ] Health, social, sync, Firebase, backend, remote push, ads, diagnostics,
  analytics SDK, and wearable claims are future-only unless explicitly enabled
  by later slices and privacy review.
- [ ] No signing secrets, keystores, provisioning profiles, Firebase config
  files, store service accounts, or publishing credentials are committed.

## Slice 55 Finding

No risky current runtime activation was found in the reviewed source-of-truth
files. The remaining risk is release process risk: owner/legal review,
finalized privacy/store documents, support/deletion paths, screenshots, and
subscription disclosures must be completed before public distribution.
