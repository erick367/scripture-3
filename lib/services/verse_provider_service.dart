import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../core/database/app_database.dart';
import '../features/journal/presentation/journal_providers.dart';
import '../features/bible/data/bible_service.dart';
import '../features/bible/domain/bible_verse.dart';
import 'package:drift/drift.dart';

final verseProviderServiceProvider = Provider<VerseProviderService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final bibleService = ref.watch(bibleServiceProvider.notifier);
  return VerseProviderService(db, bibleService);
});

/// Unified verse content provider
/// Abstracts the data source (bundled DB, cache, or API) from consumers
class VerseProviderService {
  final AppDatabase _db;
  final BibleService _bibleService;
  
  // Bundled translations (available offline)
  static const List<String> bundledVersions = ['WEB', 'KJV', 'BSB', 'RV1909'];
  
  // API-only translations (require network)
  static const List<String> apiOnlyVersions = ['GNBUK', 'NIV', 'ESV'];
  
  VerseProviderService(this._db, this._bibleService);

  /// Get verse content from the best available source
  /// Priority: Bundled DB → API Cache → Live API
  Future<String?> getVerseContent(String reference, String version) async {
    // 1. Try bundled database first
    final bundledVerse = await _getFromBundled(reference, version);
    if (bundledVerse != null) {
      return bundledVerse;
    }
    
    // 2. Check API cache (with 30-day expiry)
    final cachedVerse = await _getFromCache(reference, version);
    if (cachedVerse != null) {
      return cachedVerse;
    }
    
    // 3. Fetch from API if online
    if (await _isOnline()) {
      return await _fetchFromApi(reference, version);
    }
    
    return null; // Offline and no cached data
  }

  /// Check if a version is available offline
  bool isOfflineAvailable(String version) {
    return bundledVersions.contains(version.toUpperCase());
  }

  Future<String?> _getFromBundled(String reference, String version) async {
    try {
      final parsed = _parseReference(reference);
      if (parsed == null) return null;
      
      final result = await (_db.select(_db.verses)
        ..where((v) => v.version.equals(version.toUpperCase()))
        ..where((v) => v.book.equals(parsed['book']!))
        ..where((v) => v.chapter.equals(int.parse(parsed['chapter']!)))
        ..where((v) => v.verse.equals(int.parse(parsed['verse']!))))
        .getSingleOrNull();
      
      return result?.content;
    } catch (e) {
      return null;
    }
  }

  Future<String?> _getFromCache(String reference, String version) async {
    try {
      final cacheKey = '$version:$reference';
      final cached = await (_db.select(_db.apiCache)
        ..where((c) => c.cacheKey.equals(cacheKey)))
        .getSingleOrNull();
      
      if (cached == null) return null;
      
      // Check 30-day expiry for copyrighted content
      final expiryDate = cached.fetchedAt.add(const Duration(days: 30));
      if (DateTime.now().isAfter(expiryDate)) {
        // Expired, delete and return null
        await (_db.delete(_db.apiCache)
          ..where((c) => c.cacheKey.equals(cacheKey)))
          .go();
        return null;
      }
      
      return cached.content;
    } catch (e) {
      return null;
    }
  }

  Future<String?> _fetchFromApi(String reference, String version) async {
    try {
      // Use existing BibleService for API calls
      final parsed = _parseReference(reference);
      if (parsed == null) return null;
      
      final passage = await _bibleService.getPassage(
        parsed['book']!,
        int.parse(parsed['chapter']!),
      );
      
      final verse = passage.verses.firstWhere(
        (v) => v.verse == int.parse(parsed['verse']!),
        orElse: () => throw Exception('Verse not found'),
      );
      
      // Cache the result
      final cacheKey = '$version:$reference';
      await _db.into(_db.apiCache).insert(
        ApiCacheCompanion.insert(
          cacheKey: cacheKey,
          content: verse.text,
          fetchedAt: DateTime.now(),
        ),
        mode: InsertMode.insertOrReplace,
      );
      
      return verse.text;
    } catch (e) {
      return null;
    }
  }



  /// Get full chapter content
  /// Priority: Bundled DB → API Cache → Live API
  Future<BiblePassage> getChapterContent(String book, int chapter, String version) async {
    // 1. Try bundled database first
    final bundledVerses = await _getChapterFromBundled(book, chapter, version);
    if (bundledVerses.isNotEmpty) {
      return BiblePassage(book: book, chapter: chapter, verses: bundledVerses);
    }
    
    // 2. Check API cache (Not efficiently implemented for chapters yet, skips to API)
    
    // 3. Fetch from API if online
    if (await _isOnline()) {
      return await _fetchChapterFromApi(book, chapter, version);
    }
    
    return BiblePassage(book: book, chapter: chapter, verses: []); // Offline and no data
  }

  Future<List<BibleVerse>> _getChapterFromBundled(String book, int chapter, String version) async {
    try {
      final results = await (_db.select(_db.verses)
        ..where((v) => v.version.equals(version.toUpperCase()))
        ..where((v) => v.book.equals(book))
        ..where((v) => v.chapter.equals(chapter))
        ..orderBy([(v) => OrderingTerm(expression: v.verse)]))
        .get();
      
      return results.map((v) => BibleVerse(
        book: v.book,
        chapter: v.chapter,
        verse: v.verse,
        text: v.content,
      )).toList();
    } catch (e) {
      print('Error fetching bundled chapter: $e');
      return [];
    }
  }

  Future<BiblePassage> _fetchChapterFromApi(String book, int chapter, String version) async {
    try {
      // Note: Ideally pass 'version' to BibleService. 
      // For now, it uses the default API version.
      return await _bibleService.getPassage(book, chapter);
    } catch (e) {
       print('Error fetching API chapter: $e');
      return BiblePassage(book: book, chapter: chapter, verses: []);
    }
  }

  Future<bool> _isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  Map<String, String>? _parseReference(String reference) {
    // Parse "John 3:16" → {book: "John", chapter: "3", verse: "16"}
    final match = RegExp(r'^(.+?)\s*(\d+):(\d+)$').firstMatch(reference);
    if (match == null) return null;
    
    return {
      'book': match.group(1)!.trim(),
      'chapter': match.group(2)!,
      'verse': match.group(3)!,
    };
  }
}
