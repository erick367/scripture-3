import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:math' as math;

import '../../providers/app_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_constants.dart';

/// Plans Page
/// 
/// Features:
/// - Featured plans carousel
/// - Active plans with progress
/// - Recommended plans grid
/// - Create custom plan button
class PlansPage extends ConsumerWidget {
  final VoidCallback? onCreatePlan;
  final Function(String planId)? onPlanTap;

  const PlansPage({
    super.key,
    this.onCreatePlan,
    this.onPlanTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

          // Featured Plans
          SliverToBoxAdapter(
            child: _buildFeaturedPlans(isDark),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // My Active Plans Section
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Text(
                'My Active Plans',
                style: AppTextStyles.sectionTitle(
                  color: isDark ? Colors.white : Colors.grey[900],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          SliverToBoxAdapter(
            child: _buildActivePlansEmpty(isDark),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // Recommended Plans
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Recommended Plans',
                style: AppTextStyles.sectionTitle(
                  color: isDark ? Colors.white : Colors.grey[900],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Recommended Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildListDelegate([
                _buildRecommendedCard(
                  title: 'Psalms of Peace',
                  duration: '30 Days',
                  icon: LucideIcons.heart,
                  gradient: AppColors.faithGradient,
                  isDark: isDark,
                ),
                _buildRecommendedCard(
                  title: 'Gospel Journey',
                  duration: '60 Days',
                  icon: LucideIcons.bookOpen,
                  gradient: AppColors.prayerGradient,
                  isDark: isDark,
                ),
                _buildRecommendedCard(
                  title: 'Wisdom Literature',
                  duration: '21 Days',
                  icon: LucideIcons.star,
                  gradient: AppColors.charactersGradient,
                  isDark: isDark,
                ),
                _buildRecommendedCard(
                  title: 'Prayer & Fasting',
                  duration: '7 Days',
                  icon: LucideIcons.flame,
                  gradient: AppColors.purposeGradient,
                  isDark: isDark,
                ),
              ]),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // Create Custom Plan
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            sliver: SliverToBoxAdapter(
              child: _buildCreatePlanButton(isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.04)]
              : [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppColors.plansGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              LucideIcons.bookMarked,
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
                  'BIBLE PLANS',
                  style: AppTextStyles.label(
                    color: isDark ? Colors.white38 : Colors.grey[500],
                  ),
                ),
                Text(
                  'Your Study Journey',
                  style: AppTextStyles.heading2(
                    color: isDark ? Colors.white : Colors.grey[900],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedPlans(bool isDark) {
    final plans = [
      _FeaturedPlan(
        title: 'The Beatitudes',
        description: 'Explore the heart of Jesus\'s teaching',
        duration: '14 Days',
        gradient: AppColors.faithGradient,
      ),
      _FeaturedPlan(
        title: 'Parables of Jesus',
        description: 'Discover wisdom through stories',
        duration: '21 Days',
        gradient: AppColors.prayerGradient,
      ),
    ];

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              gradient: plan.gradient,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'FEATURED',
                          style: AppTextStyles.badge(),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        plan.title,
                        style: AppTextStyles.heading2(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        plan.description,
                        style: AppTextStyles.bodySmall(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.calendar,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            plan.duration,
                            style: AppTextStyles.caption(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActivePlansEmpty(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark
              ? AppColors.spiritualGold.withOpacity(0.2)
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.spiritualGold.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.bookOpen,
              size: 28,
              color: AppColors.spiritualGold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Active Plans',
            style: AppTextStyles.heading3(
              color: isDark ? Colors.white : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a Bible study plan to track your progress',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall(
              color: isDark ? Colors.white54 : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedCard({
    required String title,
    required String duration,
    required IconData icon,
    required LinearGradient gradient,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      child: Container(
        padding: const EdgeInsets.all(20),
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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 22, color: Colors.white),
            ),
            const Spacer(),
            Text(
              title,
              style: AppTextStyles.bodyBold(
                color: isDark ? Colors.white : Colors.grey[900],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              duration,
              style: AppTextStyles.caption(
                color: isDark ? Colors.white54 : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatePlanButton(bool isDark) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onCreatePlan?.call();
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.spiritualGold, AppColors.spiritualGoldLight],
          ),
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: [
            BoxShadow(
              color: AppColors.spiritualGold.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.sparkles,
                size: 26,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Custom Plan',
                    style: AppTextStyles.heading3(color: Colors.white),
                  ),
                  Text(
                    'Chat with AI to design your journey',
                    style: AppTextStyles.bodySmall(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              LucideIcons.chevronRight,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedPlan {
  final String title;
  final String description;
  final String duration;
  final LinearGradient gradient;

  _FeaturedPlan({
    required this.title,
    required this.description,
    required this.duration,
    required this.gradient,
  });
}
