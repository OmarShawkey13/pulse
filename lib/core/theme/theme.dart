import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/text_styles.dart';

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
        backgroundColor: ColorsManager.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ColorsManager.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      textTheme: TextTheme(
        titleMedium: TextStylesManager.medium18.copyWith(
          color: ColorsManager.lightTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStylesManager.regular14.copyWith(
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
        backgroundColor: ColorsManager.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ColorsManager.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),

      textTheme: TextTheme(
        titleMedium: TextStylesManager.medium18.copyWith(
          color: ColorsManager.darkTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStylesManager.regular14.copyWith(
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
