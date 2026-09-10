import 'package:flutter/material.dart';
import 'colors.dart';

class ConvivaTypography {
  // Tipografia serifada elegante para títulos (fiel aos mockups: 01-home, etc.)
  static const TextStyle titleSerifLarge = TextStyle(
    fontFamily: 'serif',
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: ConvivaColors.textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle titleSerifMedium = TextStyle(
    fontFamily: 'serif',
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: ConvivaColors.textPrimary,
    letterSpacing: -0.2,
  );

  static const TextStyle titleSerifSmall = TextStyle(
    fontFamily: 'serif',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: ConvivaColors.textPrimary,
  );

  // Tipografia sans-serif limpa e ampliada para idosos
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 17,
    color: ConvivaColors.textPrimary,
    height: 1.45,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 15,
    color: ConvivaColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    color: ConvivaColors.textMuted,
  );

  static const TextStyle button = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.2,
  );
}
