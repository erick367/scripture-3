import '../../../core/database/app_database.dart';
import '../../../core/database/tables/sync_queue.dart';
import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/look_forward_note.dart';
import 'sync_service.dart'; // Import SyncService definition

/// Repository for managing journal entries with local-first, encrypted storage
class JournalRepository {
  final AppDatabase _db;
  SupabaseClient? _supabase;

  JournalRepository(this._db) {
    try {
      _supabase = Supabase.instance.client;
    } catch (e) {
      // Supabase not initialized (testing mode)
      _supabase = null;
    }
  }

  // ===== CREATE =====

  /// Saves a new journal entry to the encrypted local database
  /// If [aiAccessEnabled] is true, syncs embedding to Supabase for AI context
  Future<int> saveEntry({
    required String content,
    required bool aiAccessEnabled,
    String? verseReference,
    String? emotionTag,
  }) async {
    final entry = JournalEntriesCompanion(
      content: Value(content),
      aiAccessEnabled: Value(aiAccessEnabled),
      verseReference: Value(verseReference),
      emotionTag: Value(emotionTag),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );

    final id = await _db.into(_db.journalEntries).insert(entry);

    // If AI access is enabled, add to sync queue (Outbox Pattern)
    if (aiAccessEnabled) {
      await _addToSyncQueue(SyncOperation.insert, id);
    }

    return id;
  }

  // ===== READ =====

  /// Watch all journal entries as a stream (for reactive UI)
  /// Ordered by most recent first
  Stream<List<JournalEntry>> watchAllEntries() {
    return (_db.select(_db.journalEntries)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Get a single journal entry by ID
  Future<JournalEntry?> getEntry(int id) {
    return (_db.select(_db.journalEntries)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Get entries filtered by emotion tag
  Stream<List<JournalEntry>> watchEntriesByEmotion(String emotionTag) {
    return (_db.select(_db.journalEntries)
          ..where((t) => t.emotionTag.equals(emotionTag))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Get entries filtered by verse reference
  Stream<List<JournalEntry>> watchEntriesByVerse(String verseReference) {
    return (_db.select(_db.journalEntries)
          ..where((t) => t.verseReference.equals(verseReference))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  // ===== UPDATE =====

  /// Updates an existing journal entry
  Future<void> updateEntry(
    int id, {
    String? content,
    String? emotionTag,
    bool? aiAccessEnabled,
  }) async {
    await (_db.update(_db.journalEntries)..where((t) => t.id.equals(id)))
        .write(JournalEntriesCompanion(
      content: content != null ? Value(content) : const Value.absent(),
      emotionTag: emotionTag != null ? Value(emotionTag) : const Value.absent(),
      aiAccessEnabled:
          aiAccessEnabled != null ? Value(aiAccessEnabled) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    ));

    // If AI access was enabled and content changed, re-sync embedding
    if (aiAccessEnabled == true && content != null) {
      await _addToSyncQueue(SyncOperation.update, id);
    }
  }

  /// Appends a Look Forward note to an existing journal entry
  Future<void> addLookForwardNote({
    required int entryId,
    required String question,
    required String note,
    required String theme,
  }) async {
    // 1. Fetch current entry
    final entry = await getEntry(entryId);
    if (entry == null) return;

    // 2. Parse existing notes
    final existingNotes = LookForwardNote.parseList(entry.lookForwardNotes);
    
    // 3. Add new note
    final newNote = LookForwardNote(
      createdAt: DateTime.now(),
      question: question,
      note: note,
      theme: theme,
    );
    existingNotes.add(newNote);

    // 4. Update entry
    await (_db.update(_db.journalEntries)..where((t) => t.id.equals(entryId)))
        .write(JournalEntriesCompanion(
      lookForwardNotes: Value(LookForwardNote.encodeList(existingNotes)),
      updatedAt: Value(DateTime.now()),
    ));

    // Optional: Re-sync embedding if notes should influence AI memory
    if (entry.aiAccessEnabled) {
      await _addToSyncQueue(SyncOperation.update, entryId);
    }
  }

  // ===== DELETE =====

  /// Deletes a journal entry from local database
  Future<void> deleteEntry(int id) async {
    await (_db.delete(_db.journalEntries)..where((t) => t.id.equals(id))).go();
    // Queue delete operation for sync
    await _addToSyncQueue(SyncOperation.delete, id);
  }

  // ===== SEARCH (FTS5) =====

  /// Searches journal entries using Full Text Search (FTS5)
  /// Returns matches ranked by relevance
  Future<List<JournalEntry>> searchEntries(String query) async {
    // We use a custom query to join the virtual FTS table with the real table
    // rank is a hidden column in FTS5 representing relevance
    final results = await _db.customSelect(
      '''
      SELECT e.* 
      FROM journal_entries_fts fts
      JOIN journal_entries e ON e.id = fts.rowid
      WHERE fts.content MATCH ?
      ORDER BY fts.rank
      ''',
      variables: [Variable.withString(query)],
      readsFrom: {_db.journalEntries}, // No table object for FTS, so we assume reads from main table too
    ).get();

    return results.map((row) {
      return _db.journalEntries.map(row.data);
    }).toList();
  }

  /// Adds an operation to the Sync Queue (Outbox Pattern)
  Future<void> _addToSyncQueue(SyncOperation op, int id) async {
    await _db.into(_db.syncQueue).insert(SyncQueueCompanion(
      operation: Value(op),
      entityTable: const Value('journal_entries'),
      entityId: Value(id),
      status: const Value(SyncStatus.pending),
      createdAt: Value(DateTime.now()),
    ));
    
    // Trigger background sync (fire and forget)
    // Ideally we inject SyncService, but for now we can instantate it or use a callback mechanism
    // Since JournalRepository is a humble object, let's instantiate SyncService on demand for the trigger
    // This is safe because SyncService is stateless except for DB reference
    try {
      final syncService = SyncService(_db);
      syncService.processQueue();
    } catch (e) {
      print('Failed to trigger background sync: $e');
    }
  }
}
