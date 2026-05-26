# Business Model and Zero-Recurring-Cost Strategy

## Goal

RepForge should be built to maximize product value and profit potential while keeping developer-controlled recurring costs as close to zero as possible.

## Accepted unavoidable costs

These costs may be unavoidable for public distribution and monetization:

- Apple Developer Program yearly fee.
- Google Play Console developer registration fee.
- Store commissions / service fees on paid subscriptions or in-app purchases.
- Optional design/marketing costs if deliberately chosen later.

## Costs to avoid in the baseline

Avoid:

- paid cloud databases,
- paid backend hosting,
- paid sync infrastructure,
- paid analytics platforms,
- paid remote-config services,
- paid search/indexing services,
- paid push-notification infrastructure beyond what the OS/store ecosystem already provides,
- paid subscription management services such as RevenueCat unless a future cost-benefit decision explicitly approves them.

## Product strategy

Use a free tier that is genuinely useful:

Free:

- workout tracking,
- workout groups,
- custom exercises,
- official base exercise catalog,
- local history,
- useful base analytics,
- export/import local backup.

Premium:

- coach,
- guidance,
- next-exercise recommendations,
- adaptive alternatives,
- muscle-balance insights,
- recovery/readiness guidance,
- quick sessions,
- advanced reports,
- wearable-derived interpretation.

Rationale: free users should build habit and data value. Premium should feel like an intelligent layer on top, not like the app is holding basic user data hostage.

## Ads decision

Ads are not part of MVP.

Reasons:

- Gym logging is a focused, interruption-sensitive flow.
- Ads can reduce trust in a health/fitness product.
- Ads usually require meaningful scale to matter financially.
- Ads add SDK complexity and privacy/compliance work.
- A clean free tier can improve retention and later premium conversion.

Future reconsideration criteria:

- large free user base,
- low premium conversion,
- clear evidence ads would outperform premium conversion,
- ad placement can avoid core logging flows,
- privacy/compliance burden is acceptable.

If ads are ever added, use an interface/adapter boundary and keep ad logic out of domain/application code.

## ASO / SEO strategy

For native apps, App Store Optimization (ASO) matters more than classic website SEO.

ASO assets to plan from the beginning:

- app name: RepForge,
- subtitle / short description,
- English and German descriptions,
- keywords and search terms,
- localized screenshots,
- preview video later,
- icon that communicates strength/progression,
- positive review prompts at appropriate moments,
- clear premium value proposition.

SEO can support the app through:

- a static landing page,
- localized product pages,
- changelog pages,
- blog posts about workout tracking/progression,
- screenshots and structured metadata.

The website must be static/cheap-first: GitHub Pages, Cloudflare Pages free tier, or similar. No mandatory backend.
