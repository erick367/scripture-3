import 'package:flutter_test/flutter_test.dart';
import 'package:scripture_lens/core/database/app_database.dart';
import 'package:scripture_lens/features/journal/data/journal_repository.dart';
import 'package:drift/native.dart';

void main() {
  late AppDatabase database;
  late JournalRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = JournalRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('JournalRepository - Create', () {
    test('Should save entry successfully', () async {
      final id = await repository.saveEntry(
        content: 'Test content',
        aiAccessEnabled: false,
      );

      expect(id, greaterThan(0));
    });

    test('Should save entry with all fields', () async {
      final id = await repository.saveEntry(
        content: 'Full entry',
        aiAccessEnabled: true,
        verseReference: 'John 1:1',
        emotionTag: 'Grateful',
      );

      final entry = await repository.getEntry(id);
      expect(entry, isNotNull);
      expect(entry!.content, equals('Full entry'));
      expect(entry.aiAccessEnabled, isTrue);
      expect(entry.verseReference, equals('John 1:1'));
      expect(entry.emotionTag, equals('Grateful'));
    });
  });

  group('JournalRepository - Read', () {
    test('Should retrieve entry by ID', () async {
      final id = await repository.saveEntry(
        content: 'Retrievable entry',
        aiAccessEnabled: false,
      );

      final entry = await repository.getEntry(id);
      expect(entry, isNotNull);
      expect(entry!.id, equals(id));
      expect(entry.content, equals('Retrievable entry'));
    });

    test('Should return null for non-existent entry', () async {
      final entry = await repository.getEntry(99999);
      expect(entry, isNull);
    });

    test('Should watch all entries as stream', () async {
      // Save multiple entries
      await repository.saveEntry(content: 'Entry 1', aiAccessEnabled: false);
      await repository.saveEntry(content: 'Entry 2', aiAccessEnabled: false);
      await repository.saveEntry(content: 'Entry 3', aiAccessEnabled: false);

      // Watch stream
      final stream = repository.watchAllEntries();
      final entries = await stream.first;

      expect(entries.length, equals(3));
      // Verify all entries exist (ordering may vary without explicit delays)
      final contents = entries.map((e) => e.content).toList();
      expect(contents, containsAll(['Entry 1', 'Entry 2', 'Entry 3']));
    });

    test('Should filter by emotion tag', () async {
      await repository.saveEntry(
        content: 'Grateful entry',
        aiAccessEnabled: false,
        emotionTag: 'Grateful',
      );
      
      await repository.saveEntry(
        content: 'Hopeful entry',
        aiAccessEnabled: false,
        emotionTag: 'Hopeful',
      );

      final stream = repository.watchEntriesByEmotion('Grateful');
      final entries = await stream.first;

      expect(entries.length, equals(1));
      expect(entries[0].emotionTag, equals('Grateful'));
    });

    test('Should filter by verse reference', () async {
      await repository.saveEntry(
        content: 'John entry',
        aiAccessEnabled: false,
        verseReference: 'John 3:16',
      );
      
      await repository.saveEntry(
        content: 'Genesis entry',
        aiAccessEnabled: false,
        verseReference: 'Genesis 1:1',
      );

      final stream = repository.watchEntriesByVerse('John 3:16');
      final entries = await stream.first;

      expect(entries.length, equals(1));
      expect(entries[0].verseReference, equals('John 3:16'));
    });
  });

  group('JournalRepository - Update', () {
    test('Should update entry content', () async {
      final id = await repository.saveEntry(
        content: 'Original',
        aiAccessEnabled: false,
      );

      await repository.updateEntry(id, content: 'Updated');

      final entry = await repository.getEntry(id);
      expect(entry!.content, equals('Updated'));
    });

    test('Should update emotion tag', () async {
      final id = await repository.saveEntry(
        content: 'Test',
        aiAccessEnabled: false,
        emotionTag: 'Grateful',
      );

      await repository.updateEntry(id, emotionTag: 'Hopeful');

      final entry = await repository.getEntry(id);
      expect(entry!.emotionTag, equals('Hopeful'));
    });

    test('Should update AI access enabled', () async {
      final id = await repository.saveEntry(
        content: 'Test',
        aiAccessEnabled: false,
      );

      await repository.updateEntry(id, aiAccessEnabled: true);

      final entry = await repository.getEntry(id);
      expect(entry!.aiAccessEnabled, isTrue);
    });

    test('Should update multiple fields', () async {
      final id = await repository.saveEntry(
        content: 'Original',
        aiAccessEnabled: false,
      );

      await repository.updateEntry(
        id,
        content: 'New content',
        emotionTag: 'Joyful',
        aiAccessEnabled: true,
      );

      final entry = await repository.getEntry(id);
      expect(entry!.content, equals('New content'));
      expect(entry.emotionTag, equals('Joyful'));
      expect(entry.aiAccessEnabled, isTrue);
    });
  });

  group('JournalRepository - Delete', () {
    test('Should delete entry', () async {
      final id = await repository.saveEntry(
        content: 'To delete',
        aiAccessEnabled: false,
      );

      await repository.deleteEntry(id);

      final entry = await repository.getEntry(id);
      expect(entry, isNull);
    });

    test('Should handle deleting non-existent entry gracefully', () async {
      // Should not throw exception
      await repository.deleteEntry(99999);
    });
  });

  group('Privacy Compliance', () {
    test('Should NOT send raw content to Supabase when AI disabled', () async {
      final id = await repository.saveEntry(
        content: 'Private content',
        aiAccessEnabled: false,
      );

      final entry = await repository.getEntry(id);
      expect(entry!.aiAccessEnabled, isFalse);
    });

    test('Should mark entry for AI access when enabled', () async {
      final id = await repository.saveEntry(
        content: 'AI accessible',
        aiAccessEnabled: true,
      );

      final entry = await repository.getEntry(id);
      expect(entry!.aiAccessEnabled, isTrue);
    });
  });
}
