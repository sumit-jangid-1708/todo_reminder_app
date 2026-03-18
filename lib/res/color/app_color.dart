// lib/res/colors/app_colors.dart

import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF4280ef);
  static const Color primaryDark = Color(0xFF522F2F);
  static const Color accent = Color(0xFFF48C03);
  static const Color main = Color(0xFFFFAD33);

  // Background
  static const Color background = Color(0xFFFFEBBF);
  static const Color surface = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF4280ef);
  static const Color textSecondary = Color(0xFFf78720);
  static const Color textHint = Color(0xFF07843c);
  static const Color text1 = Color(0xFF757575);

  // Basic
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray = Color(0xFFf5f5f5);
  static const Color darkGray = Color(0xFFe1e1e1);
  static const Color lightBlue = Color(0xFFF0F6FF);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Opacity variants
  static Color primaryWithOpacity(double opacity) =>
      primary.withOpacity(opacity);
  static Color blackWithOpacity(double opacity) => black.withOpacity(opacity);
}