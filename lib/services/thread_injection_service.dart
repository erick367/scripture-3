import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../core/database/app_database.dart';
import '../features/journal/presentation/journal_providers.dart';

final threadInjectionServiceProvider = Provider<ThreadInjectionService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ThreadInjectionService(db);
});

/// Service for injecting relevant journal threads into AI prompts
/// Implements semantic search to find contextually relevant user reflections
class ThreadInjectionService {
  final AppDatabase _db;
  
  // Maximum threads to include in prompt (token budget management)
  static const int maxThreads = 5;
  
  // Maximum characters per thread to prevent token overflow
  static const int maxCharsPerThread = 300;

  ThreadInjectionService(this._db);

  /// Get relevant journal threads for a given verse reference
  /// Uses keyword matching and recency weighting
  Future<List<String>> getRelevantThreads(String verseReference, String verseText) async {
    try {
      // 1. Extract keywords from verse reference and text
      final keywords = _extractKeywords(verseReference, verseText);
      
      // 2. Search journal entries using FTS5 (Full-Text Search)
      final relevantEntries = await _searchJournalEntries(keywords);
      
      // 3. Format entries as context strings
      return relevantEntries
          .take(maxThreads)
          .map((entry) => _formatAsThread(entry))
          .toList();
    } catch (e) {
      print('ThreadInjection error: $e');
      return [];
    }
  }

  /// Extract searchable keywords from verse context
  List<String> _extractKeywords(String reference, String text) {
    final keywords = <String>[];
    
    // Add book name from reference (e.g., "John" from "John 3:16")
    final bookMatch = RegExp(r'^(\w+)').firstMatch(reference);
    if (bookMatch != null) {
      keywords.add(bookMatch.group(1)!);
    }
    
    // Extract significant words from verse text (excluding common words)
    final commonWords = {'the', 'a', 'an', 'and', 'or', 'is', 'was', 'were', 'are', 
                         'be', 'been', 'to', 'of', 'in', 'for', 'on', 'with', 'as',
                         'at', 'by', 'from', 'that', 'this', 'it', 'not', 'but'};
    
    final words = text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '') // Remove punctuation
        .split(RegExp(r'\s+'))
        .where((w) => w.length > 3 && !commonWords.contains(w))
        .take(10)
        .toList();
    
    keywords.addAll(words);
    
    // Add spiritual/theological keywords if present in verse
    final spiritualTerms = ['god', 'lord', 'jesus', 'christ', 'spirit', 'faith', 
                            'love', 'hope', 'grace', 'mercy', 'salvation', 'sin',
                            'light', 'truth', 'life', 'word', 'prayer'];
    for (final term in spiritualTerms) {
      if (text.toLowerCase().contains(term)) {
        keywords.add(term);
      }
    }
    
    return keywords.toSet().toList(); // Deduplicate
  }

  /// Search journal entries using FTS5 full-text search
  Future<List<JournalEntry>> _searchJournalEntries(List<String> keywords) async {
    if (keywords.isEmpty) return [];
    
    try {
      // Build FTS5 query: "word1 OR word2 OR word3"
      final ftsQuery = keywords.join(' OR ');
      
      // Query the FTS5 virtual table
      final results = await _db.customSelect(
        '''
        SELECT je.* FROM journal_entries je
        INNER JOIN journal_entries_search jes ON je.id = jes.rowid
        WHERE journal_entries_search MATCH ?
        AND je.ai_access_enabled = 1
        ORDER BY je.created_at DESC
        LIMIT ?
        ''',
        variables: [Variable.withString(ftsQuery), Variable.withInt(maxThreads * 2)],
        readsFrom: {_db.journalEntries},
      ).get();
      
      // Map to JournalEntry objects
      return results.map((row) {
        final createdAtStr = row.read<String>('created_at');
        return JournalEntry(
          id: row.read<int>('id'),
          content: row.read<String>('content'),
          emotionTag: row.read<String?>('emotion_tag'),
          aiAccessEnabled: row.read<bool>('ai_access_enabled'),
          createdAt: DateTime.parse(createdAtStr),
          updatedAt: DateTime.parse(createdAtStr), // Use createdAt as fallback
          verseReference: row.read<String?>('verse_reference'),
        );
      }).toList();
    } catch (e) {
      print('FTS5 search error: $e');
      
      // Fallback: Simple LIKE query if FTS5 fails
      return _fallbackSearch(keywords);
    }
  }

  /// Fallback search using LIKE when FTS5 is unavailable
  Future<List<JournalEntry>> _fallbackSearch(List<String> keywords) async {
    try {
      // Get recent AI-enabled entries
      final entries = await (_db.select(_db.journalEntries)
        ..where((e) => e.aiAccessEnabled.equals(true))
        ..orderBy([(e) => OrderingTerm.desc(e.createdAt)])
        ..limit(20))
        .get();
      
      // Score entries by keyword matches
      final scored = entries.map((entry) {
        final score = keywords.fold<int>(0, (sum, keyword) {
          return sum + (entry.content.toLowerCase().contains(keyword) ? 1 : 0);
        });
        return MapEntry(entry, score);
      }).toList();
      
      // Sort by score, filter out zero-score entries
      scored.sort((a, b) => b.value.compareTo(a.value));
      
      return scored
          .where((e) => e.value > 0)
          .take(maxThreads)
          .map((e) => e.key)
          .toList();
    } catch (e) {
      print('Fallback search error: $e');
      return [];
    }
  }

  /// Format a journal entry as a context string for AI prompt
  String _formatAsThread(JournalEntry entry) {
    final dateStr = _formatRelativeDate(entry.createdAt);
    final emotion = entry.emotionTag != null ? ' [${entry.emotionTag}]' : '';
    final verseRef = entry.verseReference != null ? ' on ${entry.verseReference}' : '';
    
    // Truncate content if too long
    String content = entry.content;
    if (content.length > maxCharsPerThread) {
      content = '${content.substring(0, maxCharsPerThread)}...';
    }
    
    return 'User reflected$verseRef ($dateStr)$emotion: "$content"';
  }

  /// Format date as relative string (e.g., "2 days ago")
  String _formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) return 'today';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} weeks ago';
    return '${(diff.inDays / 30).floor()} months ago';
  }
}
