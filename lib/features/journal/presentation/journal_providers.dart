import '../../../core/database/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/journal_repository.dart';

part 'journal_providers.g.dart';

/// Provides the app database instance
@riverpod
AppDatabase appDatabase(AppDatabaseRef ref) {
  return AppDatabase();
}

/// Provides the journal repository
@riverpod
JournalRepository journalRepository(JournalRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return JournalRepository(db);
}

/// Stream of all journal entries (reactive)
@riverpod
Stream<List<JournalEntry>> journalEntries(JournalEntriesRef ref) {
  final repo = ref.watch(journalRepositoryProvider);
  return repo.watchAllEntries();
}
