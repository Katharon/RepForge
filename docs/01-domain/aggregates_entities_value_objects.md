# Aggregates, Entities, and Value Objects

## Aggregates

### UserProfile

Fields:

- `UserProfileId`
- `displayName` optional
- `sexOrGender` optional enum: `male`, `female`, `other`, `preferNotToSay`
- `primaryGoal`: hypertrophy, strength, general fitness, maintenance, recomposition
- `focusProfile`: balanced, upperBodyFocus, lowerBodyGluteFocus, armsChestFocus, strengthBasics, timeEfficient, beginnerFoundation, custom
- `trainingDaysPerWeek`
- `typicalSessionDurationMinutes`
- `availableEquipment[]`
- `experienceLevel`
- `recoverySensitivity`
- `coachingStrictness`

Rule: Sex/gender may influence defaults and wording, but user choice and explicit focus override defaults.

### OfficialExerciseDefinition

Bundled app-catalog exercise.

Fields:

- `catalogId`
- `catalogVersionIntroduced`
- `canonicalName`
- `localizedNames`
- `aliases`
- `movementPatterns[]`
- `equipment[]`
- `primaryMuscles[]`
- `secondaryMuscles[]`
- `stabilizerMuscles[]`
- `activationProfile`
- `defaultRestDuration`
- `trackingMode`
- `difficulty`
- `contraindicationNotes` optional, non-medical wording only

Rule: Official definitions are immutable after import. New corrections create a new catalog version or migration rule.

Slice 11 implements the first small official catalog foundation with the
runtime domain name `OfficialExercise`. It includes stable catalog ID, catalog
version, English/German names, equipment tags, movement patterns, and
primary/secondary muscle groups. UI flows, custom exercises, aliases, user
overrides, rest defaults, tracking modes, and difficulty metadata remain later
slices.

### CustomExercise

User-created exercise.

Fields:

- `customExerciseId`
- `name`
- `aliases`
- `equipment[]`
- `primaryMuscles[]`
- `secondaryMuscles[]`
- `activationProfile` optional
- `defaultRestDuration`
- `trackingMode`
- `archivedAt`

### WorkoutGroup

User-created training group/day.

Fields:

- `workoutGroupId`
- `name`
- `description`
- `icon`
- `colorToken`
- `sortOrder`
- `groupFocus`
- `exerciseRefs[]`
- `archivedAt`

### WorkoutSession

Fields:

- `workoutSessionId`
- `workoutGroupId` optional
- `startedAt`
- `endedAt` optional
- `readinessSnapshot` optional
- `notes`

### WorkoutSet

Fields:

- `workoutSetId`
- `exerciseRef`
- `workoutSessionId` optional
- `repetitions`
- `load`
- `performedAt`
- `label`
- `comment`
- `rpe` optional
- `rir` optional
- `source`

## Value objects

- `WorkoutSetId`: stable local ID for a logged set.
- `WorkoutSessionId`: stable local ID for a workout session.
- `OfficialExerciseId`: stable ID for a bundled official exercise.
- `CustomExerciseId`: stable local ID for a user-created exercise.
- `ExerciseRef`: references either official catalog ID or custom exercise ID and stores a display-name snapshot.
- `LoadKg`: non-negative finite load in kilograms.
- `Repetitions`: positive integer.
- `PerformedAt`: timestamp for when the set was logged.
- `SetComment`: optional non-blank logged-set comment.
- `VolumeLoad`: calculated `load * repetitions`.
- `FormulaIdentity`: stable name and version for an analytics formula.
- `EstimatedOneRepMax`: estimated one-repetition maximum in kilograms with the
  formula identity used to calculate it.
- `WorkoutSetAnalyticsSummary`: derived set count, repetitions, volume, average
  kg/rep, best set load, and best estimated 1RM for a set list.
- `PeriodComparison`: current value, optional previous value, absolute delta, and
  percent change when defined.
- `MuscleId`: stable ID for muscle/muscle group.
- `ActivationWeight`: decimal 0.0–1.0 estimate.
- `MuscleLoad`: weighted set/volume contribution by muscle.
- `PeriodRange`: day/week/month/custom.
- `ReadinessScore`: derived non-medical readiness signal.
- `SorenessScore`: user input 0–10 or enum none/light/moderate/high.
- `RecommendationReason`: explainable reason shown in UI.
- `CatalogVersion`: stable official catalog content version.
- `EquipmentTag`: stable equipment tag used by official catalog filtering.
- `MuscleGroup`: stable muscle metadata tag used by official catalog filtering.
- `MovementPattern`: stable movement-pattern tag for official exercises.
- `ExerciseCatalogQuery`: explicit `limit`/`offset` official catalog query with
  optional search/equipment/muscle filters.
- `ExerciseCatalogPage`: paginated official catalog query result.

## Read models

- `ExerciseListItem`
- `WorkoutGroupOverview`
- `ExerciseTimelineEntry`
- `AnalyticsMetricCard`
- `MuscleLoadOverview`
- `ImbalanceWarning`
- `RecommendedExerciseItem`
- `QuickSessionPlan`

## Domain services

- `EpleyOneRepMaxFormula`: MVP estimated 1RM formula
  `loadKg * (1 + repetitions / 30)` with identity `epley_one_rep_max` version
  `1`.
- `WorkoutSetAnalyticsFormulaService`: pure aggregation service for
  `WorkoutSet` lists; it calculates MVP summary metrics without mutating logged
  sets or persisting derived values.
