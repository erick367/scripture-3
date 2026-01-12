import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../journal/data/journal_repository.dart';
import '../../journal/presentation/journal_providers.dart'; // Needed for journalRepositoryProvider
import '../../../core/database/app_database.dart';
import '../../../services/ai_mentor_service.dart';
// import '../../bible/presentation/widgets/ai_mentor_panel.dart'; // Removed to avoid circular/duplicate dependency

final homeThreadServiceProvider = Provider<HomeThreadService>((ref) {
  return HomeThreadService(
    ref.watch(journalRepositoryProvider),
    ref.watch(aiMentorServiceProvider),
  );
});

class HomeThreadService {
  final JournalRepository _journalRepo;
  final AiMentorService _aiService;

  HomeThreadService(this._journalRepo, this._aiService);

  /// Retrieves the most relevant journal entry for a follow-up.
  /// Strategy:
  /// 1. Look for recent AI-enabled entries.
  /// 2. Prioritize 'Struggling' or 'Thoughtful' tags.
  /// 3. Returns null if no suitable entry is found.
  Future<JournalEntry?> getTriggerEntry() async {
    // Fetch all entries (In a real app with large DB, we'd use a specific limit query)
    final allEntriesStream = _journalRepo.watchAllEntries();
    final entries = await allEntriesStream.first;

    // Filter: AI Enabled Only
    final aiEntries = entries.where((e) => e.aiAccessEnabled).toList();

    if (aiEntries.isEmpty) return null;

    // Sort by Date Descending
    aiEntries.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Priority Search: 'Struggling' or 'Thoughtful'
    try {
      return aiEntries.firstWhere((e) {
        final tag = e.emotionTag;
        return tag == 'Struggling' || tag == 'Thoughtful';
      });
    } catch (_) {
      // Fallback: Most recent AI entry
      return aiEntries.first;
    }
  }

  /// Generates a personalized follow-up question using AI.
  Future<String> generateFollowUp(JournalEntry entry) async {
    return _aiService.getMentorFollowUp(entry.content);
  }
}
