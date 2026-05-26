# App Store and Google Play Compliance Checklist

## Before MVP beta

- App name selected: RepForge.
- Trademark and store availability checked.
- Privacy policy available in English and German.
- Safety disclaimer available in English and German.
- App uses supported locales and English fallback.
- No hidden cloud data transfer.
- No ad SDK if app declares no ads.
- No analytics SDK if app declares no analytics.
- Open-source licenses visible in app.
- User can delete local data.
- User can export local data before production release.

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

## Screenshots and claims

- Do not overclaim results.
- Use hedging in coaching copy.
- Avoid medical-device language.
- Do not imply guaranteed hypertrophy, injury prevention, diagnosis, or treatment.
