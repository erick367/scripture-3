import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../journal/presentation/journal_providers.dart';
import '../../discover/application/discovery_feed_service.dart';
import '../../../services/stuck_detector_service.dart';
import '../../../services/prayer_service.dart';
import '../../journal/presentation/spiritual_pulse_provider.dart';

/// Provides a "Daily Fact" for the Home Screen
/// Pulls from the Discovery Feed Service (archaeology/linguistic insights)
final dailyFactProvider = FutureProvider.autoDispose<String>((ref) async {
  final discoveries = await ref.watch(liveArchaeologyProvider.future);
  
  if (discoveries.isEmpty) {
    // Fallback to hardcoded insight
    return "Did you know? In the original Greek, 'Logos' (Word) meant not just speech, but the underlying reason and order of the cosmos.";
  }
  
  // Return the first discovery's description as the daily insight
  return discoveries.first.description;
});

/// Provides the stuck status for the Home Screen
/// Returns null if user is actively progressing
final stuckStatusProvider = FutureProvider.autoDispose<StuckStatus?>((ref) async {
  final stuckService = ref.watch(stuckDetectorServiceProvider);
  return await stuckService.checkIfStuck();
});

/// Provides the theme of the last journal entry for the "Living Card"
final lastJournalThemeProvider = FutureProvider.autoDispose<String?>((ref) async {
  final repo = ref.watch(journalRepositoryProvider);
  
  // We want the most recent entry
  final stream = repo.watchAllEntries();
  final entries = await stream.first;
  
  if (entries.isEmpty) return null;
  
  // Sort by date descending
  final sorted = List.from(entries)..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  final latest = sorted.first;
  
  // Return the Emotion Tag label as the "theme" for now, 
  // or a snippet of content if no emotion tag.
  if (latest.emotionTag != null) {
    // Capitalize first letter just in case
    final tag = latest.emotionTag!;
    return tag.substring(0, 1).toUpperCase() + tag.substring(1);
  } else {
    // Fallback? Maybe just "reflection"
    return "reflection";
  }
});

/// Provides the user's name (Mock for now, or from Auth if available)
final userNameProvider = Provider<String>((ref) {
  // In a real app, this would come from Supabase Auth metadata
  return "Friend"; 
});

/// Provides a daily prayer combining the Daily Insight verse with Spiritual Pulse theme
final dailyPrayerProvider = FutureProvider.autoDispose<String>((ref) async {
  final prayerService = ref.watch(prayerServiceProvider);
  
  // Get the daily insight verse
  final discoveries = await ref.watch(liveArchaeologyProvider.future);
  
  // Get the user's spiritual pulse for theme
  final pulseData = await ref.watch(spiritualPulseProvider.future);
  
  // Extract theme from weekly trend (use dominant emotion)
  String userTheme = 'Seeking';
  if (pulseData.weeklyTrend.isNotEmpty) {
    userTheme = pulseData.weeklyTrend.first.dominantEmotion;
  }
  
  // Use first discovery or fallback
  if (discoveries.isEmpty) {
    return await prayerService.generatePrayer(
      verseText: "In the beginning was the Word, and the Word was with God, and the Word was God.",
      verseReference: "John 1:1",
      userTheme: userTheme,
    );
  }
  
  // Generate prayer from first discovery
  final discovery = discoveries.first;
  return await prayerService.generatePrayer(
    verseText: discovery.description,
    verseReference: discovery.connectedVerse,
    userTheme: userTheme,
  );
});
