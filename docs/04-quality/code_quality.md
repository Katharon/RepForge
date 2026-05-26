# Code Quality

## Static analysis

Use `flutter_lints` initially. Consider stricter lints later if they do not slow down progress too much.

## Formatting

Use Dart format. Do not fight the formatter.

## SOLID interpretation

- Single Responsibility: one class has one reason to change.
- Open/Closed: use interfaces at real boundaries, not everywhere.
- Liskov: implementations must obey repository/service contracts.
- Interface Segregation: split broad service contracts.
- Dependency Inversion: use cases depend on repository abstractions, not database implementations.

## Clean Code rules

- Clear names over comments.
- Keep widgets small but not fragmented into meaningless files.
- Avoid magic numbers; use design tokens and constants.
- Avoid nullable fields unless the domain allows absence.
- Prefer explicit failure types over swallowed exceptions.
- Do not duplicate formulas in UI and domain.

## Review checklist

- Is this in the right layer?
- Is the behavior tested?
- Are names domain-accurate?
- Does this introduce premature abstraction?
- Does it preserve local-first behavior?
- Does it leak personal data?
