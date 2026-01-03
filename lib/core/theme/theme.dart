import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';

class AppTheme {
  // -------- LIGHT THEME CONFIG -------- //
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: ColorsManager.lightBackground,
    primaryColor: ColorsManager.primary,
    colorScheme: const ColorScheme.light(
      primary: ColorsManager.primary,
      secondary: ColorsManager.secondary,
      surface: ColorsManager.lightCard,
      error: ColorsManager.error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: ColorsManager.lightTextPrimary),
      titleTextStyle: TextStyle(
        color: ColorsManager.lightTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(color: ColorsManager.lightTextPrimary),
      bodyMedium: TextStyle(color: ColorsManager.lightTextSecondary),
    ),
    cardTheme: CardThemeData(
      color: ColorsManager.lightCard,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  // -------- DARK THEME CONFIG -------- //
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ColorsManager.darkBackground,
    primaryColor: ColorsManager.primary,
    colorScheme: const ColorScheme.dark(
      primary: ColorsManager.primary,
      secondary: ColorsManager.secondary,
      surface: ColorsManager.darkCard,
      error: ColorsManager.error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: ColorsManager.darkTextPrimary),
      titleTextStyle: TextStyle(
        color: ColorsManager.darkTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(color: ColorsManager.darkTextPrimary),
      bodyMedium: TextStyle(color: ColorsManager.darkTextSecondary),
    ),
    cardTheme: CardThemeData(
      color: ColorsManager.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
