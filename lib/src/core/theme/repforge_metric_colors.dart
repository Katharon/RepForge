import 'package:flutter/material.dart';

import 'repforge_color_tokens.dart';

@immutable
final class RepForgeMetricColors extends ThemeExtension<RepForgeMetricColors> {
  const RepForgeMetricColors({
    required this.sets,
    required this.repetitions,
    required this.volume,
    required this.kgPerRep,
    required this.oneRepMax,
    required this.weight,
  });

  const RepForgeMetricColors.dark()
    : sets = RepForgeColorTokens.metricSetsPink,
      repetitions = RepForgeColorTokens.metricRepetitionsGreen,
      volume = RepForgeColorTokens.metricVolumeBlue,
      kgPerRep = RepForgeColorTokens.metricKgPerRepOrange,
      oneRepMax = RepForgeColorTokens.accentOneRepMaxPurple,
      weight = RepForgeColorTokens.accentWeightOrange;

  final Color sets;
  final Color repetitions;
  final Color volume;
  final Color kgPerRep;
  final Color oneRepMax;
  final Color weight;

  @override
  RepForgeMetricColors copyWith({
    Color? sets,
    Color? repetitions,
    Color? volume,
    Color? kgPerRep,
    Color? oneRepMax,
    Color? weight,
  }) {
    return RepForgeMetricColors(
      sets: sets ?? this.sets,
      repetitions: repetitions ?? this.repetitions,
      volume: volume ?? this.volume,
      kgPerRep: kgPerRep ?? this.kgPerRep,
      oneRepMax: oneRepMax ?? this.oneRepMax,
      weight: weight ?? this.weight,
    );
  }

  @override
  RepForgeMetricColors lerp(
    covariant ThemeExtension<RepForgeMetricColors>? other,
    double t,
  ) {
    if (other is! RepForgeMetricColors) {
      return this;
    }

    return RepForgeMetricColors(
      sets: Color.lerp(sets, other.sets, t) ?? sets,
      repetitions: Color.lerp(repetitions, other.repetitions, t) ?? repetitions,
      volume: Color.lerp(volume, other.volume, t) ?? volume,
      kgPerRep: Color.lerp(kgPerRep, other.kgPerRep, t) ?? kgPerRep,
      oneRepMax: Color.lerp(oneRepMax, other.oneRepMax, t) ?? oneRepMax,
      weight: Color.lerp(weight, other.weight, t) ?? weight,
    );
  }
}
