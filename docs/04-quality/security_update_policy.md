# Security Update Policy

## Goal

RepForge should be maintainable as a commercial app without expensive infrastructure.

## Supported versions

Before production release, document which app versions receive security fixes. Until then, the latest public version is the supported version.

## Dependency management

- Keep Flutter SDK and packages reasonably current.
- Avoid unnecessary dependencies.
- Review package health before adding new dependencies.
- Prefer official, well-maintained packages.
- Run dependency audits/checks in CI where available.

## Vulnerability handling

- Maintain `SECURITY.md`.
- Provide a contact address for vulnerability reports.
- Triage reports by severity.
- Release security fixes through app-store updates.
- Do not disclose sensitive exploit details before a fix is available.

## Catalog security

- Bundled catalog JSON is trusted app content.
- Future external static catalog patches must be signed or integrity-checked before import.
- Importer must validate schema, IDs, localized names, equipment references, and muscle activation ranges.

## No secrets policy

- No API keys for paid services in MVP.
- No hardcoded secrets.
- No hidden backend endpoints.
- No debug credentials in repository.
