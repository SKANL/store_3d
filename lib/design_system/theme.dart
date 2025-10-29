import 'package:flutter/material.dart';

/// Centralized theme and color definitions for the app.
///
/// All colors used across the app should be referenced from this file so
/// changing the visual identity is easy and consistent.
class AppColors {
  AppColors._();

  // Primary brand seed used to generate the ColorScheme
  // Updated palette inspired by Mercado Libre (vibrant yellow + teal accents)
  static const Color seed = Color(0xFFFFE600);

  // Background / surfaces
  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Color(0xFFFFFFFF);

  // Accent / semantic
  static const Color success = Color(0xFF00A650);
  static const Color danger = Color(0xFFE52330);
  static const Color muted = Color(0xFF6D6D6D);
  // Utility
  static const Color transparent = Color(0x00000000);
  static const Color shadow = Color(0x14000000);
}

ThemeData appThemeData() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.seed,
    brightness: Brightness.light,
  );

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: AppColors.shadow,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(height: 1.3),
    ),
  );
}
