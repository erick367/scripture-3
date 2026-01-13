import '../models/journal_entry.dart';

/// Domain interface for journal operations
/// 
/// Abstracts local encrypted storage and cloud sync.
abstract class JournalRepository {
  /// Get all journal entries, optionally filtered by date range
  Future<List<JournalEntry>> getEntries({
    DateTime? startDate,
    DateTime? endDate,
  });
  
  /// Get entries for the last N days
  Future<List<JournalEntry>> getRecentEntries(int days);
  
  /// Get a single entry by ID
  Future<JournalEntry?> getEntryById(int id);
  
  /// Create a new journal entry
  /// 
  /// [aiAccessEnabled] determines if entry is synced to cloud for AI features.
  Future<JournalEntry> createEntry({
    required String content,
    required String emotionTag,
    String? verseReference,
    bool aiAccessEnabled = false,
    String? lookForwardNotes,
  });
  
  /// Update an existing entry
  Future<void> updateEntry(JournalEntry entry);
  
  /// Delete an entry by ID
  Future<void> deleteEntry(int id);
  
  /// Search entries using encrypted FTS5
  Future<List<JournalEntry>> searchEntries(String query);
  
  /// Get entries by theme (AI-detected thematic grouping)
  Future<List<JournalEntry>> getEntriesByTheme(String theme);
  
  /// Stream of entries for real-time updates
  Stream<List<JournalEntry>> watchEntries();
  
  /// Get spiritual pulse (average emotion) for last N days
  Future<double> getAveragePulse(int days);
  
  /// Get streak count (consecutive days with entries)
  Future<int> getStreak();
}

/// Domain interface for thread injection (finding related journal entries)
abstract class ThreadInjectionService {
  /// Find journal entries related to a verse's themes
  /// 
  /// Returns entries that match the verse's thematic content.
  Future<List<JournalEntry>> findRelevantThreads({
    required String verseText,
    required String verseReference,
    int maxResults = 3,
  });
  
  /// Extract themes from a verse
  Future<List<String>> extractVerseThemes(String verseText);
}
