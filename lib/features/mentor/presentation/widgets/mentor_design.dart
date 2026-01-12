import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// Design tokens for consistent glassmorphism across Mentor Hub
class MentorDesign {
  // Glassmorphism defaults (matching AiMentorPanel)
  static const double glassBlur = 15.0;
  static const double glassOpacity = 0.1;
  static const double glassBorderWidth = 1.5;
  static const double glassBorderOpacity = 0.2;
  
  // Card radii
  static const double cardRadius = 24.0;
  static const double chipRadius = 16.0;
  
  // Theme colors
  static const Color primaryAccent = Color(0xFF6366F1); // Indigo
  static const Color ambientGlow = Color(0xFF818CF8);
  static const Color paperBackground = Color(0xFF0A0A0A);
  
  // Language colors for chips
  static Color languageColor(String language) {
    switch (language.toLowerCase()) {
      case 'greek':
        return const Color(0xFF2DD4BF); // Teal
      case 'hebrew':
        return const Color(0xFFFB923C); // Orange  
      case 'aramaic':
        return const Color(0xFFA855F7); // Purple
      default:
        return const Color(0xFF60A5FA); // Blue
    }
  }
  
  // Journey theme colors
  static Color themeColor(String theme) {
    final hash = theme.hashCode;
    final colors = [
      const Color(0xFFF472B6), // Pink
      const Color(0xFF60A5FA), // Blue
      const Color(0xFF34D399), // Green
      const Color(0xFFFBBF24), // Yellow
      const Color(0xFFA78BFA), // Violet
      const Color(0xFF2DD4BF), // Teal
    ];
    return colors[hash.abs() % colors.length];
  }
}

/// Reusable glassmorphic card container
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final Color? accentColor;
  final VoidCallback? onTap;
  
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.height,
    this.accentColor,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(MentorDesign.cardRadius),
        child: Stack(
          children: [
            // Blur layer
            BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: MentorDesign.glassBlur,
                sigmaY: MentorDesign.glassBlur,
              ),
              child: Container(color: Colors.transparent),
            ),
            // Glass container
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(MentorDesign.cardRadius),
                border: Border.all(
                  color: (accentColor ?? Colors.white)
                      .withValues(alpha: MentorDesign.glassBorderOpacity),
                  width: MentorDesign.glassBorderWidth,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: MentorDesign.glassOpacity),
                    Colors.white.withValues(alpha: MentorDesign.glassOpacity * 0.5),
                  ],
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: onTap != null
                    ? InkWell(
                        borderRadius: BorderRadius.circular(MentorDesign.cardRadius),
                        onTap: onTap,
                        child: Padding(
                          padding: padding ?? const EdgeInsets.all(16),
                          child: child,
                        ),
                      )
                    : Padding(
                        padding: padding ?? const EdgeInsets.all(16),
                        child: child,
                      ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable glassmorphic chip 
class GlassChip extends StatelessWidget {
  final String label;
  final String? sublabel;
  final Color accentColor;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isSelected;
  
  const GlassChip({
    super.key,
    required this.label,
    this.sublabel,
    this.accentColor = Colors.white,
    this.onTap,
    this.icon,
    this.isSelected = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(MentorDesign.chipRadius),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected 
                ? accentColor.withValues(alpha: 0.2)
                : accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(MentorDesign.chipRadius),
            border: Border.all(
              color: accentColor.withValues(alpha: isSelected ? 0.5 : 0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: accentColor),
                const SizedBox(width: 8),
              ],
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  if (sublabel != null)
                    Text(
                      sublabel!,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
