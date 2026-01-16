import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Scripture Lens 2.0 - App Theme
/// 
/// Time-based light/dark mode switching.
class AppTheme {
  // Time of day detection
  static TimeOfDayPeriod getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return TimeOfDayPeriod.morning;
    if (hour >= 12 && hour < 17) return TimeOfDayPeriod.day;
    if (hour >= 17 && hour < 20) return TimeOfDayPeriod.evening;
    return TimeOfDayPeriod.night;
  }

  // Auto dark mode (8pm - 5am)
  static bool isDarkMode() {
    final hour = DateTime.now().hour;
    return hour >= 20 || hour < 5;
  }

  // Get greeting based on time
  static String getGreeting() {
    switch (getTimeOfDay()) {
      case TimeOfDayPeriod.morning:
        return 'Good Morning';
      case TimeOfDayPeriod.day:
        return 'Good Afternoon';
      case TimeOfDayPeriod.evening:
        return 'Good Evening';
      case TimeOfDayPeriod.night:
        return 'Good Night';
    }
  }

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.spiritualCream,
      colorScheme: const ColorScheme.light(
        primary: AppColors.spiritualGold,
        secondary: AppColors.spiritualGoldLight,
        tertiary: AppColors.spiritualSage,
        surface: Colors.white,
        error: AppColors.red500,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF1C1917),
        onError: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1C1917),
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1C1917),
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: const Color(0xFF1C1917),
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: const Color(0xFF4B5563),
        ),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.spiritualGold,
        secondary: AppColors.spiritualGoldLight,
        tertiary: AppColors.spiritualSage,
        surface: AppColors.spiritualDark,
        error: AppColors.red500,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
    );
  }
}

enum TimeOfDayPeriod {
  morning,
  day,
  evening,
  night,
}
