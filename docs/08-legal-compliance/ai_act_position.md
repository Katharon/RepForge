# AI Act Position

## Current position

RepForge MVP should not include AI/ML/LLM functionality. It should use deterministic formulas and transparent rule-based logic for analytics.

## Why

The MVP value is tracking, groups, analytics, and fast logging. Adding AI too early increases complexity, compliance risk, cost, and testing burden.

## Future coach strategy

When Premium coach features are introduced, prefer this order:

1. Deterministic rules based on logged data.
2. Transparent recommendation reasons.
3. User-controlled settings and override.
4. Local-only execution where feasible.
5. No health diagnosis or medical claims.
6. Only later evaluate ML/LLM features as a separate compliance spike.

## Explainability requirement

Every recommendation should answer:

- What data was used?
- Which rule or model produced this suggestion?
- What uncertainty exists?
- What can the user change manually?

Example:

```text
This suggestion is based on your logged push volume over the last 7 days and the equipment you marked as available. Your triceps volume appears lower than your chest volume, so a triceps-focused accessory could be useful.
```

## Forbidden product direction without legal review

Do not market RepForge as:

- medical AI
- injury diagnosis
- rehabilitation planning
- therapy recommendation
- automatic health-risk classifier
- replacement for a doctor, physiotherapist, or qualified trainer
