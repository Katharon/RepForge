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
