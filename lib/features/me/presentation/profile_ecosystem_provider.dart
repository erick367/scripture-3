import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../journal/presentation/journal_providers.dart';
import '../../../services/qwen_service.dart';
import '../../../core/utils/pulse_mapper.dart';

part 'profile_ecosystem_provider.g.dart';

@riverpod
Future<String> soulSphereState(SoulSphereStateRef ref) async {
  final entries = await ref.watch(journalEntriesProvider.future);
  final qwen = ref.watch(qwenServiceProvider);
  
  if (entries.isEmpty) return 'Peaceful';
  
  final scores = entries.take(7).map((e) => PulseMapper.getPulseValue(e.emotionTag)).toList();
  return await qwen.getGeometryState(scores);
}

@riverpod
Future<String> journeySummary(JourneySummaryRef ref) async {
  final entries = await ref.watch(journalEntriesProvider.future);
  final qwen = ref.watch(qwenServiceProvider);
  
  if (entries.isEmpty) return 'Begin your journey with a reflection.';
  
  final contents = entries.take(5).map((e) => e.content).toList();
  return await qwen.getJourneySummary(contents);
}

@riverpod
class AnsweredPrayerCount extends _$AnsweredPrayerCount {
  @override
  Future<int> build() async {
    final entries = await ref.watch(journalEntriesProvider.future);
    
    // Scan for "Thankful", "Answered", "Praise" keywords
    // In a real app, this would be more sophisticated (NLP based)
    final keywords = ['thankful', 'answered', 'praise', 'gratitude', 'amen'];
    int count = 0;
    
    for (var entry in entries) {
      final content = entry.content.toLowerCase();
      if (keywords.any((k) => content.contains(k))) {
        count++;
      }
    }
    
    return count;
  }
}
