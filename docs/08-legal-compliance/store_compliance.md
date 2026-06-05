# App Store and Google Play Compliance Checklist

## Before MVP beta

- App name selected: RepForge.
- Trademark and store availability checked by the release owner.
- Privacy policy available in English and German and reviewed against the exact
  shipped binary.
- Safety disclaimer available in English and German and reviewed against current
  training guidance behavior.
- Store listing draft available in English and German.
- App uses supported locales and English fallback.
- No hidden cloud data transfer.
- No ad SDK if app declares no ads.
- No analytics SDK if app declares no analytics.
- Open-source licenses visible in app.
- User can delete local data.
- User can export local data before production release.
- Support contact and deletion request path are available before public release.
- Store screenshots show only shipped behavior and avoid unimplemented sync,
  social, wearable, health, Firebase, or remote push claims.

## Before Premium release

- App-store products configured correctly.
- Free vs Premium functionality described clearly.
- Restore Purchases implemented.
- Subscription/trial wording reviewed.
- Price and billing period shown before purchase.
- Cancellation path explained through app store mechanisms.
- Entitlements implemented through a domain abstraction.
- No local-only `isPremium` flag as sole source of truth.

## Privacy/data safety declarations

Declarations must match the app exactly:

- If no data is collected by the developer, declare accordingly.
- If crash reporting is later enabled, update declarations.
- If analytics is later enabled, update declarations.
- If sync is later enabled, update declarations.
- If health/wearable data is imported or transmitted, update declarations.
- If social sharing, remote push token registration, support upload, Firebase,
  Firestore, backend services, or cloud diagnostics are later enabled, update
  declarations before release.

## Screenshots and claims

- Do not overclaim results.
- Use hedging in coaching copy.
- Avoid medical-device language.
- Do not imply guaranteed hypertrophy, injury prevention, diagnosis, or treatment.
- Do not imply exact calorie burn, exact muscle fatigue measurement, mandatory
  training/rest decisions, public social comparison, or active cloud sync unless
  those claims match reviewed shipped behavior.
