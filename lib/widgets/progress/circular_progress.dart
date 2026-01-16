import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_constants.dart';

/// Circular Progress Indicator
/// 
/// Features:
/// - Gradient arc with animation
/// - Icon + number in center
/// - Label + "X to goal" text
class CircularProgress extends StatelessWidget {
  final IconData icon;
  final int current;
  final int target;
  final List<Color> gradientColors;
  final String label;
  final bool isDark;

  const CircularProgress({
    super.key,
    required this.icon,
    required this.current,
    required this.target,
    required this.gradientColors,
    required this.label,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = current / target;

    return Column(
      children: [
        SizedBox(
          width: AppSizes.circularProgressSize,
          height: AppSizes.circularProgressSize,
          child: Stack(
            children: [
              // Background Circle
              CustomPaint(
                size: const Size(AppSizes.circularProgressSize, AppSizes.circularProgressSize),
                painter: _CirclePainter(
                  progress: 1.0,
                  colors: [
                    isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.1),
                    isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.1),
                  ],
                  strokeWidth: AppSizes.circularProgressStroke,
                ),
              ),

              // Animated Progress Circle
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: percentage),
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return CustomPaint(
                    size: const Size(AppSizes.circularProgressSize, AppSizes.circularProgressSize),
                    painter: _CirclePainter(
                      progress: value,
                      colors: gradientColors,
                      strokeWidth: AppSizes.circularProgressStroke,
                    ),
                  );
                },
              ),

              // Center Content
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      color: gradientColors[0],
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$current',
                      style: AppTextStyles.progressNumber(
                        color: isDark ? Colors.white : Colors.grey[900],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Text(
          label,
          style: AppTextStyles.bodyBold(
            color: isDark ? Colors.white : Colors.grey[900],
          ),
        ),

        const SizedBox(height: 4),

        Text(
          '${target - current} to goal',
          style: AppTextStyles.caption(
            color: isDark
                ? Colors.white.withOpacity(0.5)
                : Colors.grey[500],
          ),
        ),
      ],
    );
  }
}

/// Today's Activity Row - 3 Circular Progress Indicators
class TodayActivityRow extends StatelessWidget {
  final int chaptersRead;
  final int chaptersGoal;
  final int minutesSpent;
  final int minutesGoal;
  final int goalsAchieved;
  final int goalsTotal;
  final bool isDark;

  const TodayActivityRow({
    super.key,
    required this.chaptersRead,
    required this.chaptersGoal,
    required this.minutesSpent,
    required this.minutesGoal,
    required this.goalsAchieved,
    required this.goalsTotal,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Activity",
            style: AppTextStyles.sectionTitle(
              color: isDark ? Colors.white : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularProgress(
                icon: Icons.menu_book,
                current: chaptersRead,
                target: chaptersGoal,
                gradientColors: const [AppColors.blue500, AppColors.cyan600],
                label: 'Chapters',
                isDark: isDark,
              ),
              CircularProgress(
                icon: Icons.access_time,
                current: minutesSpent,
                target: minutesGoal,
                gradientColors: const [AppColors.purple500, AppColors.pink600],
                label: 'Minutes',
                isDark: isDark,
              ),
              CircularProgress(
                icon: Icons.gps_fixed,
                current: goalsAchieved,
                target: goalsTotal,
                gradientColors: const [AppColors.green500, AppColors.emerald600],
                label: 'Goals',
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom Painter for Circular Progress
class _CirclePainter extends CustomPainter {
  final double progress;
  final List<Color> colors;
  final double strokeWidth;

  _CirclePainter({
    required this.progress,
    required this.colors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..shader = LinearGradient(
        colors: colors,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      2 * math.pi * progress, // Progress angle
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
