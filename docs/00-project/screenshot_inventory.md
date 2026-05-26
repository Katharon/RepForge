# Screenshot Inventory

This document records observed UI and behavior from the old app screenshots. It is an inferred specification, not a pixel-perfect clone mandate.

## Observed files

Screenshots in the current analysis set include:

- `Screenshot_20260526_201133_Setgraph.jpg`
- `Screenshot_20260526_201136_Setgraph.jpg`
- `Screenshot_20260526_201139_Setgraph.jpg`
- `Screenshot_20260526_201142_Setgraph.jpg`
- `Screenshot_20260526_201145_Setgraph.jpg`
- `Screenshot_20260526_201153_Setgraph.jpg`
- `Screenshot_20260526_201159_Setgraph.jpg`
- `Screenshot_20260526_201202_Setgraph.jpg`
- `Screenshot_20260526_201204_Setgraph.jpg`
- `Screenshot_20260526_201208_Setgraph.jpg`
- `Screenshot_20260526_201221_Setgraph.jpg`
- `Screenshot_20260526_201224_Setgraph.jpg`
- `Screenshot_20260526_201230_Setgraph.jpg`
- `Screenshot_20260526_201255_Setgraph.jpg`
- `Screenshot_20260526_201258_Setgraph.jpg`
- `Screenshot_20260526_201305_Setgraph.jpg`
- `Screenshot_20260526_201312_Setgraph.jpg`
- `Screenshot_20260526_201314_Setgraph.jpg`
- `Screenshot_20260526_201324_Setgraph.jpg`
- `Screenshot_20260526_201332_Setgraph.jpg`
- `Screenshot_20260526_201334_Setgraph.jpg`
- `Screenshot_20260526_201353_Setgraph.jpg`
- `Screenshot_20260526_201359_Setgraph.jpg`
- `Screenshot_20260526_201408_Setgraph.jpg`
- `Screenshot_20260526_201425_Setgraph.jpg`
- `1000045930.jpg`
- `1000045932.jpg`
- `1000045934.jpg`
- `1000045940.jpg`
- `1000045942.jpg`

## Observed screens

### Today / dashboard

- Top horizontal date strip.
- Summary counts for exercises, sets, reps.
- Card list of exercises performed today.
- Bottom navigation with Sets and Today tabs.

### Workout/program list

- Program folders such as `Unterkörper`, `Oberkörper`, `Pull`, `Core`, `Push`, `Beine`.
- Counts next to each program.
- Add program button.
- Include/manage workouts screen with toggles or add buttons.

### New workout / training edit

- Program name field.
- Description field.
- List of exercises with selectable checkboxes.
- Warning banner about rest time/date/notification behavior.
- Save/done action.

### Exercise catalog

- Search field.
- Add Exercise and New buttons.
- List of exercise names with default rest times.
- Examples: Hip Thrusts, Beinpresse sitzend, Beinstrecker, Crunches Machine, Torso Machine, Adduktoren, Wadenheben sitzend.

### Exercise detail

- Header title, back action, overflow menu.
- Countdown capsule with cancel button and circular progress.
- `Next Set` timer.
- Analytics and 1RM quick links/cards.
- Today comparison card with vertical colored metric indicators.
- Set list grouped by date.
- Floating add button.
- Bottom navigation/date bar.

### Add/edit set

- Exercise selector/read-only exercise field.
- Repetitions field.
- Weight field in kg.
- Notes/comment field.
- Label selector, e.g. `None`, `Failure`.
- Date picker and time picker.
- Exact time label.
- Save and delete actions.

### Analytics

- Metric tab such as `Sets`.
- Time-range selector: D, W, 2W, M, 3M, 6M, ALL.
- Chart with selected point callout.
- 1RM chart/metric view.
- Comparison values against previous period.

### 1RM settings/view

- Formula selector with options such as Epley, Brzycki, Lander, O'Conor, Average.
- Toggle/switch for formula usage.
- Explanation that 1RM is an estimate and depends on formula.

### Settings

- Pro Membership.
- Account.
- Password.
- Units: metric/English.
- Workout reminders.
- Default rest time.
- Help & Feedback.
- Theme.
- Match Device.

### Notification

- Lock-screen notification: `Next Set due` with timestamp.
- Displays last set summary such as `10 rep 150 kg (Beinpresse sitzend)`.

## Design observations

- Dominant black background.
- Charcoal cards with rounded corners.
- Bright green primary accent.
- Orange/yellow weight text.
- Purple for 1RM.
- Blue, pink, green, orange metric rails.
- Large numeric typography for reps and weight.
- Compact card-based UI.

## Decisions for the rebuild

- Preserve workflow and information density.
- Do not clone the old UI exactly.
- Use a stronger, more coherent design system.
- Use clear domain terms in code even where the UI remains short.
- Treat screenshots as product evidence, not as architecture evidence.
