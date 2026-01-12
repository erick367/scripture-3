import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import '../features/bible/presentation/state/bible_reader_state.dart';
import '../models/verse_insight.dart';
import 'qwen_service.dart';
import 'verse_provider_service.dart';
import '../features/bible/domain/bible_constants.dart';

// Provider for the UI to consume
final aiChapterPreviewProvider = StateProvider<ChapterPreview?>((ref) => null);

// Service provider that keeps the logic alive
final aiPreloaderServiceProvider = Provider<AiPreloaderService>((ref) {
  final service = AiPreloaderService(ref);
  ref.onDispose(() => service.dispose());
  return service;
});

class AiPreloaderService {
  final Ref _ref;
  Timer? _debounceTimer;
  
  // Cache to prevent re-analyzing the same chapter in one session
  final Map<String, ChapterPreview> _cache = {};

  AiPreloaderService(this._ref) {
    _init();
  }

  void _init() {
    print('⚡ [AiPreloader] Initializing...');
    
    // Listen to Bible Reader State changes using ref.listen
    // This keeps the listener active as long as the service provider is alive
    _ref.listen<BibleReaderStateModel>(
      bibleReaderStateProvider,
      (previous, next) {
        // Debounce logic
        if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
        
        _debounceTimer = Timer(const Duration(seconds: 2), () {
          _analyzeChapter(next.currentBook, next.currentChapter, next.currentVersion);
        });
      },
      fireImmediately: true,
    );
  }

  Future<void> _analyzeChapter(String book, int chapter, String version) async {
    final key = '$book $chapter';
    
    // 1. Check Cache
    if (_cache.containsKey(key)) {
      print('⚡ [AiPreloader] Cache hit for $key');
      _ref.read(aiChapterPreviewProvider.notifier).state = _cache[key];
      return;
    }

    // 2. Clear current preview while loading? 
    // Or keep old one until new one is ready? Let's keep old one to avoid flickering or clear if we want "Loading" state.
    // For "Silent Anticipation", we usually don't clear until we have data, or we verify if the displayed data is stale.
    // Let's clear it to ensure we don't show John 1 insights on John 2.
    _ref.read(aiChapterPreviewProvider.notifier).state = null;

    // 3. Check Qwen Availability
    final qwen = _ref.read(qwenServiceProvider);
    if (!await qwen.canInitialize()) {
      print('⚡ [AiPreloader] Skipping analysis (Qwen unavailable)');
      return;
    }

    print('⚡ [AiPreloader] Starting analysis for $book $chapter...');
    final startTime = DateTime.now();

    try {
      // 4. Get Text Content
      final verseProvider = _ref.read(verseProviderServiceProvider);
      final passage = await verseProvider.getChapterContent(book, chapter, version);
      
      // Limit text to first ~1000 chars to save tokens/time (Qwen context window)
      // or just pick key verses if we had them. For now, use truncation.
      String text = passage.verses.map((v) => v.text).join(' ');
      if (text.length > 1500) text = text.substring(0, 1500) + "...";

      // 5. Generate Insight
      // We want a Core Theme and a Provocative Question.
      final prompt = '''Analyze this Bible chapter ($book $chapter).
Text: "$text"

Task:
1. Identify the "Spiritual Core" (main theme) in 5 words or less.
2. Ask one short "Provocative Question" that challenges the reader to apply this.

Format:
Theme: [The core theme]
Question: [The question]''';

      final response = await qwen.generate(prompt, maxTokens: 60, temperature: 0.7);
      
      // 6. Parse Response
      final lines = response.split('\n');
      String theme = "Grace and Truth";
      String question = "What does this mean for you?";
      
      for (final line in lines) {
        if (line.toLowerCase().startsWith('theme:')) {
          theme = line.substring(6).trim();
        } else if (line.toLowerCase().startsWith('question:')) {
          question = line.substring(9).trim();
        }
      }

      final preview = ChapterPreview(
        book: book,
        chapter: chapter,
        coreTheme: theme,
        provocativeQuestion: question,
      );

      // 7. Update State & Cache
      _cache[key] = preview;
      _ref.read(aiChapterPreviewProvider.notifier).state = preview;
      
      print('⚡ [AiPreloader] Analysis complete in ${DateTime.now().difference(startTime).inMilliseconds}ms');
      
    } catch (e) {
      print('⚡ [AiPreloader] Analysis failed: $e');
    }
  }

  void dispose() {
    _debounceTimer?.cancel();
  }
}
