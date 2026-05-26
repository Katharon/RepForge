# Design System

## Direction

A custom Material 3-based dark design system with athletic dashboard styling.

## Visual identity

- Background: near-black.
- Surfaces: charcoal with subtle elevation.
- Primary accent: energetic green.
- Secondary accent: orange/yellow for weight/load.
- Purple for 1RM.
- Blue/pink/green/orange rails for analytics metrics.
- Rounded rectangles, not sharp enterprise cards.
- Strong numeric typography.

## Design tokens

### Color tokens

```text
background.primary
background.secondary
surface.card
surface.cardElevated
border.subtle
text.primary
text.secondary
accent.primaryGreen
accent.weightOrange
accent.oneRepMaxPurple
metric.setsPink
metric.repetitionsGreen
metric.volumeBlue
metric.kgPerRepOrange
warning
error
success
```

### Spacing tokens

```text
space.xs = 4
space.sm = 8
space.md = 12
space.lg = 16
space.xl = 24
space.2xl = 32
```

### Radius tokens

```text
radius.sm = 8
radius.md = 12
radius.lg = 20
radius.xl = 28
```

## Typography

- Use large tabular numerals for reps, weight, timer, and metrics.
- Keep unit labels smaller but aligned.
- Avoid overly thin font weights for workout use.

## Material 3 usage

Use Material 3 components where they serve usability, but theme them heavily. The app should not look like an unmodified Material sample.

## Theming

Support:

- Dark theme first.
- Light theme later if required.
- Match device setting.
- High-contrast mode consideration.

## v5 visual direction

The visual direction is **Setgraph-inspired, not Setgraph-copied**.

Keep:

- dark-first training cockpit feel,
- high contrast,
- fast actions,
- compact but readable data cards,
- color-coded metrics.

Change:

- create original component shapes and spacing,
- avoid copying old screen layouts one-to-one,
- use modern Material 3 foundations with a custom expressive layer,
- make analytics easier to understand than the old app.
