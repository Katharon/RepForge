# Compliance Release Checklist

## Every release

- [ ] `CHANGELOG.md` updated.
- [ ] Slice status updated.
- [ ] Migration tests passing.
- [ ] Catalog schema validation passing.
- [ ] English and German localization complete for changed screens.
- [ ] No sensitive data in logs.
- [ ] No unintended network dependency added.
- [ ] No paid service dependency added without explicit decision.
- [ ] Privacy policy checked against actual data flows.
- [ ] App-store data declarations checked against actual SDKs.

## Before first public release

- [ ] German privacy policy reviewed.
- [ ] English privacy policy reviewed.
- [ ] Terms/safety disclaimer reviewed.
- [ ] Open-source license notices available in app.
- [ ] Security contact available.
- [ ] User can delete local data.
- [ ] User can export local data.
- [ ] No cloud/analytics/ads SDK accidentally included.
- [ ] Store screenshots do not make medical or guaranteed-result claims.

## Before Premium release

- [ ] Entitlement model tested.
- [ ] Restore Purchases tested on Android and iOS.
- [ ] Trial/subscription copy reviewed.
- [ ] Terms/privacy links reachable from paywall.
- [ ] Free tier still works without purchase.

## Before coach/recommendation release

- [ ] Recommendation copy uses hedging.
- [ ] User can override suggestions.
- [ ] Recommendation reasons are visible.
- [ ] No diagnosis/treatment claims.
- [ ] Safety disclaimer visible in onboarding/settings.
