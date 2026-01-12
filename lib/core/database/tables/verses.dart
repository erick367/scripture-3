import 'package:drift/drift.dart';

/// Table for storing bundled and cached Bible verses
/// Supports multiple translations with offline-first approach
class Verses extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  /// Translation code (e.g., 'WEB', 'KJV', 'BSB', 'RV1909', 'GNBUK')
  TextColumn get version => text()();
  
  /// Book name (e.g., 'Genesis', 'John')
  TextColumn get book => text()();
  
  /// Chapter number (1-indexed)
  IntColumn get chapter => integer()();
  
  /// Verse number (1-indexed)
  IntColumn get verse => integer()();
  
  /// Verse text content (renamed from 'text' to avoid Drift naming conflict)
  TextColumn get content => text()();
  
  /// True if bundled with app, false if fetched from API
  BoolColumn get isBundled => boolean().withDefault(const Constant(true))();
  
  /// Timestamp when fetched from API (null for bundled)
  /// Used for 30-day expiry check on copyrighted content
  DateTimeColumn get lastFetched => dateTime().nullable()();
  
  @override
  List<Set<Column>> get uniqueKeys => [
    {version, book, chapter, verse}, // Unique constraint
  ];
}

