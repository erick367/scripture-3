import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_constants.dart';

/// Streak Card - Giant Number Display
/// 
/// Features:
/// - 120px gradient text number
/// - Brown gradient background
/// - Animated progress bar
/// - Inspirational quote
class StreakCard extends StatelessWidget {
  final int currentStreak;
  final int goalStreak;
  final String quote;
  final bool isDark;

  const StreakCard({
    super.key,
    required this.currentStreak,
    required this.goalStreak,
    this.quote = 'Every day you spend in His Word builds a foundation that cannot be shaken.',
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = currentStreak / goalStreak;
    final remaining = goalStreak - currentStreak;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: AppColors.streakCardGradient(isDark),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: const Color(0xFF7C2D12).withOpacity(0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            'DAY STREAK',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: const Color(0xFFFED7AA).withOpacity(0.8),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Keep the momentum going!',
            style: AppTextStyles.caption(
              color: Colors.white.withOpacity(0.5),
            ),
          ),

          const SizedBox(height: 24),

          // Giant Number
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => AppColors.streakTextGradient
                    .createShader(bounds),
                child: Text(
                  '$currentStreak',
                  style: AppTextStyles.streakNumber(),
                ),
              ),

              const SizedBox(width: 12),

              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'days',
                  style: AppTextStyles.streakUnit(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Inspirational Quote
          Text(
            '"$quote"',
            style: AppTextStyles.scriptureItalic(
              fontSize: 20,
              color: Colors.white.withOpacity(0.8),
            ),
          ),

          const SizedBox(height: 16),

          // Days Remaining
          Text(
            '$remaining more days to reach your $goalStreak-day goal 🎯',
            style: AppTextStyles.bodySmall(
              color: Colors.white.withOpacity(0.6),
            ),
          ),

          const SizedBox(height: 16),

          // Animated Progress Bar
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: percentage),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Stack(
                  children: [
                    // Progress fill
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: value,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.orange500,
                              AppColors.red500,
                              AppColors.pink600,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    // Shimmer effect
                    _ProgressShimmer(progress: value),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProgressShimmer extends StatefulWidget {
  final double progress;

  const _ProgressShimmer({required this.progress});

  @override
  State<_ProgressShimmer> createState() => _ProgressShimmerState();
}

class _ProgressShimmerState extends State<_ProgressShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: widget.progress,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: FractionallySizedBox(
              widthFactor: 2.0,
              alignment: Alignment(-1 + (_controller.value * 3), 0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
