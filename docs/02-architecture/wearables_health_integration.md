# Wearables and Health Integration

## Status

Design boundary only. Slice 53 documents the future integration shape without
adding runtime health permissions, wearable SDK packages, production platform
adapters, background collection, account requirements, sync, or upload.

Wearables remain post-MVP, disabled by default, and opt-in only.

## Goal

Allow future RepForge versions to use optional heart-rate/activity data to make
rough training estimates a little more contextual while preserving the
local-first product stance. The integration must never be required for logging,
groups, analytics, readiness check-ins, backup/export, or the future coach.

Calories must always be presented as rough estimates, not exact measurements or
medical/metabolic truth.

## Non-goals

- No production HealthKit, Health Connect, Google Fit, or wearable SDK runtime
  in the boundary slice.
- No Android or iOS health permissions until a later explicit implementation
  slice.
- No background health collection.
- No hidden upload, cloud analytics, Firebase, backend, or account requirement.
- No claim of exact calorie burn, injury prevention, diagnosis, or medical
  readiness.
- No automatic sync of health data. Future sync would need a separate explicit
  opt-in design and privacy review.

## Boundary Vocabulary

Future code, if added, should start with pure-Dart models and ports. Suggested
names:

- `WearableIntegrationStatus`: disabled, unavailable, permission not requested,
  permission denied, connected, failed.
- `WearableProviderKind`: manual, HealthKit, Health Connect, Google Fit, watch
  vendor, or unknown.
- `WearablePermissionState`: not requested, granted read, denied, restricted,
  unavailable.
- `WearableSampleSource`: local manual entry, platform health store, watch,
  imported backup, or unknown.
- `HeartRateSample`: UTC timestamp, beats per minute, source, and optional
  quality flag.
- `NormalizedWearableSample`: validated sample in app-native units with source
  metadata and no provider-specific payload.
- `WearableDataGateway`: fakeable application/data boundary for capability
  status, explicit read requests, disconnect, local deletion, and export
  metadata. It must not upload.
- `CalorieEstimateInput`: duration, optional body weight, optional age/birth
  year, optional sex/gender preference, optional intensity/training type, and
  optional heart-rate summary.
- `CalorieEstimate`: unavailable or rough estimate, value range or rounded
  value, confidence, formula identity, and missing-input reasons.
- `CalorieEstimateConfidence`: unavailable, low, medium, or high. High still
  means high for a rough estimate, not exact burn.
- `CalorieEstimator`: deterministic pure-Dart service with no platform or
  network dependencies.

Provider SDKs and permission APIs belong only in data/platform adapters. Domain
and application layers receive normalized samples and explicit status values,
never HealthKit, Health Connect, Google Fit, watch SDK, Drift, Flutter, or
backend types.

## Provider Strategy

Future provider adapters must be additive and replaceable:

- HealthKit: iOS-only adapter, added only after store/privacy copy and
  permission wording are approved.
- Health Connect: Android adapter, added only after the exact read permissions
  are justified.
- Google Fit: only if still relevant for the target Android release and
  explicitly approved in a later slice.
- Manual/local source: allowed for testing and user-entered duration/intensity
  inputs, but must be labeled as user-entered.

Provider-specific records are normalized at the app boundary. RepForge should
store only normalized fields needed for the feature, not raw provider payloads,
device identifiers, account identifiers, or unnecessary health categories.

## Opt-In Flow Expectations

The user must be able to use RepForge normally without enabling wearable access.
A future opt-in flow should:

1. Explain which data categories are requested, for example heart rate during
   workouts and optionally active energy if the provider supplies it.
2. Explain why the data is used: rough estimates and context signals.
3. State that data stays local by default and is not uploaded.
4. Request the minimum read-only permissions needed for the chosen provider.
5. Allow disconnecting the provider without deleting normal workout logs.
6. Offer local deletion of imported/normalized wearable samples.

Permission prompts must not happen on app launch, onboarding, or settings page
visit. They happen only after an explicit user action.

## Local Data Retention

Default retention is local-only:

- Imported wearable samples stay on device.
- Disconnecting stops future reads and keeps existing local samples only if the
  user chooses to retain them.
- Deletion removes normalized wearable samples and calorie estimate inputs that
  depend on them, without deleting workout logs.
- Backup/export must either include wearable data only after explicit wording or
  clearly exclude it. A future implementation slice must define the exact backup
  schema before exporting health data.
- No account is required to connect, read, disconnect, delete, or use the app
  without wearables.

## Calorie Estimate Policy

Calorie estimates are optional and approximate. They are a coaching/trend signal,
not a measurement.

Allowed future inputs:

- workout duration,
- body weight if the user has entered it,
- age or birth year if available,
- sex/gender preference if available and used only as an optional formula input,
- training type or intensity estimate,
- optional normalized heart-rate summary,
- optional provider active-energy value, still labeled as provider-reported and
  rough in RepForge copy.

Rules:

- Missing duration means unavailable.
- Invalid or negative duration is rejected.
- Missing body weight, age, sex/gender, or heart-rate context lowers confidence
  or makes the estimate unavailable depending on the formula.
- Output must be labeled `rough estimate` or equivalent localized copy.
- Prefer rounded values or ranges over precise-looking decimals.
- Store formula identity/version if values are persisted or compared over time.
- Do not compare calorie burn competitively between users.

No formula is implemented in Slice 53. A future implementation may use simple
deterministic MET or heart-rate-based formulas, but must document assumptions,
confidence, missing-input behavior, and test fixtures before shipping UI.

## Heart-Rate Normalization

Future normalization should validate heart-rate samples before they enter
analytics or calorie estimation:

- timestamp must be valid UTC,
- source kind must be present,
- beats per minute must be finite and within a conservative human range,
- provider-specific quality/metadata must be reduced to app-level quality flags,
- duplicate handling must be deterministic,
- samples outside an explicitly selected workout window must not be silently
  attached to that workout.

Heart-rate data may inform rough calorie estimates and future readiness context,
but it must not diagnose recovery, health status, arrhythmia, overtraining, or
injury risk.

## Privacy rules

- Opt-in only.
- Disabled by default.
- Explain exactly what is read and why.
- Request read-only permissions only after explicit consent.
- No hidden upload.
- No cloud sync or remote analytics by default.
- No account requirement.
- Do not log raw health values in diagnostics.
- Keep provider credentials/tokens out of domain and do not persist them unless
  a later provider slice explicitly designs secure storage.
- Allow disconnect/delete.
- Keep store privacy and platform data-safety copy aligned before any runtime
  health access ships.

## Future Implementation Steps

1. Add pure-Dart value objects, estimator contract, fake gateway, and tests.
2. Add local persistence only if the feature needs retained normalized samples.
3. Update backup/export schema and deletion behavior before storing health data.
4. Add disabled/info-only settings UI with localized privacy copy.
5. Add one provider adapter at a time with platform permission review.
6. Update store privacy/data-safety declarations before any build requests
   health permissions.
7. Validate guardrails for no upload, no account requirement, no SDK leakage into
   domain, and careful `rough estimate` wording.

## MVP Calorie Estimate Without Wearable

No runtime calorie feature exists in Slice 53. If a later MVP estimate is added
without wearable access, it may use anthropometric approximation from:

- bodyweight,
- age,
- sex/gender if provided,
- duration,
- training type/intensity estimate.

It must be optional, low-confidence when inputs are incomplete, and labeled as a
rough estimate.
