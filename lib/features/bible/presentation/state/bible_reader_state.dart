import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/bible_verse.dart';
import '../../data/bible_service.dart';
import '../../../../services/verse_provider_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../journal/presentation/journal_providers.dart'; // For appDatabaseProvider

part 'bible_reader_state.g.dart';

@riverpod
class BibleReaderState extends _$BibleReaderState {
  @override
  BibleReaderStateModel build() {
    return BibleReaderStateModel(
      currentBook: 'John',
      currentChapter: 1,
      isAppliedMode: false,
      currentVersion: 'WEB', // Default loaded
    );
  }

  void setBook(String book) {
    state = state.copyWith(currentBook: book, currentChapter: 1);
  }

  void setChapter(int chapter) {
    state = state.copyWith(currentChapter: chapter);
  }
  
  void setVersion(String version) {
    state = state.copyWith(currentVersion: version);
  }

  void toggleBridgeMode() {
    state = state.copyWith(isAppliedMode: !state.isAppliedMode);
  }
}

class BibleReaderStateModel {
  final String currentBook;
  final int currentChapter;
  final bool isAppliedMode;
  final String currentVersion; // Added

  BibleReaderStateModel({
    required this.currentBook,
    required this.currentChapter,
    required this.isAppliedMode,
    this.currentVersion = 'WEB', // Default
  });

  BibleReaderStateModel copyWith({
    String? currentBook,
    int? currentChapter,
    bool? isAppliedMode,
    String? currentVersion,
  }) {
    return BibleReaderStateModel(
      currentBook: currentBook ?? this.currentBook,
      currentChapter: currentChapter ?? this.currentChapter,
      isAppliedMode: isAppliedMode ?? this.isAppliedMode,
      currentVersion: currentVersion ?? this.currentVersion,
    );
  }
}

@riverpod
Future<BiblePassage> currentPassage(CurrentPassageRef ref) async {
  final state = ref.watch(bibleReaderStateProvider);
  final verseProvider = ref.watch(verseProviderServiceProvider);
  
  // Ensure we wait for BibleService initialization if needed (VerseProvider uses it)
  // But VerseProvider handles fallback gracefully.
  
  return verseProvider.getChapterContent(
    state.currentBook,
    state.currentChapter,
    state.currentVersion,
  );
}

/// Provider for verse references that have journal entries attached
/// Returns a Set<String> of verse reference strings (e.g., "John 1:1")
@riverpod
Stream<Set<String>> reflectedVerses(ReflectedVersesRef ref) async* {
  final db = ref.watch(appDatabaseProvider);
  final entries = await (db.select(db.journalEntries)
      ..where((t) => t.verseReference.isNotNull()))
      .get();
  
  final refs = entries
      .where((e) => e.verseReference != null)
      .map((e) => e.verseReference!)
      .toSet();
  
  yield refs;
}
