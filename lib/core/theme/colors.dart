import 'package:flutter/material.dart';

class ColorsManager {
  // -------- PRIMARY COLORS -------- //
  static const Color primary = Color(0xFF3C78FF);
  static const Color secondary = Color(0xFF7B61FF);
  static const Color accent = Color(0xFF00D6C9);

  // -------- LIGHT THEME PALETTE -------- //
  static const Color lightBackground = Color(0xFFF7FAFF);
  static const Color lightCard = Colors.white;
  static const Color lightTextPrimary = Color(0xFF101213);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  // Gradient for Light Mode
  static const Color lightGradientStart = Color(
    0xFFE3F2FD,
  ); // Blue.shade50 approx
  static const Color lightGradientEnd = Colors.white;

  // -------- DARK THEME PALETTE -------- //
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color darkCard = Color(0xFF16213E);
  static const Color darkTextPrimary = Color(0xFFF3F4F6);
  static const Color darkTextSecondary = Color(0xFFA1A1AA);

  // Gradient for Dark Mode
  static const Color darkGradientStart = Color(0xFF1A1A2E);
  static const Color darkGradientEnd = Color(0xFF0F172A);

  // -------- SHARED -------- //
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA000);
}
