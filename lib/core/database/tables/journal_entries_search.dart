import 'package:drift/drift.dart';
import 'journal_entries.dart';

/// FTS5 Virtual Table for full-text search on journal entries
/// This table mirrors the content of JournalEntries but optimized for text search
@DataClassName('JournalSearchEntry')
class JournalEntriesSearch extends Table {
  IntColumn get docId => integer().customConstraint('REFERENCES journal_entries(id)')();
  
  // Columns to index
  TextColumn get content => text()();
  
  @override
  Set<Column> get primaryKey => {docId};
  
  @override
  String get tableName => 'journal_entries_search';
}
