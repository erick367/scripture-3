import 'package:drift/drift.dart';

/// Cache table for API-fetched Bible verses (licensed versions)
/// Implements 30-day expiry for compliance with API terms
class ApiCache extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  /// Unique cache key format: 'VERSION:BOOK.CHAPTER.VERSE' (e.g., 'GNBUK:GEN.1.1')
  TextColumn get cacheKey => text().unique()();
  
  /// Cached content (verse text or passage)
  TextColumn get content => text()();
  
  /// When this content was fetched from API
  DateTimeColumn get fetchedAt => dateTime()();
  
  /// Optional: API response metadata (JSON)
  TextColumn get metadata => text().nullable()();
}
