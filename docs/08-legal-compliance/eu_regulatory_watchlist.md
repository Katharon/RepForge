# EU Regulatory Watchlist

## Scope

This file tracks EU rules that may affect RepForge. It is not legal advice.

## GDPR / DSGVO

Main relevance:

- profile fields such as age, sex, weight
- workout history
- notes, soreness, injury, recovery/readiness data
- future wearable/health data
- future cloud sync or diagnostics

Current product strategy reduces risk by keeping data local and avoiding remote collection in the MVP.

Engineering response:

- privacy by design/default
- no unnecessary collection
- no remote analytics in MVP
- export/delete functionality
- privacy policy in German and English
- explicit opt-in before future diagnostics/sync/wearables

## ePrivacy / cookies

Main relevance:

- cookies and tracking on a future website
- ad SDKs
- analytics SDKs
- WebViews

MVP response:

- no cookies in mobile app
- no ads/analytics in MVP
- static no-tracking landing page if needed

## AI Act

MVP relevance is low if the app only tracks, calculates, and uses deterministic analytics. Future risk increases if RepForge uses ML/LLM-based coaching, chatbots, automated health advice, or opaque personalization.

Product response:

- keep coach deterministic/rule-based at first
- explain why suggestions are shown
- use hedging
- avoid medical claims
- keep human agency and manual override

## Cyber Resilience Act

Commercial software and mobile applications may be relevant products with digital elements. Full applicability timelines are still relevant for planning.

Engineering response:

- security-by-design
- dependency governance
- vulnerability disclosure contact
- supported versions policy
- update policy
- SBOM/dependency inventory later
- no hardcoded secrets
- secure local storage

## Data Act

Low MVP relevance because RepForge is not a connected product manufacturer and does not run a cloud data service. Reassess when adding:

- wearable integration
- connected gym equipment
- cloud sync
- data export APIs
- third-party data sharing

## Consumer protection and app stores

Relevant once Premium exists:

- clear pricing
- trial terms
- renewal behavior
- cancellation path
- restore purchases
- no misleading claims
- no hidden paywall around promised free functions

## Medical device law

Avoid positioning RepForge as medical software. Do not claim diagnosis, treatment, injury prevention, rehabilitation, or medical decision-making. Keep the app as training tracking, analytics, and educational guidance.
