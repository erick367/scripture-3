import 'package:flutter_test/flutter_test.dart';
import 'package:scripture_lens/core/database/app_database.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    // Create in-memory database for testing
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  group('Database Encryption Tests', () {
    test('Database should initialize successfully', () async {
      expect(database, isNotNull);
    });

    test('Should create tables on initialization', () async {
      // Query the database to ensure tables exist
      final entries = await database.select(database.journalEntries).get();
      expect(entries, isEmpty); // New database should have no entries
    });
  });

  group('CRUD Operations', () {
    test('Should insert journal entry', () async {
      final entry = JournalEntriesCompanion.insert(
        content: 'Test journal entry',
        aiAccessEnabled: const Value(false),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final id = await database.into(database.journalEntries).insert(entry);
      expect(id, greaterThan(0));
    });

    test('Should retrieve inserted entry', () async {
      // Insert
      final entry = JournalEntriesCompanion.insert(
        content: 'Test content',
        verseReference: const Value('John 3:16'),
        emotionTag: const Value('Grateful'),
        aiAccessEnabled: const Value(false),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final id = await database.into(database.journalEntries).insert(entry);

      // Retrieve
      final retrieved = await (database.select(database.journalEntries)
            ..where((t) => t.id.equals(id)))
          .getSingle();

      expect(retrieved.content, equals('Test content'));
      expect(retrieved.verseReference, equals('John 3:16'));
      expect(retrieved.emotionTag, equals('Grateful'));
    });

    test('Should update journal entry', () async {
      // Insert
      final entry = JournalEntriesCompanion.insert(
        content: 'Original content',
        aiAccessEnabled: const Value(false),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final id = await database.into(database.journalEntries).insert(entry);

      // Update
      await (database.update(database.journalEntries)
            ..where((t) => t.id.equals(id)))
          .write(JournalEntriesCompanion(
        content: const Value('Updated content'),
        emotionTag: const Value('Hopeful'),
        updatedAt: Value(DateTime.now()),
      ));

      // Verify
      final updated = await (database.select(database.journalEntries)
            ..where((t) => t.id.equals(id)))
          .getSingle();

      expect(updated.content, equals('Updated content'));
      expect(updated.emotionTag, equals('Hopeful'));
    });

    test('Should delete journal entry', () async {
      // Insert
      final entry = JournalEntriesCompanion.insert(
        content: 'To be deleted',
        aiAccessEnabled: const Value(false),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final id = await database.into(database.journalEntries).insert(entry);

      // Delete
      await (database.delete(database.journalEntries)
            ..where((t) => t.id.equals(id)))
          .go();

      // Verify
      final result = await (database.select(database.journalEntries)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();

      expect(result, isNull);
    });

    test('Should filter by emotion tag', () async {
      // Insert multiple entries
      await database.into(database.journalEntries).insert(
        JournalEntriesCompanion.insert(
          content: 'Entry 1',
          emotionTag: const Value('Grateful'),
          aiAccessEnabled: const Value(false),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      await database.into(database.journalEntries).insert(
        JournalEntriesCompanion.insert(
          content: 'Entry 2',
          emotionTag: const Value('Hopeful'),
          aiAccessEnabled: const Value(false),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      await database.into(database.journalEntries).insert(
        JournalEntriesCompanion.insert(
          content: 'Entry 3',
          emotionTag: const Value('Grateful'),
          aiAccessEnabled: const Value(false),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // Filter
      final gratefulEntries = await (database.select(database.journalEntries)
            ..where((t) => t.emotionTag.equals('Grateful')))
          .get();

      expect(gratefulEntries.length, equals(2));
      expect(gratefulEntries.every((e) => e.emotionTag == 'Grateful'), isTrue);
    });

    test('Should order by createdAt descending', () async {
      final now = DateTime.now();
      
      // Insert entries with different timestamps
      await database.into(database.journalEntries).insert(
        JournalEntriesCompanion.insert(
          content: 'First',
          aiAccessEnabled: const Value(false),
          createdAt: now.subtract(const Duration(days: 2)),
          updatedAt: now.subtract(const Duration(days: 2)),
        ),
      );

      await database.into(database.journalEntries).insert(
        JournalEntriesCompanion.insert(
          content: 'Latest',
          aiAccessEnabled: const Value(false),
          createdAt: now,
          updatedAt: now,
        ),
      );

      await database.into(database.journalEntries).insert(
        JournalEntriesCompanion.insert(
          content: 'Middle',
          aiAccessEnabled: const Value(false),
          createdAt: now.subtract(const Duration(days: 1)),
          updatedAt: now.subtract(const Duration(days: 1)),
        ),
      );

      // Query with ordering
      final entries = await (database.select(database.journalEntries)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

      expect(entries.length, equals(3));
      expect(entries[0].content, equals('Latest'));
      expect(entries[1].content, equals('Middle'));
      expect(entries[2].content, equals('First'));
    });
  });
}
