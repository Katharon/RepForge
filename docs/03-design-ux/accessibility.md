# Accessibility

## Requirements

- Minimum touch target size: 48x48 logical pixels where practical.
- Text must scale with system font size without clipping critical content.
- Color must not be the only carrier of meaning.
- Metric changes need labels/icons/text, not only green/red colors.
- Charts need accessible summaries.
- Important buttons need semantic labels.

## Workout context

Users may interact while fatigued, sweaty, or in bright/dark gym lighting. Prioritize:

- Large hit targets.
- Clear contrast.
- Minimal typing.
- Previous-set shortcuts.
- Predictable navigation.

## Tests

Add accessibility-oriented widget tests where possible:

- Semantics labels for add/edit/delete buttons.
- Text scaling smoke tests.
- Empty/error state readability.
