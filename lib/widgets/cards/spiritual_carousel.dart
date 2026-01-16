import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_constants.dart';

/// Spiritual Carousel - Stacked Cards
/// 
/// Features:
/// - Verse of the Day (front)
/// - Prayer of the Day (back)
/// - Tap to flip between cards
/// - Scale and opacity animations
class SpiritualCarousel extends StatefulWidget {
  final String verse;
  final String verseReference;
  final String verseCategory;
  final String prayerTitle;
  final String prayer;
  final String prayerTheme;
  final VoidCallback? onVerseReadMore;
  final bool isDark;

  const SpiritualCarousel({
    super.key,
    required this.verse,
    required this.verseReference,
    required this.verseCategory,
    required this.prayerTitle,
    required this.prayer,
    required this.prayerTheme,
    this.onVerseReadMore,
    this.isDark = true,
  });

  @override
  State<SpiritualCarousel> createState() => _SpiritualCarouselState();
}

class _SpiritualCarouselState extends State<SpiritualCarousel> {
  int carouselIndex = 0;

  void switchCard() {
    HapticFeedback.lightImpact();
    setState(() {
      carouselIndex = carouselIndex == 0 ? 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Stacked Cards Container
        SizedBox(
          height: AppSizes.spiritualCarouselHeight,
          child: Stack(
            children: [
              // Prayer Card (Back when index == 0)
              AnimatedPositioned(
                duration: AppDurations.medium,
                curve: Curves.easeOutCubic,
                top: carouselIndex == 1 ? 0 : 12,
                left: 0,
                right: 0,
                child: AnimatedScale(
                  duration: AppDurations.medium,
                  curve: Curves.easeOutCubic,
                  scale: carouselIndex == 1 ? 1.0 : 0.96,
                  child: AnimatedOpacity(
                    duration: AppDurations.medium,
                    opacity: carouselIndex == 1 ? 1.0 : 0.6,
                    child: GestureDetector(
                      onTap: carouselIndex == 1 ? switchCard : null,
                      child: _buildPrayerCard(),
                    ),
                  ),
                ),
              ),

              // Verse Card (Front when index == 0)
              AnimatedPositioned(
                duration: AppDurations.medium,
                curve: Curves.easeOutCubic,
                top: carouselIndex == 0 ? 0 : 12,
                left: 0,
                right: 0,
                child: AnimatedScale(
                  duration: AppDurations.medium,
                  curve: Curves.easeOutCubic,
                  scale: carouselIndex == 0 ? 1.0 : 0.95,
                  child: AnimatedOpacity(
                    duration: AppDurations.medium,
                    opacity: carouselIndex == 0 ? 1.0 : 0.6,
                    child: GestureDetector(
                      onTap: carouselIndex == 0 ? switchCard : null,
                      child: _buildVerseCard(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Card Indicators
        _buildIndicators(),

        const SizedBox(height: 16),

        // Switch Button
        _buildSwitchButton(),
      ],
    );
  }

  Widget _buildVerseCard() {
    return Container(
      height: AppSizes.spiritualCardHeight,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.isDark
              ? [
                  Colors.white.withOpacity(0.10),
                  Colors.white.withOpacity(0.05),
                ]
              : [
                  Colors.white,
                  const Color(0xFFEBF8FF).withOpacity(0.5),
                ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: widget.isDark
              ? Colors.white.withOpacity(0.2)
              : Colors.black.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.orange400, AppColors.pink500],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  LucideIcons.sparkles,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verse of the Day',
                    style: AppTextStyles.heading2(
                      color: widget.isDark ? Colors.white : Colors.grey[900],
                    ),
                  ),
                  Text(
                    widget.verseCategory,
                    style: AppTextStyles.caption(
                      color: widget.isDark
                          ? Colors.white.withOpacity(0.5)
                          : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Scripture Text
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                '"${widget.verse}"',
                style: AppTextStyles.scripture(
                  color: widget.isDark ? Colors.white : Colors.grey[900],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Reference Badge
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: widget.isDark
                        ? LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.05),
                            ],
                          )
                        : const LinearGradient(
                            colors: [
                              Color(0xFFFEF3C7),
                              Color(0xFFFCE7F3),
                            ],
                          ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: widget.isDark
                          ? Colors.white.withOpacity(0.2)
                          : const Color(0xFFFED7AA),
                    ),
                  ),
                  child: Text(
                    widget.verseReference,
                    style: AppTextStyles.bodyBold(
                      color: widget.isDark
                          ? const Color(0xFFFDBA74)
                          : AppColors.orange600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Read More Button
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onVerseReadMore?.call();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: widget.isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: widget.isDark
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Read',
                        style: AppTextStyles.bodyBold(
                          color: widget.isDark ? Colors.white : Colors.grey[900],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        LucideIcons.arrowRight,
                        size: 18,
                        color: widget.isDark ? Colors.white : Colors.grey[900],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerCard() {
    return Container(
      height: AppSizes.spiritualCardHeight,
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.purple500, AppColors.pink500],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  LucideIcons.heart,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prayer of the Day',
                    style: AppTextStyles.heading2(
                      color: widget.isDark ? Colors.white : Colors.grey[900],
                    ),
                  ),
                  Text(
                    widget.prayerTheme,
                    style: AppTextStyles.caption(
                      color: widget.isDark
                          ? Colors.white.withOpacity(0.5)
                          : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Prayer Title
          Text(
            widget.prayerTitle,
            style: AppTextStyles.heading1(
              color: widget.isDark ? Colors.white : Colors.grey[900],
            ),
          ),

          const SizedBox(height: 16),

          // Prayer Text
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                widget.prayer,
                style: AppTextStyles.scriptureItalic(
                  color: widget.isDark
                      ? Colors.white.withOpacity(0.9)
                      : Colors.grey[800],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [0, 1].map((index) {
        final isActive = carouselIndex == index;
        return GestureDetector(
          onTap: () => setState(() => carouselIndex = index),
          child: AnimatedContainer(
            duration: AppDurations.fast,
            width: isActive ? 32 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: widget.isDark
                  ? Colors.white.withOpacity(isActive ? 1.0 : 0.3)
                  : Colors.grey[900]!.withOpacity(isActive ? 1.0 : 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSwitchButton() {
    return GestureDetector(
      onTap: switchCard,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: widget.isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          carouselIndex == 0 ? 'Tap for prayer' : 'Tap for verse',
          style: AppTextStyles.caption(
            color: widget.isDark
                ? Colors.white.withOpacity(0.6)
                : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
