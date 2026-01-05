import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';

class AppTheme {
  // -------- LIGHT -------- //
  static ThemeData get lightTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: ColorsManager.primary,
      brightness: Brightness.light,
      primary: ColorsManager.primary,
      secondary: ColorsManager.secondary,
      surface: ColorsManager.lightSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: ColorsManager.lightBackground,
      primaryColor: ColorsManager.primary,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),

      textTheme: const TextTheme(
        titleMedium: TextStyle(
          color: ColorsManager.lightTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(
          color: ColorsManager.lightTextSecondary,
        ),
      ),

      cardTheme: CardThemeData(
        color: ColorsManager.lightCard,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      dividerColor: ColorsManager.lightDivider,
    );
  }

  // -------- DARK -------- //
  static ThemeData get darkTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: ColorsManager.primary,
      brightness: Brightness.dark,
      primary: ColorsManager.primary,
      secondary: ColorsManager.secondary,
      surface: ColorsManager.darkSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: ColorsManager.darkBackground,
      primaryColor: ColorsManager.primary,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),

      textTheme: const TextTheme(
        titleMedium: TextStyle(
          color: ColorsManager.darkTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(
          color: ColorsManager.darkTextSecondary,
        ),
      ),

      cardTheme: CardThemeData(
        color: ColorsManager.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      dividerColor: ColorsManager.darkDivider,
    );
  }
}
