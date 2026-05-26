# Data Act Position

## Current position

RepForge MVP has low Data Act exposure because it does not manufacture connected products, does not operate a cloud data service, and does not hold user-generated device data in a backend.

## Why to monitor it anyway

Later features may touch connected-product or device-generated data:

- smartwatch / HealthKit / Health Connect imports
- connected gym equipment
- user export APIs
- cloud sync
- friend/social sharing
- third-party coaching integrations

## Engineering posture

- Keep export formats documented.
- Let users access and export their local data.
- Do not lock user history into opaque formats.
- Keep future wearable imports permission-based and transparent.
- Avoid claiming ownership over user-generated training data.

## Future reassessment triggers

Reassess this file when:

- RepForge stores data on a server.
- RepForge connects to wearables directly rather than through OS health APIs.
- RepForge shares data with third parties.
- RepForge offers APIs or data portability guarantees.
- RepForge integrates connected equipment.
