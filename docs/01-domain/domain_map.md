# Domain Map

## Core domain

The core domain is personal strength-training tracking and progress interpretation.

```text
UserProfile
 ├─ goals/focus
 ├─ training availability
 ├─ equipment access
 ├─ recovery preferences
 └─ privacy/settings

ExerciseCatalog
 ├─ OfficialExerciseDefinition[]     # bundled, versioned, immutable source data
 ├─ CustomExercise[]                 # user-created local exercises
 ├─ UserExerciseOverride[]           # favorites, hidden flags, rest overrides, notes
 └─ MuscleActivationProfile[]

WorkoutGroup
 ├─ name/order/color/icon
 ├─ focus/mode
 └─ GroupExercise[]

WorkoutSession
 ├─ selected WorkoutGroup
 ├─ startedAt/endedAt
 ├─ readiness snapshot
 └─ WorkoutSet[]

WorkoutSet
 ├─ exerciseRef
 ├─ repetitions
 ├─ load
 ├─ performedAt
 ├─ label/comment
 └─ optional RPE/RIR/readiness metadata

Analytics
 ├─ ExerciseMetrics
 ├─ SessionMetrics
 ├─ MuscleLoadMetrics
 ├─ MuscleActivationProfile
 ├─ PeriodComparison
 ├─ ImbalanceSignal
 └─ EstimatedOneRepMax

RecommendationEngine
 ├─ UserFocusPolicy
 ├─ EquipmentFilter
 ├─ MuscleBalancePolicy
 ├─ RecoveryReadinessPolicy
 ├─ ProgressiveOverloadPolicy
 └─ QuickSessionPolicy

RestTimer
 ├─ duration
 ├─ startedAt
 ├─ dueAt
 ├─ status
 └─ notification request
```

## Bounded contexts

### Training Log

Owns workout groups, exercise references, sessions, sets, labels, comments, and logging rules.

### Exercise Catalog

Owns official bundled exercise definitions, custom exercises, catalog versions, muscle activation metadata, and user overrides. It does not depend on a cloud database.

### Analytics

Reads training-log data and calculates metrics. It must not mutate sets.

Slice 45 adds the pure-Dart muscle activation/load-estimate primitives here:
activation profiles reference existing exercise source/id pairs, estimated
per-muscle load is derived from logged set volume, and unknown activation data is
reported explicitly instead of being stored as zero load.

Slice 46 adds the pure-Dart muscle balance detector here: focus-aware target
ranges, confidence-aware balance assessments, movement-pattern coverage gaps,
and explainable signal evidence derived from muscle-load estimates.

### Training Intelligence

Owns recommendation rules, focus profiles, imbalance detection, readiness signals, progressive overload suggestions, quick session generation, and deload hints.

Slice 46 provides the imbalance-detection vocabulary consumed by this context in
future slices, but it does not yet generate recommendation plans or UI guidance.

Slice 48 adds the first pure-Dart recommendation boundary under
`lib/src/features/recommendations/`. It computes advisory recommendation plans
from explicit local inputs: candidate exercise metadata, profile/focus,
equipment inventory and load constraints, muscle-balance assessment, readiness
read model, substitutions, and exclusions. Plans are deterministic read models
with reason codes, alternatives, and constraints; they are not persisted and do
not block workout logging.

### Timer & Notification

Coordinates rest timers and local notifications. It references sets/exercises but must not own training-log persistence.

### Preferences & Profile

Owns units, theme, default rest time, training goals, sex/gender selection, training frequency, equipment availability, time constraints, and coaching strictness.

### Identity & Entitlements

Post-MVP. Owns authentication, purchase state, entitlements, and premium feature gates.

### Sync & Backup

Post-MVP. Owns export/import, optional sync, conflict resolution, and remote storage. It must not be required for exercise catalog updates.

## Aggregate candidates

### UserProfile

Stores goal, focus, training frequency, available equipment, session duration, recovery sensitivity, and personalization settings.

### OfficialExerciseDefinition

Represents a bundled exercise definition from the app catalog. It is identified by a stable catalog ID and version. User edits are stored as overrides, not mutations.

### CustomExercise

A user-created local exercise. It may have manually defined muscle activation data or a simple primary muscle group.

### WorkoutGroup

A user-owned group/training day containing ordered exercise references.

### WorkoutSession

A performed workout session with readiness snapshot and performed sets.

### WorkoutSet

A logged set. It can be edited independently, but must reference a valid official or custom exercise.

### RecommendationPlan

A generated read model, not usually persisted as a canonical aggregate. It can be recreated from profile, groups, catalog, recent sets, readiness, and analytics.

## Domain invariants

- A workout set must reference an existing official or custom exercise at creation time.
- A workout set keeps a stable exercise reference and display-name snapshot so history remains readable after catalog or custom-exercise changes.
- Repetitions must be a positive integer.
- Weight/load must be non-negative.
- Performed timestamp must be valid and timezone-aware at storage boundaries.
- A deleted exercise with historical sets should be archived, not physically deleted by default.
- Official catalog imports must never overwrite user-created exercises or user overrides.
- Analytics must handle empty periods without division-by-zero.
- 1RM estimates must be labeled as estimates.
- Muscle activation values are estimates, not measurements.
- Recommendations must be explainable by visible signals: focus, equipment, time, fatigue, recovery, and muscle balance.
- Rest timers are user assistance, not canonical training data.

## v5 domain additions

### Localization boundary

Localization is not a domain concern for calculations, but names/descriptions shown to users must pass through localization-aware presentation or catalog metadata. Domain identifiers remain stable and non-localized.

### Equipment inventory boundary

`EquipmentInventory` becomes a first-class domain concept because future recommendation use cases need to know whether a suggested exercise/load is feasible.

Related concepts:

- `EquipmentInventoryItem`
- `EquipmentKind`
- `LoadConstraint`
- `ExerciseEquipmentRequirement`
- `MaxFeasibleLoad`

### Monetization boundary

Free tracking and analytics must remain independent of entitlement state. Premium gates may wrap coach/recommendation/readiness/wearable use cases later, but core data ownership and export must not be paywalled.
