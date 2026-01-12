import 'package:drift/drift.dart';

/// Journal entries table with encryption support
class JournalEntries extends Table {
  /// Auto-increment primary key
  IntColumn get id => integer().autoIncrement()();
  
  /// Optional Bible verse reference (e.g., "John 3:16")
  TextColumn get verseReference => text().nullable()();
  
  /// The actual journal entry content (will be encrypted at rest)
  TextColumn get content => text()();
  
  /// User-selected emotion tag (e.g., "Grateful", "Hopeful")
  TextColumn get emotionTag => text().nullable()();
  
  /// Whether this entry should be used for AI context (memory)
  BoolColumn get aiAccessEnabled => boolean().withDefault(const Constant(false))();
  
  /// When the entry was created
  DateTimeColumn get createdAt => dateTime()();
  
  /// When the entry was last updated
  DateTimeColumn get updatedAt => dateTime()();
  
  /// JSON array of Look Forward notes (action items from mentorship sessions)
  /// Format: [{"createdAt":"ISO8601","question":"...","note":"...","theme":"..."}]
  TextColumn get lookForwardNotes => text().nullable()();
}
