import 'package:flutter/material.dart';

class ColorsManager {
  // -------- BRAND / CORE -------- //
  static const Color primary = Color(0xFF5B6CFF);   // Indigo Pulse
  static const Color secondary = Color(0xFF8B7CFF); // Soft Violet
  static const Color accent = Color(0xFF22E1D3);    // Cyan Pulse

  // -------- LIGHT THEME -------- //
  static const Color lightBackground = Color(0xFFF5F7FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color homeContentCardLight = Color(0xFFF1F4FA);

  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  static const Color lightDivider = Color(0xFFE5E7EB);

  // Gradient (Light)
  static const Color lightGradientStart = Color(0xFFEFF3FF);
  static const Color lightGradientEnd = Color(0xFFFFFFFF);

  // -------- DARK THEME -------- //
  static const Color darkBackground = Color(0xFF0B1020); // Deep Night
  static const Color darkSurface = Color(0xFF11162A);
  static const Color darkCard = Color(0xFF161B34);
  static const Color homeContentCardDark = Color(0xFF12172B);

  static const Color darkTextPrimary = Color(0xFFE5E7EB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  static const Color darkDivider = Color(0xFF1F2937);

  // Gradient (Dark)
  static const Color darkGradientStart = Color(0xFF0B1020);
  static const Color darkGradientEnd = Color(0xFF020617);

  // -------- STATES -------- //
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
}
