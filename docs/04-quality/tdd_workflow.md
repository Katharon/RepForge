# TDD Workflow

## Red-Green-Refactor

1. Write a failing test for the required behavior.
2. Run the test and confirm it fails for the expected reason.
3. Implement the smallest code that passes.
4. Refactor while keeping tests green.
5. Update docs if behavior or architecture changed.

## When strict TDD is mandatory

- Domain entities/value objects.
- Analytics formulas.
- Use cases.
- Repository behavior.
- Timer policy.
- Entitlement rules.
- Import/export validation.

## When exploratory implementation is acceptable

- Visual styling spikes.
- Animation tuning.
- Platform setup that cannot easily be tested first.

Even then, add tests before considering the slice done.

## Codex instruction

Every slice prompt must tell Codex which tests to write first and which commands to run.
