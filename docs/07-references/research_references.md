# Research References

This file collects external references that should be consulted when implementing or revising architecture and training-science documents.

## Flutter architecture and testing

- Flutter docs — App architecture guide: https://docs.flutter.dev/app-architecture/guide
- Flutter docs — Testing overview: https://docs.flutter.dev/testing/overview

## Flutter packages

- flutter_bloc package: https://pub.dev/packages/flutter_bloc
- bloc_test package: https://pub.dev/packages/bloc_test
- drift package: https://pub.dev/packages/drift
- flutter_local_notifications package: https://pub.dev/packages/flutter_local_notifications
- in_app_purchase package: https://pub.dev/packages/in_app_purchase

## Firebase / remote push

- Firebase Cloud Messaging for Flutter: https://firebase.google.com/docs/cloud-messaging/flutter/client

Project rule: FCM is not used for local rest timers. It is only a later boundary for true remote push features.

## Training science topics to validate before implementation

- Progressive overload.
- Training volume and frequency.
- Deloading and fatigue management.
- Muscle activation / exercise classification.
- DOMS and recovery.
- Hypertrophy vs strength-oriented progression.

Training-science implementation must stay conservative and explainable. The app should present estimates and coaching signals, not medical facts.

## Catalog distribution

No paid cloud database is required for the official exercise catalog. Use bundled JSON assets, semantic catalog versions, fixture tests, and optional signed static JSON only if dynamic content updates become necessary later.

## v5 references to verify during implementation

- Flutter official internationalization documentation for `flutter_localizations`, ARB files, `supportedLocales`, and locale fallback behavior.
- Apple App Store auto-renewable subscription guidance for free trials, price disclosure, restore purchases, Terms of Use, and Privacy Policy.
- Google Play Billing subscription guidance for subscription entitlements, base plans/offers, free trials, and restoration behavior.

## v8 regulatory references

- GDPR / DSGVO official regulation text: https://eur-lex.europa.eu/eli/reg/2016/679/oj
- GDPR Article 5 principles: https://gdpr-info.eu/art-5-gdpr/
- GDPR Article 9 special categories: https://gdpr-info.eu/art-9-gdpr/
- GDPR Article 25 data protection by design and by default: https://gdpr-info.eu/art-25-gdpr/
- EU AI Act overview: https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai
- EU Data Act overview: https://digital-strategy.ec.europa.eu/en/policies/data-act
- EU Cyber Resilience Act overview: https://digital-strategy.ec.europa.eu/en/policies/cyber-resilience-act
