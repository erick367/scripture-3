import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:math';
import 'tables/journal_entries.dart';
import 'tables/sync_queue.dart';
import 'tables/journal_entries_search.dart';
import 'tables/ai_interactions.dart';
import 'tables/verses.dart';
import 'tables/api_cache.dart';

part 'app_database.g.dart';

/// Main application database with SQLCipher encryption
@DriftDatabase(tables: [JournalEntries, SyncQueue, JournalEntriesSearch, AiInteractions, Verses, ApiCache])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  
  // Test constructor that accepts custom executor
  AppDatabase.forTesting(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Create FTS5 Virtual Table manually
        await _ensureFtsTableCreated(m);
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(aiInteractions);
        }
        if (from < 3) {
          await m.createTable(syncQueue);
        }
        if (from < 4) {
          await m.createTable(verses);
          await m.createTable(apiCache);
        }
        if (from < 5) {
          await customStatement(
            'ALTER TABLE journal_entries ADD COLUMN look_forward_notes TEXT',
          );
        }
      },
    );
  }

  /// Search verses by keyword (simple LIKE for now)
  Future<List<Verse>> searchVerses(String query, {String version = 'WEB'}) {
    return (select(verses)
      ..where((t) => t.content.like('%$query%') & t.version.equals(version))
      ..limit(50)
    ).get();
  }

  /// Fuzzy search for verses (handles typos better)
  /// Uses wildcards and OR conditions to find partial matches
  Future<List<Verse>> searchVersesFuzzy(String query, {String version = 'WEB'}) async {
    // Split query into words for better fuzzy matching
    final words = query.split(' ').where((w) => w.length > 2).toList();
    
    if (words.isEmpty) return [];
    
    // Create OR conditions for each word with wildcards
    final results = await customSelect(
      '''
      SELECT * FROM verses 
      WHERE version = ? 
      AND (${words.map((_) => 'content LIKE ?').join(' OR ')})
      LIMIT 50
      ''',
      variables: [
        Variable(version),
        ...words.map((w) => Variable('%$w%')),
      ],
      readsFrom: {verses},
    ).get();
    
    return results.map((row) => verses.map(row.data)).toList();
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Consent Events
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Insert a consent event into the database
  Future<void> insertConsentEvent({
    required String feature,
    required bool granted,
    String? notes,
  }) async {
    await customInsert(
      '''
      INSERT INTO consent_events (feature, granted, timestamp, notes)
      VALUES (?, ?, ?, ?)
      ''',
      variables: [
        Variable(feature),
        Variable(granted ? 1 : 0),
        Variable(DateTime.now().toIso8601String()),
        Variable(notes),
      ],
    );
  }
  
  /// Get consent events from the database
  Future<List<Map<String, dynamic>>> getConsentEvents({int limit = 50}) async {
    final results = await customSelect(
      '''
      SELECT * FROM consent_events
      ORDER BY timestamp DESC
      LIMIT ?
      ''',
      variables: [Variable(limit)],
    ).get();
    
    return results.map((row) => row.data).toList();
  }
}

/// Opens an encrypted database connection using SQLCipher
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Get the app's documents directory
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'scripture_lens_encrypted.db'));

    // Get or generate encryption key
    const secureStorage = FlutterSecureStorage();
    String? key = await secureStorage.read(key: 'db_encryption_key');

    if (key == null) {
      // Generate a new 64-character hex key for AES-256
      key = _generateEncryptionKey();
      await secureStorage.write(key: 'db_encryption_key', value: key);
    }

    // Open database with SQLCipher encryption
    return NativeDatabase(
      file,
      setup: (database) {
        // Set SQLCipher encryption key (PRAGMA key)
        database.execute('PRAGMA key = "$key"');
        
        // Ensure FTS table exists even if migration was interrupted
        // This is a safety measure to prevent "no such column: journal_entries_search"
        _manualFtsSetup(database);
      },
    );
  });
}

/// Helper to ensure FTS table and triggers exist (Used in onCreate)
Future<void> _ensureFtsTableCreated(Migrator m) async {
  // 1. Drop the standard table Drift might have created
  await m.database.customStatement('DROP TABLE IF EXISTS journal_entries_search');
  
  // 2. Create the actual FTS5 virtual table
  await m.database.customStatement('''
    CREATE VIRTUAL TABLE IF NOT EXISTS journal_entries_search USING fts5(
      content,
      content='journal_entries',
      content_rowid='id'
    );
  ''');

  // 3. Create Triggers to keep FTS in sync with main table
  await m.database.customStatement('''
    CREATE TRIGGER IF NOT EXISTS journal_entries_ai AFTER INSERT ON journal_entries BEGIN
      INSERT INTO journal_entries_search(rowid, content) VALUES (new.id, new.content);
    END;
  ''');
  await m.database.customStatement('''
    CREATE TRIGGER IF NOT EXISTS journal_entries_ad AFTER DELETE ON journal_entries BEGIN
      INSERT INTO journal_entries_search(journal_entries_search, rowid, content) VALUES('delete', old.id, old.content);
    END;
  ''');
  await m.database.customStatement('''
    CREATE TRIGGER IF NOT EXISTS journal_entries_au AFTER UPDATE ON journal_entries BEGIN
      INSERT INTO journal_entries_search(journal_entries_search, rowid, content) VALUES('delete', old.id, old.content);
      INSERT INTO journal_entries_search(rowid, content) VALUES (new.id, new.content);
    END;
  ''');
}

/// Synchronous-like version for NativeDatabase setup
void _manualFtsSetup(dynamic database) {
  try {
    // We use the raw sqlite3 database object here if it's available in setup
    database.execute('''
      CREATE VIRTUAL TABLE IF NOT EXISTS journal_entries_search USING fts5(
        content,
        content='journal_entries',
        content_rowid='id'
      );
    ''');
    
    database.execute('''
      CREATE TRIGGER IF NOT EXISTS journal_entries_ai AFTER INSERT ON journal_entries BEGIN
        INSERT INTO journal_entries_search(rowid, content) VALUES (new.id, new.content);
      END;
    ''');
  } catch (e) {
    print('FTS5 Setup Error: $e');
  }
}

/// Generates a secure 256-bit (64 hex characters) encryption key
String _generateEncryptionKey() {
  final random = Random.secure();
  final bytes = List<int>.generate(32, (_) => random.nextInt(256));
  return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}
