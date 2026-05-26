# Localization and Internationalization

## Decision

Localization is part of the foundation, not a late feature.

The app must start with the smartphone/system locale when possible. If the locale is not supported, the app falls back to English.

## Initial locales

Start with:

- `en` — canonical fallback, source of truth for localization keys.
- `de` — early supported language for the initial German-speaking product context.

English must remain complete before any release. German may be complete for MVP, but the build should fail if required keys are missing.

## Flutter approach

Use Flutter's official localization tooling:

- `flutter_localizations`
- `intl`
- ARB files
- `l10n.yaml`
- generated `AppLocalizations`

Recommended layout:

```text
lib/l10n/
  app_en.arb
  app_de.arb
l10n.yaml
```

## Fallback behavior

`MaterialApp` should use generated localization delegates and supported locales. Put English first in `supportedLocales` or configure preferred supported locales so English remains the fallback when no exact or language match exists.

The user may later override language in settings. The initial MVP can rely on system locale only, but architecture should allow a persisted `LocalePreference` later.

## Rules for Codex

- No hard-coded user-facing strings in widgets after the localization slice.
- Add localization keys when adding UI.
- Do not localize domain identifiers, database enum values, or catalog IDs.
- Localize official exercise names through catalog metadata, not through UI ARB files.
- Tests should verify English fallback and at least one German text path.

## Codex read-first files for localization work

- `AGENTS.md`
- `docs/00-project/product_requirements.md`
- `docs/02-architecture/localization_i18n.md`
- `docs/03-design-ux/design_system.md`
- `docs/05-codex/codex_workflow.md`
- relevant slice file
