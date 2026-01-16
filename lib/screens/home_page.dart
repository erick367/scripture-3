import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/cards/dynamic_island_header.dart';
import '../../widgets/cards/spiritual_carousel.dart';
import '../../widgets/cards/streak_card.dart';
import '../../widgets/cards/continue_reading_card.dart';
import '../../widgets/progress/circular_progress.dart';

/// Home Page (Sanctuary)
/// 
/// Layout:
/// 1. Dynamic Island Header
/// 2. Spiritual Carousel (Verse/Prayer)
/// 3. Streak Card (Giant Number)
/// 4. Today's Activity (3 Circles)
/// 5. Continue Reading (Horizontal Scroll)
class HomePage extends ConsumerWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final Function(String book, int chapter)? onContinueReading;

  const HomePage({
    super.key,
    this.onSearchTap,
    this.onProfileTap,
    this.onNotificationTap,
    this.onContinueReading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(effectiveDarkModeProvider);
    final streak = ref.watch(streakDataProvider);
    final verse = ref.watch(verseOfTheDayProvider);
    final prayer = ref.watch(prayerOfTheDayProvider);
    final todayStats = ref.watch(todayStatsProvider);
    final continueReading = ref.watch(continueReadingProvider);

    return Scaffold(
      backgroundColor: AppColors.background(isDark),
      body: Stack(
        children: [
          // Ambient Background Orbs
          _buildAmbientOrbs(isDark),

          // Main Content
          CustomScrollView(
            slivers: [
              // Safe area padding
              SliverToBoxAdapter(
                child: SizedBox(height: MediaQuery.of(context).padding.top + 16),
              ),

              // 1. Dynamic Island Header
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: DynamicIslandHeader(
                    greeting: AppTheme.getGreeting(),
                    userName: 'Erick',
                    notificationCount: 3,
                    onProfileTap: onProfileTap ?? () {},
                    onSearchTap: onSearchTap ?? () {},
                    onNotificationTap: onNotificationTap ?? () {},
                    isDark: isDark,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // 2. Spiritual Carousel
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: SpiritualCarousel(
                    verse: verse.verse,
                    verseReference: verse.reference,
                    verseCategory: verse.category,
                    prayerTitle: prayer.title,
                    prayer: prayer.prayer,
                    prayerTheme: prayer.theme,
                    onVerseReadMore: () {
                      // Navigate to verse in reader
                    },
                    isDark: isDark,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // 3. Streak Card
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: StreakCard(
                    currentStreak: streak.current,
                    goalStreak: streak.goal,
                    isDark: isDark,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // 4. Today's Activity
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: TodayActivityRow(
                    chaptersRead: todayStats.chaptersRead,
                    chaptersGoal: todayStats.chaptersGoal,
                    minutesSpent: todayStats.minutesSpent,
                    minutesGoal: todayStats.minutesGoal,
                    goalsAchieved: todayStats.goalsAchieved,
                    goalsTotal: todayStats.goalsTotal,
                    isDark: isDark,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // 5. Continue Reading
              SliverToBoxAdapter(
                child: ContinueReadingSection(
                  items: continueReading.map((item) => ContinueReadingCardData(
                    book: item.book,
                    chapter: item.chapter,
                    progress: item.progress,
                    nextVerse: item.nextVerse,
                    totalVerses: item.totalVerses,
                  )).toList(),
                  onCardTap: (index) {
                    final item = continueReading[index];
                    onContinueReading?.call(item.book, int.parse(item.chapter));
                  },
                  isDark: isDark,
                ),
              ),

              // Bottom padding for navigation
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmbientOrbs(bool isDark) {
    if (!isDark) return const SizedBox.shrink();

    return Stack(
      children: [
        // Orange/Pink orb - top left
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppColors.orange500.withOpacity(0.15),
                  AppColors.pink500.withOpacity(0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Blue/Cyan orb - top right
        Positioned(
          top: 100,
          right: -80,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppColors.blue500.withOpacity(0.12),
                  AppColors.cyan500.withOpacity(0.04),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Purple orb - middle
        Positioned(
          top: 400,
          left: 50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppColors.purple500.withOpacity(0.10),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
