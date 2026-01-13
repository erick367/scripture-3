import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Liquid Glass Design System for ScriptureLens AI
/// 
/// Implements the "Sacred Sanctuary" visual language:
/// - Spatial depth with layered translucent surfaces
/// - High contrast content for legibility
/// - Motion tuned for 120fps
/// - Minimal cognitive load

class LiquidGlassTheme {
  // ═══════════════════════════════════════════════════════════════════════════
  // Color Palette - "Divine Sanctuary"
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Deep Space Black - Primary background
  static const Color deepSpaceBlack = Color(0xFF000000);
  
  /// Indigo Charcoal - Elevated surfaces
  static const Color indigoCharcoal = Color(0xFF12121E);
  
  /// Radiant Cyan - Primary accent (hope, peace, divine breath)
  static const Color radiantCyan = Color(0xFF00F2FF);
  
  /// Celestial Gold - Divine spark (soul sphere, answered prayers)
  static const Color celestialGold = Color(0xFFFFD700);
  
  /// Living Moss - Growth (wisdom, spiritual victory)
  static const Color livingMoss = Color(0xFFA9C77D);
  
  /// Error/Warning states
  static const Color warningOrange = Color(0xFFFF9500);
  static const Color errorRed = Color(0xFFFF3B30);
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Glass Design Tokens
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Backdrop blur for persistent overlays (nav bar, mentor panel)
  static const double blurPersistent = 25.0;
  
  /// Backdrop blur for transient cards (tooltips, micro-cards)
  static const double blurTransient = 8.0;
  
  /// Surface frost opacity
  static const double frostOpacity = 0.06;
  
  /// Border opacity for glass edges
  static const double borderOpacity = 0.15;
  
  /// Border width for glass containers
  static const double borderWidth = 1.5;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Typography
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Scripture text style (Lora - serif)
  static TextStyle scriptureStyle({
    double fontSize = 18,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.white,
  }) {
    return GoogleFonts.lora(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: 1.6,
    );
  }
  
  /// UI label style (Inter - sans-serif)
  static TextStyle uiStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = Colors.white,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
  
  /// Section header style
  static TextStyle headerStyle({Color color = Colors.white38}) {
    return GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 3,
      color: color,
    );
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Glass Container Decorations
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Standard glass card decoration
  static BoxDecoration glassCard({
    double borderRadius = 16,
    Color? surfaceColor,
  }) {
    return BoxDecoration(
      color: (surfaceColor ?? indigoCharcoal).withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: Colors.white.withValues(alpha: borderOpacity),
        width: borderWidth,
      ),
    );
  }
  
  /// Subtle glass card (less prominent)
  static BoxDecoration glassCardSubtle({double borderRadius = 12}) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: frostOpacity),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.08),
        width: 1,
      ),
    );
  }
  
  /// Selected/active state decoration
  static BoxDecoration glassCardSelected({double borderRadius = 16}) {
    return BoxDecoration(
      color: radiantCyan.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: radiantCyan.withValues(alpha: 0.3),
        width: borderWidth,
      ),
    );
  }
  
  /// Floating dock decoration (nav bar)
  static BoxDecoration floatingDock({double borderRadius = 28}) {
    return BoxDecoration(
      color: indigoCharcoal.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: Colors.white.withValues(alpha: borderOpacity),
        width: borderWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Gradients
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Sanctuary header gradient
  static const LinearGradient sanctuaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [deepSpaceBlack, indigoCharcoal],
  );
  
  /// Radiant accent gradient (for highlights)
  static const LinearGradient radiantGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [radiantCyan, Color(0xFF00D4FF)],
  );
  
  /// Celestial gold gradient (for soul sphere)
  static const LinearGradient celestialGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [celestialGold, Color(0xFFFFC107)],
  );
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Pulse Colors (Emotion-based)
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Get color for pulse value (1-5 scale)
  static Color getPulseColor(double pulse) {
    if (pulse >= 4.5) {
      return celestialGold; // Joy, gratitude
    } else if (pulse >= 3.5) {
      return radiantCyan; // Hope, peace
    } else if (pulse >= 2.5) {
      return livingMoss; // Reflection, uncertainty
    } else if (pulse >= 1.5) {
      return warningOrange; // Anxiety, struggle
    } else {
      return errorRed; // Despair, grief
    }
  }
  
  /// Get emotion label for pulse value
  static String getPulseLabel(double pulse) {
    if (pulse >= 4.5) return 'Radiant';
    if (pulse >= 3.5) return 'Hopeful';
    if (pulse >= 2.5) return 'Reflective';
    if (pulse >= 1.5) return 'Struggling';
    return 'Grieving';
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Animation Durations
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Quick micro-interactions (button press, tab switch)
  static const Duration durationFast = Duration(milliseconds: 150);
  
  /// Standard transitions (card expand, page transition)
  static const Duration durationMedium = Duration(milliseconds: 250);
  
  /// Slow, deliberate animations (soul sphere, hero transitions)
  static const Duration durationSlow = Duration(milliseconds: 400);
  
  /// Standard easing curve
  static const Curve standardCurve = Curves.easeOutCubic;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MaterialApp Theme
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Get the full app theme
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: deepSpaceBlack,
      
      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: radiantCyan,
        secondary: celestialGold,
        surface: indigoCharcoal,
        error: errorRed,
        onPrimary: deepSpaceBlack,
        onSecondary: deepSpaceBlack,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: indigoCharcoal,
        elevation: 0,
        titleTextStyle: uiStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Cards
      cardTheme: CardThemeData(
        color: indigoCharcoal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.white.withValues(alpha: borderOpacity),
            width: borderWidth,
          ),
        ),
      ),
      
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: radiantCyan,
          foregroundColor: deepSpaceBlack,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: uiStyle(fontWeight: FontWeight.w600),
        ),
      ),
      
      // Text Buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: radiantCyan,
          textStyle: uiStyle(fontWeight: FontWeight.w600),
        ),
      ),
      
      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: frostOpacity),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: borderOpacity),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: borderOpacity),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: radiantCyan),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      // Dividers
      dividerTheme: DividerThemeData(
        color: Colors.white.withValues(alpha: 0.1),
        thickness: 1,
      ),
      
      // Bottom Navigation
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: indigoCharcoal,
        selectedItemColor: radiantCyan,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
      ),
      
      // Tab Bar
      tabBarTheme: TabBarThemeData(
        indicatorColor: radiantCyan,
        labelColor: radiantCyan,
        unselectedLabelColor: Colors.white54,
        labelStyle: uiStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1),
        unselectedLabelStyle: uiStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 1),
      ),
    );
  }
}
