import 'package:flutter/material.dart';

import 'repforge_color_tokens.dart';
import 'repforge_metric_colors.dart';
import 'repforge_radius.dart';
import 'repforge_spacing.dart';

abstract final class RepForgeTheme {
  static ThemeData dark() {
    const colorScheme = ColorScheme.dark(
      primary: RepForgeColorTokens.accentPrimaryGreen,
      onPrimary: RepForgeColorTokens.backgroundPrimary,
      secondary: RepForgeColorTokens.accentWeightOrange,
      onSecondary: RepForgeColorTokens.backgroundPrimary,
      tertiary: RepForgeColorTokens.accentOneRepMaxPurple,
      onTertiary: RepForgeColorTokens.backgroundPrimary,
      surface: RepForgeColorTokens.backgroundSecondary,
      onSurface: RepForgeColorTokens.textPrimary,
      error: RepForgeColorTokens.error,
      onError: RepForgeColorTokens.backgroundPrimary,
    );

    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: RepForgeColorTokens.backgroundPrimary,
      extensions: const <ThemeExtension<dynamic>>[RepForgeMetricColors.dark()],
    );

    final textTheme = baseTheme.textTheme.apply(
      bodyColor: RepForgeColorTokens.textPrimary,
      displayColor: RepForgeColorTokens.textPrimary,
    );

    return baseTheme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: RepForgeColorTokens.backgroundPrimary,
        foregroundColor: RepForgeColorTokens.textPrimary,
        centerTitle: false,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: RepForgeColorTokens.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
      ),
      cardTheme: const CardThemeData(
        color: RepForgeColorTokens.surfaceCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(RepForgeRadius.lg)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: RepForgeColorTokens.borderSubtle,
        thickness: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: RepForgeColorTokens.accentPrimaryGreen,
          foregroundColor: RepForgeColorTokens.backgroundPrimary,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(
            horizontal: RepForgeSpacing.xl,
            vertical: RepForgeSpacing.md,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(RepForgeRadius.md)),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: RepForgeSpacing.lg,
            vertical: RepForgeSpacing.md,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(RepForgeRadius.md)),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: RepForgeSpacing.md,
            vertical: RepForgeSpacing.sm,
          ),
          textStyle: const TextStyle(letterSpacing: 0),
        ),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size.square(48)),
          tapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
      textTheme: textTheme.copyWith(
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          color: RepForgeColorTokens.textSecondary,
          height: 1.35,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
