# Equipment Inventory Model

## Purpose

The equipment model lets the app filter exercises and later generate realistic coaching suggestions. It is especially important for home gyms with limited plates, fixed dumbbells, missing machines, or restricted loading capacity.

## Core concepts

### EquipmentKind

Examples:

- `bodyweight`
- `barbell`
- `dumbbell`
- `kettlebell`
- `machine`
- `cable`
- `smithMachine`
- `bench`
- `pullUpBar`
- `legPress`
- `resistanceBand`

### EquipmentInventoryItem

Suggested fields:

- `id`
- `kind`
- `displayName`
- `isAvailable`
- `maxLoadKg`
- `minIncrementKg`
- `supportsUnilateralWork`
- `notes`

### LoadConstraint

A load constraint describes whether a planned set is feasible.

Fields:

- `exerciseId`
- `requiredEquipmentKinds`
- `requestedLoadKg`
- `isFeasible`
- `limitingReason`
- `maxFeasibleLoadKg`

## Home-gym example

A user owns:

- 20 kg barbell,
- plates allowing maximum loaded barbell weight of 80 kg,
- adjustable dumbbells up to 32 kg each,
- bench,
- pull-up bar.

If a future coach wants to suggest `bench press 100 kg`, the domain should produce a constraint result:

```text
not feasible: barbell maximum load is 80 kg
```

The recommendation engine can then choose one of several strategies:

- cap the load and increase reps,
- add a pause/tempo variation,
- add a backoff set,
- use dumbbell press if feasible,
- choose a different chest exercise.

## MVP usage

In the MVP, equipment inventory is used mostly for filtering exercises. The coach logic comes later.

## Domain rules

- Equipment constraints are user-specific.
- Official exercises define requirements; user equipment defines feasibility.
- Never delete user equipment history automatically.
- Missing equipment metadata should degrade gracefully: show the exercise, but mark feasibility unknown.
- Filtering should support `available only`, `all`, and later `missing equipment alternatives`.
