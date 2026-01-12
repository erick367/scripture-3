import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../journal/presentation/journal_providers.dart';
import '../../../services/qwen_service.dart';

final themeServiceProvider = Provider<ThemeService>((ref) {
  final journalRepo = ref.watch(journalRepositoryProvider);
  final qwenService = ref.watch(qwenServiceProvider);
  return ThemeService(journalRepo, qwenService);
});

/// Provides the list of top 5 spiritual themes extracted from journal entries
final spiritualThemesProvider = FutureProvider<List<SpiritualTheme>>((ref) async {
  final service = ref.watch(themeServiceProvider);
  return service.getTopThemes();
});

class ThemeService {
  final dynamic _journalRepo; // JournalRepository
  final QwenService _qwenService;

  ThemeService(this._journalRepo, this._qwenService);

  /// Extracts top 5 recurring spiritual themes from last 30 days of AI-enabled entries
  /// Uses Qwen for fast pattern matching (~400ms) instead of Claude
  Future<List<SpiritualTheme>> getTopThemes() async {
    try {
      // 1. Get journal entries
      final entries = await _journalRepo.watchAllEntries().first;
      
      // 2. Filter: Last 30 days + AI enabled
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));
      
      final recentAiEntries = entries.where((e) {
        return e.createdAt.isAfter(thirtyDaysAgo) && e.aiAccessEnabled;
      }).toList();

      if (recentAiEntries.isEmpty) {
        return _getPlaceholderThemes();
      }

      // 3. Build summary for Qwen
      final summaries = recentAiEntries.map((e) => e.content).take(10).join('\n---\n');

      // 4. Try Qwen first for fast theme extraction
      try {
        if (await _qwenService.canInitialize()) {
          final response = await _extractThemesWithQwen(summaries);
          final themes = _parseThemes(response);
          if (themes.isNotEmpty) {
            print('⚡ Qwen theme extraction successful');
            return themes;
          }
        }
      } catch (e) {
        print('⚡ Qwen theme extraction failed: $e');
      }

      // 5. Fallback: Return placeholder themes (no Claude call for theme extraction)
      // Theme extraction is a nice-to-have, not critical enough for Claude API cost
      return _getPlaceholderThemes();
    } catch (e) {
      print('Error getting themes: $e');
      return _getPlaceholderThemes();
    }
  }

  /// Use Qwen for fast structured theme extraction
  Future<String> _extractThemesWithQwen(String summaries) async {
    final prompt = '''Analyze these spiritual journal entries and identify the top 5 recurring themes.

Return ONLY a valid JSON array in this exact format (no other text):
[{"theme": "Patience", "count": 3}, {"theme": "Identity", "count": 2}]

Journal entries:
$summaries

Remember: Return ONLY the JSON array, nothing else.''';

    return await _qwenService.generate(
      prompt,
      maxTokens: 200,
      temperature: 0.3, // Low temp for structured output
    );
  }

  List<SpiritualTheme> _parseThemes(String response) {
    try {
      // Try to extract JSON array from response
      final jsonMatch = RegExp(r'\[.*\]', dotAll: true).firstMatch(response);
      if (jsonMatch == null) return [];
      
      final themes = <SpiritualTheme>[];
      final items = jsonMatch.group(0)!.split('},');
      
      for (var item in items) {
        final themeMatch = RegExp(r'"theme":\s*"([^"]+)"').firstMatch(item);
        final countMatch = RegExp(r'"count":\s*(\d+)').firstMatch(item);
        
        if (themeMatch != null) {
          themes.add(SpiritualTheme(
            name: themeMatch.group(1)!,
            frequency: int.tryParse(countMatch?.group(1) ?? '1') ?? 1,
          ));
        }
      }
      
      return themes;
    } catch (e) {
      print('Error parsing themes: $e');
      return [];
    }
  }

  List<SpiritualTheme> _getPlaceholderThemes() {
    return [
      SpiritualTheme(name: 'Patience', frequency: 3),
      SpiritualTheme(name: 'Identity', frequency: 2),
      SpiritualTheme(name: 'Trust', frequency: 2),
      SpiritualTheme(name: 'Work-Rest', frequency: 1),
      SpiritualTheme(name: 'Gratitude', frequency: 1),
    ];
  }
}

class SpiritualTheme {
  final String name;
  final int frequency;

  SpiritualTheme({required this.name, required this.frequency});
}
