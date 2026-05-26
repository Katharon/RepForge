# GDPR / DSGVO Privacy Model

## Core idea

RepForge should be built so that the developer receives no user training data in the MVP. This is the cleanest privacy, compliance, and cost strategy.

## Data classification

### Local user data

Stored locally in Drift/SQLite:

- workout groups
- custom exercises
- set logs with weight/reps
- comments/labels
- user settings
- profile fields needed for future calculations: age, sex, body weight, units, goals
- equipment inventory and maximum available load

### Potentially sensitive data

Treat as sensitive even when stored locally:

- body weight and age
- sex/gender selection
- training history
- readiness, soreness, injuries, pain notes
- heart rate, sleep, calories, wearable imports

### Developer-collected data

MVP target: none, except what app stores/payment providers necessarily process outside the app. If crash reporting, analytics, sync, or support uploads are added later, the privacy model must be updated first.

## GDPR principles mapped to RepForge

- Lawfulness, fairness, transparency: explain what data is stored locally and why.
- Purpose limitation: use profile/training data only for tracking, analytics, and optional user-facing recommendations.
- Data minimization: do not ask for fields before they are needed.
- Accuracy: allow users to edit profile, exercises, and logs.
- Storage limitation: provide delete/export capabilities.
- Integrity and confidentiality: secure local storage and avoid remote leakage.
- Accountability: keep docs, release checklists, and data-flow maps up to date.

## Privacy by design and default

- No account in MVP.
- No remote telemetry in MVP.
- No ad SDK in MVP.
- No third-party analytics in MVP.
- No background upload of workouts.
- Default to local-only.
- Make export/import explicit user actions.
- Make later diagnostics/sync/wearables explicit opt-in features.

## Data subject rights practical support

For a local-first app without account/backend, many rights are implemented through app features:

- Access: user can view local logs and profile.
- Rectification: user can edit logs/profile/exercises.
- Erasure: user can delete individual logs or all app data.
- Portability: export local data in a documented format.

## DPIA / risk review

A formal DPIA may not be required for the local MVP if the developer receives no data and there is no large-scale health profiling. Reassess when adding:

- cloud sync
- remote diagnostics
- wearable imports
- AI/ML coach
- friend/social features
- health/injury fields
- personalized recommendations based on sensitive data

## Engineering requirements

- Keep a data-flow map current.
- Keep privacy policy current.
- Avoid raw sensitive data in logs.
- Add delete/export functionality before public release.
- Add explicit consent/permission flows before health/wearable integrations.
