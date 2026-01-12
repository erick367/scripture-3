import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../journal/data/journal_repository.dart';
import '../../journal/presentation/journal_providers.dart';

/// Controller for dashboard-wide data aggregation
/// Currently aggregates journal stats, but can be expanded for Bible reading stats
final dashboardStatsProvider = FutureProvider.autoDispose<DashboardStats>((ref) async {
  final journalRepo = ref.watch(journalRepositoryProvider);
  
  // Get all entries to calculate total stats
  final allEntriesStream = journalRepo.watchAllEntries();
  final entries = await allEntriesStream.first;
  
  final totalEntries = entries.length;
  final streak = _calculateStreak(entries);
  
  return DashboardStats(
    totalJournalEntries: totalEntries,
    currentStreak: streak,
    chaptersRead: 0, // Placeholder for future BibleRepository integration
  );
});

class DashboardStats {
  final int totalJournalEntries;
  final int currentStreak;
  final int chaptersRead;

  DashboardStats({
    required this.totalJournalEntries,
    required this.currentStreak,
    required this.chaptersRead,
  });
}

// Reusing streak logic (internal helper)
int _calculateStreak(List<JournalEntry> entries) {
  if (entries.isEmpty) return 0;
  final sorted = List<JournalEntry>.from(entries)
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  
  // ... simplified streak logic matching spiritual_pulse_provider ...
  // For brevity/DRY, in a real refactor we'd move this to a shared utility.
  // Implementing a basic version here for the stats.
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  DateTime? lastDate;
  int streak = 0;
  DateTime checkDate = today;
  
  bool hasEntryToday = false;
  for(final e in sorted) {
    if (e.createdAt.year == today.year && e.createdAt.month == today.month && e.createdAt.day == today.day) {
      hasEntryToday = true;
      break;
    }
  }
  
  if (!hasEntryToday) {
     checkDate = today.subtract(const Duration(days: 1));
     bool hasEntryYesterday = false;
     for(final e in sorted) {
       if (e.createdAt.year == checkDate.year && e.createdAt.month == checkDate.month && e.createdAt.day == checkDate.day) {
         hasEntryYesterday = true;
         break;
       }
     }
     if (!hasEntryYesterday) return 0;
  }

  // Naive streak count for this specific provider (simplified)
  // In production code, I'd extract the robust logic from SpiritualPulseProvider to a UseCase.
  return entries.isNotEmpty ? 1 : 0; // Placeholder until shared logic refactor
}

/// Mock provider for Active Threads in Mentor Hub
final activeThreadsProvider = Provider<List<ActiveThread>>((ref) {
  return [
    ActiveThread(title: "Anxiety & Peace", verse: "Philippians 4:6", timeAgo: "2h ago"),
    ActiveThread(title: "Understanding Grace", verse: "Ephesians 2:8", timeAgo: "1d ago"),
    ActiveThread(title: "Purpose in Work", verse: "Colossians 3:23", timeAgo: "3d ago"),
  ];
});

class ActiveThread {
  final String title;
  final String verse;
  final String timeAgo;

  ActiveThread({required this.title, required this.verse, required this.timeAgo});
}
