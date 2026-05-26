# Wearables and Health Integration

## Status

Future feature. Do not implement before the dedicated slice.

## Goal

Improve calorie and readiness estimates using optional heart-rate/activity data from platform health APIs or smart watches.

## Inputs later

- Heart-rate samples.
- Workout duration.
- Active energy if provided by platform.
- Steps/activity context.
- Body metrics if user grants permission.

## Architecture

Wearable APIs belong in data/platform adapters. Domain receives normalized samples through application ports.

## Privacy rules

- Opt-in only.
- Explain exactly what is read.
- No hidden upload.
- Allow disconnect/delete.

## MVP calorie estimate without wearable

Use anthropometric approximation from:

- bodyweight,
- age,
- sex/gender if provided,
- duration,
- training type/intensity estimate.

Label as rough estimate.
