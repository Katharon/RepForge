# Slice 00 — Repository governance and docs baseline

## Goal

Establish the repository documentation, governance files, issue/PR templates, and slice workflow before any Flutter code.

## Read first

1. `AGENTS.md`
2. `README.md`
3. `docs/00-project/project_memory_brief.md`
4. `docs/00-project/version_notes_v9_data_evolution.md`
5. `docs/00-project/business_model_zero_cost.md`
6. `docs/02-architecture/architecture_overview.md`
7. `docs/02-architecture/data_versioning_backward_compatibility.md`
8. `docs/05-codex/codex_workflow.md`
9. `docs/05-codex/commit_conventions.md`
10. `docs/06-slices/index.md`
11. `docs/06-slices/slice_00_repository_governance_and_docs_baseline.md`

## Current assumptions

- Work from the current repository state.
- Keep changes limited to this slice.
- Keep documentation synchronized with implementation.
- Prefer the smallest production-quality increment over a broad prototype.
- RepForge is the selected app name, subject to later trademark and store checks.
- The MVP is local-first tracking, workout groups, custom exercises, a small official catalog, and analytics.

## Non-goals

- Do not create Flutter source code yet unless the repository already exists and needs doc references.
- Do not create `pubspec.yaml`, Dart source files, Drift code, BLoC code, routing, localization implementation, payments, notifications, catalog import, analytics, or tests yet.
- Do not add Firebase, Supabase, Appwrite, Firestore, RevenueCat, remote analytics, ads, a cloud database, or any paid service.

## TDD requirements

No code tests yet. Treat documentation consistency checks as the quality gate. Validate markdown links where tooling exists.

If strict TDD is impractical because this is a repository/bootstrap slice, explain why and add the earliest possible smoke test.

## Implementation requirements

- Follow `AGENTS.md`.
- Ensure root governance files exist and reflect the v9 decisions.
- Ensure GitHub PR and issue templates exist.
- Ensure docs point Codex to the source-of-truth files.
- Keep future Codex instructions concise: read only slice-relevant files, update docs and slice status, validate before committing, and use Conventional Commits.
- Update affected docs if implementation decisions differ from the initial plan.

## Acceptance criteria

- Slice goal is implemented.
- Required governance files exist.
- Required GitHub templates exist.
- Documentation reflects RepForge, local-first MVP, German/English MVP localization, free/Premium boundaries, no-ads/no-cloud/no-running-cost MVP, versioned JSON catalog assets, and hedged recommendation wording.
- Documentation consistency checks pass.
- `docs/05-codex/slice_status.md` and `docs/06-slices/index.md` are updated.
- No unrelated future feature is introduced.

## Validation commands

```bash
git status --short
find . -maxdepth 3 -type f | sort
test -f README.md
test -f AGENTS.md
test -f CHANGELOG.md
test -f LICENSE
test -f CONTRIBUTING.md
test -f SECURITY.md
test -f CODE_OF_CONDUCT.md
test -f .github/pull_request_template.md
test -f .github/ISSUE_TEMPLATE/bug_report.md
test -f .github/ISSUE_TEMPLATE/feature_request.md
test -f .github/ISSUE_TEMPLATE/slice_task.md
rg "RepForge" README.md AGENTS.md docs/00-project docs/05-codex docs/06-slices
rg "cloud database|Firebase|ads|RevenueCat|Supabase|Appwrite|Firestore" README.md AGENTS.md docs || true
```

If available:

```bash
markdownlint "**/*.md"
```

## Documentation updates

Update these if changed by implementation:

- `docs/05-codex/slice_status.md`
- `docs/06-slices/index.md`
- `CHANGELOG.md`
- Any governance or source-of-truth document made stale by this slice

## Implementation note

Slice 00 normalized repository governance files and GitHub templates, repaired stale slice instructions, and aligned root/Codex documentation with the v9 RepForge decisions. No Flutter application code, package manifest, dependencies, or external services were introduced.

## Commit message

```text
docs: establish repository governance baseline
```

## Ready-to-use Codex prompt

```text
You are working in the `RepForge` repository.

Read first, in this order:
1. AGENTS.md
2. README.md
3. docs/00-project/project_memory_brief.md
4. docs/00-project/version_notes_v9_data_evolution.md
5. docs/00-project/business_model_zero_cost.md
6. docs/02-architecture/architecture_overview.md
7. docs/02-architecture/data_versioning_backward_compatibility.md
8. docs/05-codex/codex_workflow.md
9. docs/05-codex/commit_conventions.md
10. docs/06-slices/index.md
11. docs/06-slices/slice_00_repository_governance_and_docs_baseline.md

Implement Slice 00: Repository governance and docs baseline.

Goal:
Establish the repository documentation, governance files, issue/PR templates, and slice workflow before any Flutter code.

Non-goals:
- Do not create Flutter source code, `pubspec.yaml`, Dart source files, or package dependencies.
- Do not add external services.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep the MVP local-first and near-zero-cost.
- Do not add cloud databases, Firebase, ads, remote analytics, paid services, backend dependencies, or unrelated features.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
No code tests yet. Use documentation consistency checks as the quality gate.

Implementation requirements:
- Make the smallest complete production-quality change for this slice.
- Keep naming aligned with the ubiquitous language and docs.
- Ensure governance files and GitHub templates exist.
- Ensure root docs and Codex docs point to the source-of-truth files.

Validation commands:
Run the validation commands listed in this slice.

Documentation:
- Update docs/05-codex/slice_status.md.
- Update any affected docs if implementation reveals a stale or wrong assumption.

Commit:
Create one git commit with this exact message:
`docs: establish repository governance baseline`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
