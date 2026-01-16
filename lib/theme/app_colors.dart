import 'package:flutter/material.dart';

/// Scripture Lens 2.0 - Color Palette
/// 
/// Warm earthy theme with spiritual gold accents.
/// Based on FLUTTER_IMPLEMENTATION_GUIDE.md
class AppColors {
  // Primary Spiritual Theme
  static const Color spiritualGold = Color(0xFFC17D4A);
  static const Color spiritualGoldLight = Color(0xFFD4A574);
  static const Color spiritualCream = Color(0xFFFAF8F5);
  static const Color spiritualBrown = Color(0xFF8B7355);
  static const Color spiritualSage = Color(0xFFA3B18A);
  static const Color spiritualDark = Color(0xFF2C2416);

  // Dark Mode
  static const Color backgroundDark = Color(0xFF0A0A0A);
  static const Color foregroundDark = Color(0xFFFAFAF9);

  // Light Mode Background
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color blue50 = Color(0xFFEBF8FF);
  static const Color indigo50 = Color(0xFFEEF2FF);

  // Accent Colors  
  static const Color orange400 = Color(0xFFFB923C);
  static const Color orange500 = Color(0xFFF97316);
  static const Color orange600 = Color(0xFFEA580C);
  static const Color pink500 = Color(0xFFEC4899);
  static const Color pink600 = Color(0xFFDB2777);
  static const Color purple500 = Color(0xFFA855F7);
  static const Color purple600 = Color(0xFF9333EA);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color cyan500 = Color(0xFF06B6D4);
  static const Color cyan600 = Color(0xFF0891B2);
  static const Color teal500 = Color(0xFF14B8A6);
  static const Color teal600 = Color(0xFF0D9488);
  static const Color green500 = Color(0xFF22C55E);
  static const Color emerald500 = Color(0xFF10B981);
  static const Color emerald600 = Color(0xFF059669);
  static const Color red500 = Color(0xFFEF4444);
  static const Color red600 = Color(0xFFDC2626);
  static const Color amber500 = Color(0xFFF59E0B);

  // Streak Card Browns
  static const Color streakBrownLight = Color(0xFF8B5A3C);
  static const Color streakBrownMid = Color(0xFF7A4E33);
  static const Color streakBrownDark = Color(0xFF6B432A);
  static const Color streakBrownDarkMode1 = Color(0xFF5C2E1F);
  static const Color streakBrownDarkMode2 = Color(0xFF4A2418);
  static const Color streakBrownDarkMode3 = Color(0xFF3D1F14);

  // Gradient Definitions
  static const LinearGradient appBackgroundLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [slate50, blue50, indigo50],
  );

  static const LinearGradient logoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [orange400, pink500, purple500],
  );

  static const LinearGradient streakGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [amber500, orange500, red600],
  );

  static const LinearGradient streakTextGradient = LinearGradient(
    colors: [
      Color(0xFFFED7AA), // orange-200
      Color(0xFFFCA5A5), // red-300
      Color(0xFFF9A8D4), // pink-400
    ],
  );

  static const LinearGradient readingGradient = LinearGradient(
    colors: [blue500, cyan500, teal600],
  );

  static const LinearGradient plansGradient = LinearGradient(
    colors: [purple500, pink500],
  );

  static const LinearGradient journalGradient = LinearGradient(
    colors: [emerald500, emerald600],
  );

  static const LinearGradient homeGradient = LinearGradient(
    colors: [orange500, pink500],
  );

  // Category Gradients
  static const LinearGradient faithGradient = LinearGradient(
    colors: [amber500, orange600],
  );

  static const LinearGradient prayerGradient = LinearGradient(
    colors: [purple500, pink600],
  );

  static const LinearGradient charactersGradient = LinearGradient(
    colors: [blue500, cyan600],
  );

  static const LinearGradient purposeGradient = LinearGradient(
    colors: [green500, emerald600],
  );

  // Mood Gradients
  static const LinearGradient moodStruggling = LinearGradient(
    colors: [red500, red600],
  );

  static const LinearGradient moodGood = LinearGradient(
    colors: [blue500, Color(0xFF2563EB)],
  );

  static const LinearGradient moodBlessed = LinearGradient(
    colors: [purple500, purple600],
  );

  static const LinearGradient moodOverflowing = LinearGradient(
    colors: [amber500, Color(0xFFD97706)],
  );

  // Circular Progress Gradients
  static const LinearGradient chaptersGradient = LinearGradient(
    colors: [blue500, cyan600],
  );

  static const LinearGradient minutesGradient = LinearGradient(
    colors: [purple500, pink600],
  );

  static const LinearGradient goalsGradient = LinearGradient(
    colors: [green500, emerald600],
  );

  // Notification Badge
  static const LinearGradient notificationBadge = LinearGradient(
    colors: [red500, pink500],
  );

  // Chapter Complete
  static const LinearGradient chapterCompleteLight = LinearGradient(
    colors: [Color(0xFFF3E8FF), Color(0xFFEBF8FF)],
  );

  // Helper Methods
  static LinearGradient streakCardGradient(bool isDark) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [streakBrownDarkMode1, streakBrownDarkMode2, streakBrownDarkMode3]
          : [streakBrownLight, streakBrownMid, streakBrownDark],
    );
  }

  static Color background(bool isDark) => isDark ? backgroundDark : spiritualCream;
  static Color foreground(bool isDark) => isDark ? foregroundDark : Color(0xFF1C1917);
  
  static Color cardBackground(bool isDark, [double opacity = 0.05]) {
    return isDark 
        ? Colors.white.withOpacity(opacity) 
        : Colors.white;
  }

  static Color borderColor(bool isDark) {
    return isDark 
        ? Colors.white.withOpacity(0.1) 
        : Colors.black.withOpacity(0.1);
  }

  static Color textSecondary(bool isDark) {
    return isDark 
        ? Colors.white.withOpacity(0.6) 
        : const Color(0xFF6B7280);
  }
}
