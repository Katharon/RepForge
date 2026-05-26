# Cyber Resilience Act Position

## Why this matters

RepForge is commercial software intended for app-store distribution. Even without a backend, software can be a product with digital elements and should be engineered with cybersecurity governance in mind.

## Product posture

RepForge should be designed as if security-by-design and security maintenance obligations will matter.

## Baseline controls

- Maintain `SECURITY.md` with vulnerability contact and supported versions.
- Keep dependency inventory current.
- Run dependency audit commands in CI where available.
- Avoid unused packages and SDKs.
- Avoid hardcoded secrets.
- Use platform secure storage only when truly needed.
- Keep local database migrations tested.
- Provide app updates for security issues.
- Document end-of-support behavior for old versions before scale.
- Validate imported files and catalog assets.
- Do not execute remote code or untrusted scripts.

## Future enhancements

- Software Bill of Materials (SBOM) generation.
- Signed catalog bundles for external static patch channel.
- Security regression tests for import/export.
- Threat model review before sync, social, or wearable integrations.
- Incident response playbook.

## MVP non-goals

- No enterprise compliance certification.
- No backend security operations center.
- No third-party security platform dependency.
- No paid vulnerability scanning service unless revenue justifies it.
