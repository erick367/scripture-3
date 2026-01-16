import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Scripture Lens 2.0 - App Providers
/// 
/// Riverpod state management for core app state.

// =============================================================================
// TIME OF DAY
// =============================================================================

enum TimeOfDayPeriod { morning, day, evening, night }

final timeOfDayProvider = StateProvider<TimeOfDayPeriod>((ref) {
  final hour = DateTime.now().hour;
  if (hour >= 5 && hour < 12) return TimeOfDayPeriod.morning;
  if (hour >= 12 && hour < 17) return TimeOfDayPeriod.day;
  if (hour >= 17 && hour < 20) return TimeOfDayPeriod.evening;
  return TimeOfDayPeriod.night;
});

// =============================================================================
// NAVIGATION
// =============================================================================

final currentPageProvider = StateProvider<String>((ref) => 'sanctuary');

// =============================================================================
// DARK MODE
// =============================================================================

final isDarkModeProvider = Provider<bool>((ref) {
  final timeOfDay = ref.watch(timeOfDayProvider);
  return timeOfDay == TimeOfDayPeriod.night;
});

final forceLightModeProvider = StateProvider<bool>((ref) => false);

final effectiveDarkModeProvider = Provider<bool>((ref) {
  final forceLight = ref.watch(forceLightModeProvider);
  if (forceLight) return false;
  return ref.watch(isDarkModeProvider);
});

// =============================================================================
// USER DATA
// =============================================================================

class StreakData {
  final int current;
  final int goal;

  const StreakData({required this.current, required this.goal});

  int get percentage => (current / goal * 100).toInt();
  int get remaining => goal - current;
}

final streakDataProvider = StateProvider<StreakData>((ref) {
  return const StreakData(current: 47, goal: 100);
});

// =============================================================================
// TODAY'S STATS
// =============================================================================

class TodayStats {
  final int chaptersRead;
  final int chaptersGoal;
  final int minutesSpent;
  final int minutesGoal;
  final int goalsAchieved;
  final int goalsTotal;

  const TodayStats({
    required this.chaptersRead,
    required this.chaptersGoal,
    required this.minutesSpent,
    required this.minutesGoal,
    required this.goalsAchieved,
    required this.goalsTotal,
  });
}

final todayStatsProvider = StateProvider<TodayStats>((ref) {
  return const TodayStats(
    chaptersRead: 2,
    chaptersGoal: 5,
    minutesSpent: 23,
    minutesGoal: 30,
    goalsAchieved: 12,
    goalsTotal: 15,
  );
});

// =============================================================================
// VERSE OF THE DAY
// =============================================================================

class VerseOfTheDay {
  final String verse;
  final String reference;
  final String category;

  const VerseOfTheDay({
    required this.verse,
    required this.reference,
    required this.category,
  });
}

final verseOfTheDayProvider = StateProvider<VerseOfTheDay>((ref) {
  return const VerseOfTheDay(
    verse: 'For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.',
    reference: 'Jeremiah 29:11',
    category: 'Hope & Future',
  );
});

// =============================================================================
// PRAYER OF THE DAY
// =============================================================================

class PrayerOfTheDay {
  final String title;
  final String prayer;
  final String theme;

  const PrayerOfTheDay({
    required this.title,
    required this.prayer,
    required this.theme,
  });
}

final prayerOfTheDayProvider = StateProvider<PrayerOfTheDay>((ref) {
  return const PrayerOfTheDay(
    title: 'Prayer for Guidance',
    prayer: 'Lord, guide my steps today. Help me to trust in Your plan even when the path is unclear. Fill me with Your peace and wisdom.',
    theme: 'Guidance',
  );
});

// =============================================================================
// CONTINUE READING
// =============================================================================

class ContinueReadingItem {
  final String book;
  final String chapter;
  final int progress;
  final String nextVerse;
  final int totalVerses;

  const ContinueReadingItem({
    required this.book,
    required this.chapter,
    required this.progress,
    required this.nextVerse,
    required this.totalVerses,
  });
}

final continueReadingProvider = StateProvider<List<ContinueReadingItem>>((ref) {
  return const [
    ContinueReadingItem(
      book: 'Psalms',
      chapter: '23',
      progress: 65,
      nextVerse: 'Continue from Verse 4',
      totalVerses: 6,
    ),
    ContinueReadingItem(
      book: 'Proverbs',
      chapter: '31',
      progress: 40,
      nextVerse: 'Continue from Verse 10',
      totalVerses: 31,
    ),
    ContinueReadingItem(
      book: 'John',
      chapter: '15',
      progress: 25,
      nextVerse: 'Continue from Verse 5',
      totalVerses: 27,
    ),
  ];
});

// =============================================================================
// READING STATE
// =============================================================================

class ReadingContext {
  final String book;
  final int chapter;
  final String? planTitle;

  const ReadingContext({
    required this.book,
    required this.chapter,
    this.planTitle,
  });
}

final readingContextProvider = StateProvider<ReadingContext?>((ref) => null);

// =============================================================================
// FONT SIZE
// =============================================================================

final scriptureFontSizeProvider = StateProvider<double>((ref) => 22.0);
