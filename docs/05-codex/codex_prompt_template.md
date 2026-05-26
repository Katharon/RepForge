# Codex Prompt Template

Use this template when generating a Codex implementation prompt.

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. <slice-specific-doc-1>
3. <slice-specific-doc-2>
4. <slice-specific-doc-3>

Current task:
Implement Slice <N>: <title>.

Goal:
<one paragraph>

Non-goals:
- <explicit exclusions>

Architecture rules:
- Keep domain pure Dart.
- Keep presentation thin.
- Use constructor injection.
- Do not introduce unrelated packages or features.
- Update docs if implementation reveals changed assumptions.

TDD requirements:
1. Add/update tests first for <specific behavior>.
2. Confirm they fail for the expected reason if practical.
3. Implement the smallest passing solution.

Implementation requirements:
- <specific files/modules/features>

Acceptance criteria:
- <list>

Validation commands:
```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

Documentation updates:
- Update `docs/05-codex/slice_status.md`.
- Update any docs made stale by this slice.

Commit:
Create one git commit with this message:
`<type(scope): message>`

When finished, report:
- Summary
- Tests
- Validation results
- Files changed
- Commit hash
- Follow-ups
```
