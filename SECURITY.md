# Security Policy

## Scope

The app handles training and body-performance data. Treat this as personal health-adjacent data even if it is not medical diagnosis data.

## Security principles

- Local-first by default.
- No unnecessary cloud upload.
- No third-party analytics without explicit opt-in.
- Store secrets, tokens, and encryption keys in platform secure storage.
- Never trust local premium flags as the authority for paid entitlement.
- Keep notification payloads minimal and non-sensitive.
- Avoid hardcoded API keys except public Firebase configuration values that are expected in mobile apps.
- Validate all user inputs and imported files.

## Reporting a vulnerability

This repository is currently private/development-stage. Report issues directly to the maintainer.

## v8 security baseline

RepForge treats cybersecurity as part of product quality. The MVP should avoid unnecessary network dependencies, remote SDKs, hardcoded secrets, ad identifiers, and sensitive logging. Security work should prioritize dependency governance, migration safety, catalog validation, local data protection, export/import validation, and a clear vulnerability contact path.
