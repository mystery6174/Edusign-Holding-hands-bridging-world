// FILE 1: Defines the consistent color palette (Teal and Gold)
import 'package:flutter/material.dart';

class AppColors {
  // --- BRAND COLORS ---

  // Primary Brand Color (Teal for main actions, buttons, and primary accents)
  static const Color primaryTeal = Color(0xFF008080);

  // Secondary Brand Color (Muted Gold for subtle links and secondary accents)
  static const Color secondaryGold = Color(0xFFB8860B);

  // --- BACKGROUND & SURFACE COLORS ---

  // Scaffold/Main Background (Soft Off-White for Light Mode)
  static const Color lightBackground = Color(0xFFF5F5F5);

  // Card/Canvas Interior (The floating form background in AuthPage)
  static const Color cardCanvas = Colors.white;

  // --- TEXT COLORS ---

  // Primary Text Color (Dark Grey for headlines/main content in Light Mode)
  static const Color lightText = Color(0xFF333333);

  // Subtler Text Color (For hints, placeholders, and supporting text)
  static const Color subtleText = Color(0xFF757575);

  // --- INPUT & BORDER COLORS ---

  // Default Border Color (Thin, light grey for clean input fields)
  static const Color inputBorderLight = Color(0xFFCCCCCC);
}
