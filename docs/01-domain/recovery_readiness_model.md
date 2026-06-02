# Recovery and Readiness Model

## Purpose

Reduce poor recommendations when the user is sore, fatigued, or performing below baseline.

## Inputs

### User input

- General soreness.
- Optional region soreness.
- Session perceived exertion.
- Energy/motivation optional later.
- Pain warning optional later.

Slice 47 implements the first local readiness check-in shape:

- `soreness`: integer 0–4 (`none`, `light`, `moderate`, `high`, `veryHigh`).
- `sleepQuality`: integer 1–5.
- `energy`: integer 1–5.
- `stress`: integer 1–5.
- `motivation`: integer 1–5.
- `checkedInAt`: UTC timestamp saved with the check-in.

These values are user feedback for training guidance only. They are not medical
measurements, and they must not be used to block workout logging.

### Derived signals

- Time since last direct muscle stimulus.
- Recent rolling volume.
- Performance drop versus recent baseline.
- Frequency of hard sessions.
- Missed deload intervals.

## Readiness levels

- High: normal progression allowed.
- Medium: maintain or small progression.
- Low: reduce volume/intensity or choose alternatives.
- Very low: suggest rest, mobility, or different muscle group.

Slice 47 scoring is deterministic and intentionally simple:

```text
100
- soreness * 10
- (5 - sleepQuality) * 5
- (5 - energy) * 5
- (stress - 1) * 2
- (5 - motivation) * 1
```

The score is clamped to 0–100 and mapped to `high`, `medium`, `low`, or
`veryLow`. The readiness read model also carries confidence, reasons, latest
check-in, and an explicit empty state when no local check-in exists for the
requested day.

## DOMS handling

DOMS is not treated as proof of growth or injury. It is a signal that can influence direct muscle recommendations.

## Strength-down logic

If a user is weaker than expected:

- Check if soreness/readiness is low.
- If low: reduce or stop direct work.
- If acceptable: suggest lower-load backoff volume or extra set to preserve useful volume.
- Avoid forcing heavier load.

## Deload logic

Suggest deload when several signals align:

- 4–6 weeks of progressive volume/intensity without reduced week.
- Repeated strength drops.
- High soreness reports.
- High perceived exertion.
- Poor readiness across several sessions.

## UI wording

Use non-medical language:

- `Your readiness looks low for heavy chest work today.`
- `Consider reducing load or choosing a lighter variation.`
- `This is an estimate based on your logs and feedback.`

Today may show a compact `Readiness estimate` card. It should use cautious
copy such as `Estimate based on your latest local check-in.` and must not use
injury-prevention, diagnosis, or mandatory-rest language.
