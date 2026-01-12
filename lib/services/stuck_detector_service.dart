import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../core/database/app_database.dart';

/// StuckDetector Service
/// Monitors user's reading progress and identifies when they're "stuck"
/// (no progress for 3+ days) to trigger contextual help
class StuckDetectorService {
  final AppDatabase _database;

  StuckDetectorService(this._database);

  /// Check if user is stuck (no reading progress in last 3 days)
  Future<StuckStatus?> checkIfStuck() async {
    try {
      final now = DateTime.now();
      final threeDaysAgo = now.subtract(const Duration(days: 3));
      
      // Query journal entries from last 7 days
      final recentEntries = await (_database.select(_database.journalEntries)
            ..where((entry) => entry.createdAt.isBiggerOrEqualValue(threeDaysAgo))
            ..orderBy([(entry) => OrderingTerm.desc(entry.createdAt)]))
          .get();

      if (recentEntries.isEmpty) {
        return null; // No recent activity at all
      }

      // Get the most recent entry
      final latestEntry = recentEntries.first;
      final daysSinceLastEntry = now.difference(latestEntry.createdAt).inDays;

      // If last entry was 3+ days ago, user is stuck
      if (daysSinceLastEntry >= 3) {
        const dominantPulse = 'Seeking';
        
        return StuckStatus(
          lastBook: _extractBookFromVerseRef(latestEntry.verseReference),
          lastChapter: _extractChapterFromVerseRef(latestEntry.verseReference),
          daysSinceProgress: daysSinceLastEntry,
          dominantEmotion: dominantPulse,
          lastVerseReference: latestEntry.verseReference,
        );
      }

      return null;
      
    } catch (e) {
      print('StuckDetector Error: $e');
      return null;
    }
  }

  String _extractBookFromVerseRef(String? verseRef) {
    if (verseRef == null || verseRef.isEmpty) return 'Genesis';
    final parts = verseRef.split(' ');
    if (parts.length >= 2 && int.tryParse(parts[0]) != null) {
      return '${parts[0]} ${parts[1]}';
    }
    return parts.first;
  }

  String _extractChapterFromVerseRef(String? verseRef) {
    if (verseRef == null || verseRef.isEmpty) return '1';
    final match = RegExp(r'(\d+):').firstMatch(verseRef);
    return match?.group(1) ?? '1';
  }
}

class StuckStatus {
  final String lastBook;
  final String lastChapter;
  final int daysSinceProgress;
  final String dominantEmotion;
  final String? lastVerseReference;

  StuckStatus({
    required this.lastBook,
    required this.lastChapter,
    required this.daysSinceProgress,
    required this.dominantEmotion,
    this.lastVerseReference,
  });
}

// Database provider (simple version - shares instance)
final _databaseInstance = AppDatabase();

final stuckDetectorServiceProvider = Provider<StuckDetectorService>((ref) {
  return StuckDetectorService(_databaseInstance);
});

final stuckStatusProvider = FutureProvider<StuckStatus?>((ref) async {
  final service = ref.read(stuckDetectorServiceProvider);
  return service.checkIfStuck();
});
