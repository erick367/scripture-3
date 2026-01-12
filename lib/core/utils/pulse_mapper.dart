import 'package:flutter/material.dart';
import '../../features/journal/domain/emotion_tags.dart';
import '../../core/database/app_database.dart';

class PulseMapper {
  /// Maps emotion tags to a numerical sentiment score (1.0 - 3.0)
  /// Requirements: Struggling = 1.0, Thoughtful = 2.0, Calm = 3.0
  static double getPulseValue(String? emotionTag) {
    if (emotionTag == null) return 0.0;
    
    final tag = EmotionTag.fromString(emotionTag);
    if (tag == null) return 0.0;

    switch (tag) {
      // "Struggling" tier -> 1.0
      case EmotionTag.struggling:
      case EmotionTag.anxious:
      case EmotionTag.doubtful:
        return 1.0;
        
      // "Thoughtful" tier -> 2.0
      case EmotionTag.confused: // Closest to "working through it"
        return 2.0;

      // "Calm" tier -> 3.0
      case EmotionTag.peaceful:
      case EmotionTag.grateful:
      case EmotionTag.joyful:
      case EmotionTag.hopeful:
        return 3.0;
    }
  }

  /// Color mapping for the graph gradient
  static Color getPulseColor(double value) {
    if (value <= 1.5) return Colors.redAccent;
    if (value <= 2.5) return Colors.amber;
    return Colors.blueAccent;
  }

  /// Processes raw entries into a Last 7 Days data points list
  /// Fills gaps with 0.0
  static List<PulsePoint> getLastSevenDaysPulse(List<JournalEntry> allEntries) {
    final now = DateTime.now();
    final List<PulsePoint> points = [];

    // 0 to 6 days ago (reverse order for list: today is last?) 
    // Usually graphs go Left (old) -> Right (new). 
    // So distinct days: [Now-6, Now-5, ... Now]
    
    for (int i = 6; i >= 0; i--) {
      final targetDate = now.subtract(Duration(days: i));
      final dayStart = DateTime(targetDate.year, targetDate.month, targetDate.day);
      final dayEnd = dayStart.add(const Duration(hours: 23, minutes: 59, seconds: 59));

      // Find entries for this day
      final dayEntries = allEntries.where((e) {
        return e.createdAt.isAfter(dayStart) && e.createdAt.isBefore(dayEnd);
      }).toList();

      if (dayEntries.isEmpty) {
        points.add(PulsePoint(date: dayStart, value: 0.0, label: "No Date"));
      } else {
        // Average the score for the day
        double total = 0;
        for (var e in dayEntries) {
          total += getPulseValue(e.emotionTag);
        }
        final avg = total / dayEntries.length;
        
        // Use the most frequent emotion as label
        // Simplified: just use first for now
        final label = dayEntries.first.emotionTag ?? "";
        
        points.add(PulsePoint(date: dayStart, value: avg, label: label));
      }
    }
    
    return points;
  }
}

class PulsePoint {
  final DateTime date;
  final double value;
  final String label;

  PulsePoint({required this.date, required this.value, required this.label});
}
