import 'package:flutter/material.dart';

extension RepForgeTextTheme on TextTheme {
  TextStyle get metricValue {
    return (headlineMedium ?? const TextStyle()).copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
      fontWeight: FontWeight.w800,
      letterSpacing: 0,
    );
  }

  TextStyle get metricUnit {
    return (labelLarge ?? const TextStyle()).copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
    );
  }
}
