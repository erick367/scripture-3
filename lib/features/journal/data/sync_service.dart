import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/tables/sync_queue.dart';
import '../../journal/presentation/journal_providers.dart'; // To access database provider if needed

final syncServiceProvider = Provider<SyncService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SyncService(db);
});

class SyncService {
  final AppDatabase _db;
  final SupabaseClient? _supabase;

  SyncService(this._db, [SupabaseClient? supabase]) 
      : _supabase = supabase ?? (Supabase.instance.client);

  /// Processes the Sync Queue
  /// Returns count of successfully processed items
  Future<int> processQueue() async {
    // Skip if Supabase client is not available (e.g. testing)
    if (_supabase == null) return 0;

    // Fetch pending items (PENDING or FAILED)
    // We prioritize PENDING, then FAILED would be retried by logic
    final pendingItems = await (_db.select(_db.syncQueue)
          ..where((t) => t.status.equals(SyncStatus.pending.index) | 
                         t.status.equals(SyncStatus.failed.index))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
          ..limit(10)) 
        .get();

    int successCount = 0;

    for (final item in pendingItems) {
      try {
        // Mark as In Progress
        await _updateStatus(item.id, SyncStatus.inProgress);

        // Perform Operation based on type
        switch (item.operation) {
          case SyncOperation.insert:
          case SyncOperation.update:
            await _syncEntry(item.entityId, item.operation);
            break;
          case SyncOperation.delete:
            await _deleteEntry(item.entityId);
            break;
        }

        // Mark Completed
        await _updateStatus(item.id, SyncStatus.completed);
        successCount++;
      } catch (e) {
        // Mark Failed
        await _updateStatus(item.id, SyncStatus.failed, error: e.toString());
      }
    }

    return successCount;
  }

  Future<void> _updateStatus(int id, SyncStatus status, {String? error}) async {
    await (_db.update(_db.syncQueue)..where((t) => t.id.equals(id))).write(
      SyncQueueCompanion(
        status: Value(status),
        lastError: Value(error),
        lastAttemptAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> _syncEntry(int localId, SyncOperation op) async {
    // 1. Fetch local entry
    final entry = await (_db.select(_db.journalEntries)
          ..where((t) => t.id.equals(localId)))
        .getSingleOrNull();

    if (entry == null) return; // Deleted locally?

    if (!entry.aiAccessEnabled) return; // Privacy check

    // 2. Generate Embedding (Placeholder)
    final embedding = List.filled(1536, 0.0);

    // 3. Upsert to Supabase
    // We use upsert for both Insert and Update to be robust
    await _supabase!.from('journal_entries').upsert({
      'local_id': localId,
      'embedding': embedding,
      'content': entry.content,
      'ai_access_enabled': true,
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'local_id'); 
  }

  Future<void> _deleteEntry(int localId) async {
    await _supabase!.from('journal_entries').delete().eq('local_id', localId);
  }
}
