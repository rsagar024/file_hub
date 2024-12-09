import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const primary = Color(0xFFD9519D);
  static const secondary = Color(0xFFED8770);
  static const accent = Color(0xFFE1914B);

  // Neutral Colors
  static const neutral = Color(0xFFD0D1D4);
  static const neutralDark = Color(0xFF585A66);
  static const neutralDarker = Color(0xFF383B49);

  // Gradient Colors
  static const gradientStart = Color(0xFFED8770);
  static const gradientEnd = Color(0xFFD9519D);

  // Additional Colors
  static const background = Color(0xFF181B2C);
  static const surface = Color(0xFF657DDF);
  static const error = Color(0xFFFF3B3B);
  static const success = Color(0xFF4CAF50);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );
}