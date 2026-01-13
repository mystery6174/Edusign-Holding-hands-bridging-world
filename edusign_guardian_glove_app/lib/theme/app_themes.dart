import 'package:flutter/material.dart';
import 'package:edusign_guardian_glove_app/core/constants/app_colors.dart';

class AppThemes {
  // --- BASE TYPOGRAPHY (Poppins Style) ---
  static const TextStyle _poppinsBase = TextStyle(fontFamily: 'Poppins');

  // =========================================================================
  // LIGHT THEME CONFIGURATION
  // =========================================================================
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryTeal,
    scaffoldBackgroundColor: AppColors.lightBackground,

    // --- AppBar Theme (Minimalist) ---
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.lightText),
      titleTextStyle: _poppinsBase.copyWith(
        color: AppColors.lightText,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    // --- Typography Setup (Light) ---
    textTheme: TextTheme(
      headlineMedium: _poppinsBase.copyWith(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.lightText),
      titleMedium: _poppinsBase.copyWith(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.subtleText),
      bodyMedium: _poppinsBase.copyWith(color: AppColors.lightText),
      bodySmall: _poppinsBase.copyWith(color: AppColors.subtleText),
      labelLarge: _poppinsBase.copyWith(color: Colors.white),
    ),

    // --- Elevated Button Theme (Teal Primary Button) ---
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryTeal, // was 'primary'
        foregroundColor: Colors.white,          // was 'onPrimary'
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        textStyle: _poppinsBase.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // --- Input Field Decoration Theme (Clean & Chic) ---
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: _poppinsBase.copyWith(color: AppColors.subtleText),
      prefixIconColor: AppColors.subtleText,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.inputBorderLight, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      fillColor: AppColors.cardCanvas,
      filled: true,
    ),
  );

  // =========================================================================
  // DARK THEME CONFIGURATION
  // =========================================================================
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryTeal,
    scaffoldBackgroundColor: const Color(0xFF121212), // Dark background
    cardColor: const Color(0xFF2C2C2C),              // Slightly lighter card

    // --- AppBar Theme (Dark) ---
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF121212),
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: _poppinsBase.copyWith(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    // --- Typography Setup (Dark) ---
    textTheme: TextTheme(
      headlineMedium: _poppinsBase.copyWith(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
      titleMedium: _poppinsBase.copyWith(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.subtleText),
      bodyMedium: _poppinsBase.copyWith(color: Colors.white),
      bodySmall: _poppinsBase.copyWith(color: AppColors.subtleText),
      labelLarge: _poppinsBase.copyWith(color: Colors.white),
    ),

    // --- Elevated Button Theme (Teal Primary Button) ---
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryTeal, // fixed
        foregroundColor: Colors.white,          // fixed
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        textStyle: _poppinsBase.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // --- Input Field Decoration Theme (Dark Chic) ---
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: _poppinsBase.copyWith(color: AppColors.subtleText),
      prefixIconColor: AppColors.subtleText,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF444444), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      fillColor: const Color(0xFF2C2C2C),
      filled: true,
    ),
  );
}
