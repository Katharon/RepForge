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

## App icon and launch surface

- Product name: `RepForge`.
- Launcher icon source: `assets/icon/repforge_icon.png`.
- Launcher icon background: `#0B0F14`.
- Native launch screens should use the same `#0B0F14` background so cold start
  does not flash white before the dark Flutter theme draws.
- Keep app icon and splash assets brand-only. Do not add medical, guaranteed
  progress, cloud, or Premium claims to launch surfaces.

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

## Implementation

Slice 04 implements the dark-first foundation in `lib/src/core/theme` with
typed color, spacing, radius, metric-color, typography, and Material 3 theme
helpers. The app currently forces the dark RepForge theme until a later settings
slice introduces user-selectable theme behavior.

Slice 27 adds `AppResponsiveSliverList` as the default small helper for current
scrolling screens that need mobile padding plus a tablet/wide max content
width. It also standardizes 48px minimum touch targets for filled, text, and
icon buttons through the shared theme.

## v5 visual direction

The visual direction is **Setgraph-inspired, not Setgraph-copied**.

Keep:

- dark-first training cockpit feel,
- high contrast,
- fast actions,
- compact but readable data cards,
- color-coded metrics.

Slice 47 adds a compact Today `Readiness estimate` card. It should stay in the
same metric-card family as the existing Today dashboard, use localized careful
wording, expose a semantic summary for assistive technology, and avoid
medical, injury-prevention, or mandatory-rest language. Do not introduce body
heatmaps or region graphics for this slice.

Change:

- create original component shapes and spacing,
- avoid copying old screen layouts one-to-one,
- use modern Material 3 foundations with a custom expressive layer,
- make analytics easier to understand than the old app.
