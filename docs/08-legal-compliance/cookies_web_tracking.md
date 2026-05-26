# Cookies, Web Tracking, and Landing Page Policy

## Mobile MVP

The mobile app should not use cookies. Cookies become relevant only if RepForge includes:

- a WebView
- an embedded web checkout
- a marketing/landing website
- web analytics
- advertising/tracking SDKs

## App default

- No ad SDK in MVP.
- No third-party analytics in MVP.
- No WebView in MVP unless required for legal pages.
- Legal pages may be shown as static in-app text or external links.

## Future landing page

A simple static website can be useful for ASO/SEO support, press, documentation, and app-store trust.

Preferred landing page policy:

- static hosting only
- no cookies by default
- no tracking pixels by default
- no behavioral ads
- no newsletter unless explicitly added later
- privacy policy and imprint/legal notice if required

## If web analytics are added later

- Prefer privacy-preserving, cookie-less analytics.
- Document provider, purpose, retention, and legal basis.
- Add cookie/banner mechanism only if necessary.
- Update privacy policy before deployment.
