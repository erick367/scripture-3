import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Scripture Lens 2.0 - Typography System
/// 
/// Inter for UI, Crimson Text for Scripture.
/// Based on FLUTTER_IMPLEMENTATION_GUIDE.md
class AppTextStyles {
  // Font Families
  static const String uiFont = 'Inter';
  static const String scriptureFont = 'Crimson Text';

  // ===== UI Text Styles =====
  
  static TextStyle heading1({Color? color}) => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.5,
    color: color,
  );

  static TextStyle heading2({Color? color}) => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: color,
  );

  static TextStyle heading3({Color? color}) => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: color,
  );

  static TextStyle body({Color? color}) => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: color,
  );

  static TextStyle bodyBold({Color? color}) => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: color,
  );

  static TextStyle bodySmall({Color? color}) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: color,
  );

  static TextStyle caption({Color? color}) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: color,
  );

  static TextStyle label({Color? color}) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    letterSpacing: 2.0,
    color: color,
  );

  static TextStyle buttonText({Color? color}) => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: color,
  );

  // ===== Scripture Text Styles =====

  static TextStyle scripture({double fontSize = 26, Color? color}) => GoogleFonts.crimsonText(
    fontSize: fontSize,
    fontWeight: FontWeight.w400,
    height: 1.8,
    color: color,
  );

  static TextStyle scriptureItalic({double fontSize = 24, Color? color}) => GoogleFonts.crimsonText(
    fontSize: fontSize,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    height: 1.6,
    color: color,
  );

  static TextStyle scriptureBold({double fontSize = 24, Color? color}) => GoogleFonts.crimsonText(
    fontSize: fontSize,
    fontWeight: FontWeight.w700,
    height: 1.6,
    color: color,
  );

  // ===== Special Styles =====

  // Giant streak numbers (120px)
  static TextStyle streakNumber({Color? color}) => GoogleFonts.inter(
    fontSize: 120,
    fontWeight: FontWeight.w900,
    height: 1.0,
    color: color ?? Colors.white,
  );

  // Streak unit text ("days")
  static TextStyle streakUnit({Color? color}) => GoogleFonts.inter(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    color: color ?? Colors.white.withOpacity(0.4),
  );

  // Verse number (superscript)
  static TextStyle verseNumber({double baseFontSize = 22, Color? color}) => GoogleFonts.inter(
    fontSize: baseFontSize * 0.6,
    fontWeight: FontWeight.bold,
    color: color,
  );

  // Circular progress number
  static TextStyle progressNumber({Color? color}) => GoogleFonts.inter(
    fontSize: 30,
    fontWeight: FontWeight.w900,
    color: color,
  );

  // Tab label
  static TextStyle tabLabel({Color? color}) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: color,
  );

  // Badge text
  static TextStyle badge({Color? color}) => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: color ?? Colors.white,
  );

  // Section title
  static TextStyle sectionTitle({Color? color}) => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: color,
  );

  // Card title
  static TextStyle cardTitle({Color? color}) => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: color,
  );

  // Continue reading book name
  static TextStyle bookName({Color? color}) => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: color,
  );
}
