import '../models/verse.dart';

/// Domain interface for Bible data access
/// 
/// Abstracts local bundled Bible and optional cloud sync.
abstract class BibleRepository {
  /// Get a specific verse by reference
  /// 
  /// [version] defaults to 'WEB' (World English Bible)
  Future<Verse?> getVerse(String book, int chapter, int verse, {String version = 'WEB'});
  
  /// Get all verses for a chapter
  Future<List<Verse>> getChapter(String book, int chapter, {String version = 'WEB'});
  
  /// Search verses by keyword (simple LIKE query)
  Future<List<Verse>> searchVerses(String query, {String version = 'WEB', int limit = 50});
  
  /// Fuzzy search for verses (handles typos)
  Future<List<Verse>> searchVersesFuzzy(String query, {String version = 'WEB', int limit = 50});
  
  /// Get list of all books
  List<String> getBooks();
  
  /// Get chapter count for a book
  int getChapterCount(String book);
  
  /// Get verse count for a chapter
  Future<int> getVerseCount(String book, int chapter, {String version = 'WEB'});
  
  /// Check if Bible data is loaded
  Future<bool> isLoaded();
  
  /// Preload Bible data from bundled assets
  Future<void> preload();
}
