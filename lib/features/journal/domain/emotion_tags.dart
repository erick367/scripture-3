import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Predefined emotion tags for journal entries
enum EmotionTag {
  grateful(
    label: 'Grateful',
    color: Color(0xFF10B981), // Green
    icon: LucideIcons.heart,
  ),
  hopeful(
    label: 'Hopeful',
    color: Color(0xFF3B82F6), // Blue
    icon: LucideIcons.sunrise,
  ),
  struggling(
    label: 'Struggling',
    color: Color(0xFFF59E0B), // Orange
    icon: LucideIcons.cloudRain,
  ),
  confused(
    label: 'Confused',
    color: Color(0xFF8B5CF6), // Purple
    icon: LucideIcons.helpCircle,
  ),
  peaceful(
    label: 'Peaceful',
    color: Color(0xFF14B8A6), // Teal
    icon: LucideIcons.wind,
  ),
  anxious(
    label: 'Anxious',
    color: Color(0xFFEF4444), // Red
    icon: LucideIcons.zap,
  ),
  joyful(
    label: 'Joyful',
    color: Color(0xFFFBBF24), // Amber
    icon: LucideIcons.smile,
  ),
  doubtful(
    label: 'Doubtful',
    color: Color(0xFF6B7280), // Gray
    icon: LucideIcons.cloudOff,
  );

  const EmotionTag({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  /// Parse string to EmotionTag enum
  static EmotionTag? fromString(String? value) {
    if (value == null) return null;
    try {
      return EmotionTag.values.firstWhere(
        (e) => e.label.toLowerCase() == value.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
