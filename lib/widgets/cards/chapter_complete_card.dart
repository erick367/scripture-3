import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_constants.dart';

/// Chapter Complete Card
/// 
/// Features:
/// - Celebration animation (elastic scale)
/// - Stats display
/// - Quick note input
/// - Action buttons
class ChapterCompleteCard extends StatefulWidget {
  final int versesRead;
  final int minutesSpent;
  final int currentStreak;
  final VoidCallback? onNextChapter;
  final VoidCallback? onBackToPlans;
  final VoidCallback? onJournalReflection;
  final bool isDark;

  const ChapterCompleteCard({
    super.key,
    required this.versesRead,
    required this.minutesSpent,
    required this.currentStreak,
    this.onNextChapter,
    this.onBackToPlans,
    this.onJournalReflection,
    this.isDark = true,
  });

  @override
  State<ChapterCompleteCard> createState() => _ChapterCompleteCardState();
}

class _ChapterCompleteCardState extends State<ChapterCompleteCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDurations.xslow,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ScaleTransition(
          scale: _scaleAnimation,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.isDark
                      ? [
                          Colors.purple.shade900.withOpacity(0.6),
                          Colors.blue.shade900.withOpacity(0.6),
                        ]
                      : [
                          const Color(0xFFF3E8FF),
                          const Color(0xFFEBF8FF),
                        ],
                ),
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(
                  color: widget.isDark
                      ? Colors.white.withOpacity(0.2)
                      : Colors.purple.shade200,
                ),
              ),
              child: Column(
                children: [
                  // Celebration Icon
                  const Text('🎉', style: TextStyle(fontSize: 80)),

                  const SizedBox(height: 24),

                  // Heading with gradient
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppColors.purple500, AppColors.cyan500],
                    ).createShader(bounds),
                    child: Text(
                      'Chapter Complete!',
                      style: AppTextStyles.heading1(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat(
                        LucideIcons.bookOpen,
                        '${widget.versesRead}',
                        'Verses',
                      ),
                      _buildStat(
                        LucideIcons.clock,
                        '${widget.minutesSpent}',
                        'Minutes',
                      ),
                      _buildStat(
                        LucideIcons.flame,
                        '${widget.currentStreak}',
                        'Day Streak',
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Quick Note Input
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      hintText: 'What did you learn? (Optional)',
                      hintStyle: TextStyle(
                        color: widget.isDark
                            ? Colors.white.withOpacity(0.4)
                            : Colors.grey,
                      ),
                      filled: true,
                      fillColor: widget.isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(
                      color: widget.isDark ? Colors.white : Colors.grey[900],
                    ),
                    maxLines: 3,
                  ),

                  const SizedBox(height: 32),

                  // Primary Button - Next Chapter
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      widget.onNextChapter?.call();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: AppColors.readingGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Next Chapter',
                            style: AppTextStyles.buttonText(color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            LucideIcons.arrowRight,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Secondary buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          widget.onBackToPlans?.call();
                        },
                        child: Text(
                          'Back to Plans',
                          style: TextStyle(
                            color: widget.isDark
                                ? Colors.white.withOpacity(0.7)
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      TextButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          widget.onJournalReflection?.call();
                        },
                        child: Text(
                          'Journal Reflection',
                          style: TextStyle(
                            color: widget.isDark
                                ? Colors.white.withOpacity(0.7)
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: widget.isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.purple500,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.heading1(
            color: widget.isDark ? Colors.white : Colors.grey[900],
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption(
            color: widget.isDark
                ? Colors.white.withOpacity(0.6)
                : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
