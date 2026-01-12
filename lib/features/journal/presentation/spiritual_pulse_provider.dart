import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/pulse_mapper.dart';
import '../data/journal_repository.dart';
import 'journal_providers.dart';

/// Aggregated data for the Spiritual Pulse Dashboard
class SpiritualPulseData {
  final int currentStreak;
  final List<DailyPulsePoint> weeklyTrend;
  final String? weeklyAiSummary;
  final bool hasEnoughDataForAi;

  SpiritualPulseData({
    required this.currentStreak,
    required this.weeklyTrend,
    this.weeklyAiSummary,
    this.hasEnoughDataForAi = false,
  });
}

class DailyPulsePoint {
  final DateTime date;
  final double sentimentScore; // 0.0 to 3.0 scale
  final String dominantEmotion;

  DailyPulsePoint({
    required this.date,
    required this.sentimentScore,
    required this.dominantEmotion,
  });
}

/// Provider that calculates spiritual pulse metrics from journal entries
final spiritualPulseProvider = FutureProvider.autoDispose<SpiritualPulseData>((ref) async {
  final repo = ref.watch(journalRepositoryProvider);
  
  final allEntriesStream = repo.watchAllEntries();
  final allEntries = await allEntriesStream.first;

  // 1. Calculate Streak
  int streak = _calculateStreak(allEntries);

  // 2. Calculate Weekly Trend (Last 7 Days)
  final trendPoints = PulseMapper.getLastSevenDaysPulse(allEntries);
  
  // Map PulsePoints to DailyPulsePoint (adapter)
  final trend = trendPoints.map((p) => DailyPulsePoint(
    date: p.date,
    sentimentScore: p.value,
    dominantEmotion: p.label
  )).toList();

  // 3. AI Summary Logic
  final now = DateTime.now();
  final recentAiEntries = allEntries.where((e) {
    final isRecent = e.createdAt.isAfter(now.subtract(const Duration(days: 7)));
    return isRecent && e.aiAccessEnabled;
  }).length;

  final hasEnoughData = recentAiEntries >= 3;

  return SpiritualPulseData(
    currentStreak: streak,
    weeklyTrend: trend,
    hasEnoughDataForAi: hasEnoughData,
    weeklyAiSummary: hasEnoughData ? "You've been reflecting deeply on themes of gratitude and purpose this week." : null,
  );
});

int _calculateStreak(List<JournalEntry> entries) {
  if (entries.isEmpty) return 0;

  final sorted = List<JournalEntry>.from(entries)
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  
  int streak = 0;
  DateTime? lastDate;

  final hasEntryToday = _isSameDay(sorted.first.createdAt, today);
  
  DateTime checkDate = today;
  if (!hasEntryToday) {
     checkDate = today.subtract(const Duration(days: 1));
     if (!_isSameDay(sorted.first.createdAt, checkDate)) {
       return 0;
     }
  }

  for (var entry in sorted) {
    if (_isSameDay(entry.createdAt, checkDate)) {
      if (lastDate == null || !_isSameDay(entry.createdAt, lastDate)) {
        streak++;
        lastDate = checkDate;
        checkDate = checkDate.subtract(const Duration(days: 1));
      }
    } else if (entry.createdAt.isBefore(checkDate)) {
      break;
    }
  }

  return streak;
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
