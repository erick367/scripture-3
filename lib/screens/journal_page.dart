import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../providers/app_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_constants.dart';
import '../../widgets/cards/mood_selector.dart';

/// Journal Page (Mentor)
/// 
/// Features:
/// - Welcome header with growth score
/// - Quick reflection (mood selector)
/// - AI Insights section
/// - Recent journal entries
class JournalPage extends ConsumerStatefulWidget {
  final VoidCallback? onNewEntry;
  final Function(String entryId)? onEntryTap;

  const JournalPage({
    super.key,
    this.onNewEntry,
    this.onEntryTap,
  });

  @override
  ConsumerState<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends ConsumerState<JournalPage> {
  int? selectedMood;

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(effectiveDarkModeProvider);

    return Scaffold(
      backgroundColor: AppColors.background(isDark),
      body: CustomScrollView(
        slivers: [
          // Safe area
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).padding.top + 16),
          ),

          // Header
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: _buildHeader(isDark),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Quick Reflection Card
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: _buildQuickReflection(isDark),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // AI Insights
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: _buildAIInsights(isDark),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // Recent Entries Header
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Entries',
                    style: AppTextStyles.sectionTitle(
                      color: isDark ? Colors.white : Colors.grey[900],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See All',
                      style: AppTextStyles.bodySmall(
                        color: AppColors.spiritualGold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Journal Entries
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildJournalEntry(
                  mood: '😊',
                  title: 'Grateful for Today',
                  preview: 'Found peace in Psalm 23 this morning...',
                  date: 'Today, 8:30 AM',
                  linkedVerse: 'Psalm 23:4',
                  isDark: isDark,
                ),
                _buildJournalEntry(
                  mood: '🙂',
                  title: 'Reflection on Faith',
                  preview: 'Thinking about what it means to trust...',
                  date: 'Yesterday',
                  linkedVerse: 'Hebrews 11:1',
                  isDark: isDark,
                ),
                _buildJournalEntry(
                  mood: '🤩',
                  title: 'Worship Session',
                  preview: 'Amazing praise time during devotion...',
                  date: '2 days ago',
                  linkedVerse: 'Psalm 150:6',
                  isDark: isDark,
                ),
              ]),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.lightImpact();
          widget.onNewEntry?.call();
        },
        backgroundColor: AppColors.spiritualGold,
        icon: const Icon(LucideIcons.penTool, color: Colors.white),
        label: Text(
          'New Entry',
          style: AppTextStyles.buttonText(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.journalGradient,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              LucideIcons.sparkles,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'JOURNAL',
                  style: AppTextStyles.label(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                Text(
                  'Your Spiritual Journey',
                  style: AppTextStyles.heading2(color: Colors.white),
                ),
              ],
            ),
          ),
          // Growth Score
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '87',
                  style: AppTextStyles.heading1(color: Colors.white),
                ),
                Text(
                  'Growth',
                  style: AppTextStyles.caption(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickReflection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling today?',
            style: AppTextStyles.heading3(
              color: isDark ? Colors.white : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 20),
          MoodSelector(
            selectedMood: selectedMood,
            onMoodSelected: (mood) {
              setState(() => selectedMood = mood);
            },
            isDark: isDark,
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: 'Quick note... (optional)',
              hintStyle: TextStyle(
                color: isDark ? Colors.white38 : Colors.grey[400],
              ),
              filled: true,
              fillColor: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                // Save quick reflection
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.spiritualGold,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Save Reflection'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIInsights(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  AppColors.purple500.withOpacity(0.2),
                  AppColors.blue500.withOpacity(0.2),
                ]
              : [
                  const Color(0xFFF3E8FF),
                  const Color(0xFFEBF8FF),
                ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark
              ? AppColors.purple500.withOpacity(0.3)
              : Colors.purple.shade100,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.purple500, AppColors.blue500],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              LucideIcons.sparkles,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Spiritual Insight',
                  style: AppTextStyles.bodyBold(
                    color: isDark ? Colors.white : Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Based on your recent readings, you might find comfort in Philippians 4:6-7',
                  style: AppTextStyles.bodySmall(
                    color: isDark ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            LucideIcons.chevronRight,
            color: AppColors.purple500,
          ),
        ],
      ),
    );
  }

  Widget _buildJournalEntry({
    required String mood,
    required String title,
    required String preview,
    required String date,
    required String linkedVerse,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onEntryTap?.call(title);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade200,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.spiritualGold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(mood, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyBold(
                          color: isDark ? Colors.white : Colors.grey[900],
                        ),
                      ),
                      Text(
                        date,
                        style: AppTextStyles.caption(
                          color: isDark ? Colors.white38 : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    preview,
                    style: AppTextStyles.bodySmall(
                      color: isDark ? Colors.white60 : Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.spiritualGold.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      linkedVerse,
                      style: AppTextStyles.caption(
                        color: AppColors.spiritualGold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
