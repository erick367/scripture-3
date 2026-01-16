import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:math' as math;

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_constants.dart';

/// Continue Reading Card
/// 
/// Features:
/// - 300x180px card size
/// - Gradient accent bar (left 4px)
/// - Progress ring
/// - Hover/tap effects
class ContinueReadingCard extends StatelessWidget {
  final String book;
  final String chapter;
  final int progress;
  final String nextVerse;
  final int totalVerses;
  final List<Color> gradientColors;
  final VoidCallback? onTap;
  final bool isDark;

  const ContinueReadingCard({
    super.key,
    required this.book,
    required this.chapter,
    required this.progress,
    required this.nextVerse,
    required this.totalVerses,
    required this.gradientColors,
    this.onTap,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Container(
        width: AppSizes.continueReadingCardWidth,
        height: AppSizes.continueReadingCardHeight,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Gradient Accent Bar
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: gradientColors,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    bottomLeft: Radius.circular(28),
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Book info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book,
                            style: AppTextStyles.bookName(
                              color: isDark ? Colors.white : Colors.grey[900],
                            ),
                          ),
                          Text(
                            'Chapter $chapter',
                            style: AppTextStyles.bodySmall(
                              color: isDark
                                  ? Colors.white.withOpacity(0.6)
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),

                      // Progress Ring
                      _SmallProgressRing(
                        progress: progress,
                        gradientColors: gradientColors,
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Next verse info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        nextVerse,
                        style: AppTextStyles.caption(
                          color: isDark
                              ? Colors.white.withOpacity(0.5)
                              : Colors.grey[500],
                        ),
                      ),

                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: gradientColors),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.arrowRight,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
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

class _SmallProgressRing extends StatelessWidget {
  final int progress;
  final List<Color> gradientColors;

  const _SmallProgressRing({
    required this.progress,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.smallProgressSize,
      height: AppSizes.smallProgressSize,
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(AppSizes.smallProgressSize, AppSizes.smallProgressSize),
            painter: _SmallCirclePainter(
              progress: progress / 100,
              colors: gradientColors,
              strokeWidth: AppSizes.smallProgressStroke,
            ),
          ),
          Center(
            child: Text(
              '$progress%',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: gradientColors[0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallCirclePainter extends CustomPainter {
  final double progress;
  final List<Color> colors;
  final double strokeWidth;

  _SmallCirclePainter({
    required this.progress,
    required this.colors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background
    final bgPaint = Paint()
      ..color = colors[0].withOpacity(0.2)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    canvas.drawCircle(center, radius, bgPaint);

    // Progress
    final paint = Paint()
      ..shader = LinearGradient(
        colors: colors,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_SmallCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Continue Reading Section - Horizontal scroll of cards
class ContinueReadingSection extends StatelessWidget {
  final List<ContinueReadingCardData> items;
  final Function(int index)? onCardTap;
  final bool isDark;

  const ContinueReadingSection({
    super.key,
    required this.items,
    this.onCardTap,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final gradients = [
      [AppColors.amber500, AppColors.orange500, AppColors.red600],
      [AppColors.purple500, AppColors.pink500, AppColors.pink600],
      [AppColors.blue500, AppColors.cyan500, AppColors.teal600],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Continue Reading',
            style: AppTextStyles.sectionTitle(
              color: isDark ? Colors.white : Colors.grey[900],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: AppSizes.continueReadingCardHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ContinueReadingCard(
                book: item.book,
                chapter: item.chapter,
                progress: item.progress,
                nextVerse: item.nextVerse,
                totalVerses: item.totalVerses,
                gradientColors: gradients[index % gradients.length],
                onTap: () => onCardTap?.call(index),
                isDark: isDark,
              );
            },
          ),
        ),
      ],
    );
  }
}

class ContinueReadingCardData {
  final String book;
  final String chapter;
  final int progress;
  final String nextVerse;
  final int totalVerses;

  const ContinueReadingCardData({
    required this.book,
    required this.chapter,
    required this.progress,
    required this.nextVerse,
    required this.totalVerses,
  });
}
