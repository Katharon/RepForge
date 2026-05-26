# Ubiquitous Language

## Training organization

- **Workout Group**: User-defined group/training day such as Push Day, Pull Day, Leg Day, Upper, Lower, or Full Body.
- **Group Exercise**: An exercise assigned to a Workout Group, with optional order and group-specific notes.
- **Training Session**: A performed workout instance.
- **Set Entry / Workout Set**: One logged set with weight, repetitions, timestamp, and optional metadata.

## Exercise catalog

- **Official Exercise**: Curated exercise definition bundled with the app.
- **Custom Exercise**: User-created local exercise.
- **Exercise Reference**: A reference that points either to an Official Exercise or a Custom Exercise.
- **Catalog Version**: Version of bundled exercise data shipped with an app release/patch.
- **User Override**: User-local customization for an official exercise, such as favorite, hidden, note, default rest duration, or group assignment.

## Analytics

- **Volume**: `weight * repetitions`, usually summed across sets.
- **kg/rep**: Average load per repetition: total volume divided by total repetitions.
- **Estimated 1RM**: Formula-based estimate of one-repetition maximum.
- **Previous Comparable Session**: The most recent prior session for the same exercise or workout group, depending on context.
- **Time-Window Delta**: Change compared with a selected period such as previous week, month, or 3-month trend.
- **Muscle Load**: Estimated training stimulus per muscle, derived from sets, load, reps, and activation weights.
- **Imbalance Signal**: A warning that a muscle group or movement pattern is underrepresented relative to the user's focus profile.

## Training intelligence

- **Focus Profile**: User-selected training emphasis such as balanced, upper-body focus, lower-body/glute focus, arms/chest focus, time-efficient, or custom.
- **Readiness**: Estimated ability to train productively today based on soreness, time since stimulus, perceived exertion, and recent performance.
- **DOMS/Soreness**: User-reported muscle soreness after training.
- **Progressive Overload**: Gradual increase in stimulus via load, reps, sets, density, or quality.
- **Backoff Set**: A lower-load set used to preserve volume or technique when top-set strength is down.
- **Quick Session**: A time-constrained generated workout emphasizing high-value exercises and minimal setup time.
- **Deload**: Planned or suggested reduction in volume/intensity to recover from accumulated fatigue.

## Infrastructure

- **Local Database**: Drift/SQLite storage on the device.
- **Cloud Database**: Hosted mutable database. Not used for the official exercise catalog.
- **Bundled Catalog Asset**: JSON file shipped inside the app and imported locally.
