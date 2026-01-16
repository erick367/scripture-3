import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_constants.dart';

/// Verse Card
/// 
/// Features:
/// - Scroll-in animation (opacity 0.6→1, scale 0.98→1)
/// - Gradient verse number
/// - Long-press for actions
class VerseCard extends StatefulWidget {
  final int verseNumber;
  final String verseText;
  final double fontSize;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isDark;
  final int animationDelay;

  const VerseCard({
    super.key,
    required this.verseNumber,
    required this.verseText,
    this.fontSize = 22,
    this.onTap,
    this.onLongPress,
    this.isDark = true,
    this.animationDelay = 0,
  });

  @override
  State<VerseCard> createState() => _VerseCardState();
}

class _VerseCardState extends State<VerseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDurations.slow,
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.98,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.02),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Staggered animation start
    Future.delayed(Duration(milliseconds: 100 + widget.animationDelay), () {
      if (mounted) {
        _controller.forward();
      }
    });
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
        return SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: child,
            ),
          ),
        );
      },
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: widget.isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: widget.isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: RichText(
            text: TextSpan(
              children: [
                // Verse Number with gradient
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        AppColors.spiritualGold,
                        AppColors.spiritualGoldLight,
                      ],
                    ).createShader(bounds),
                    child: Text(
                      '${widget.verseNumber} ',
                      style: AppTextStyles.verseNumber(
                        baseFontSize: widget.fontSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Verse Text
                TextSpan(
                  text: widget.verseText,
                  style: AppTextStyles.scripture(
                    fontSize: widget.fontSize,
                    color: widget.isDark ? Colors.white : const Color(0xFF1C1917),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Verse List - Scrollable list of verse cards
class VerseList extends StatelessWidget {
  final List<String> verses;
  final double fontSize;
  final Function(int)? onVerseTap;
  final Function(int)? onVerseLongPress;
  final bool isDark;
  final ScrollController? scrollController;

  const VerseList({
    super.key,
    required this.verses,
    this.fontSize = 22,
    this.onVerseTap,
    this.onVerseLongPress,
    this.isDark = true,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.only(top: 100, bottom: 120),
      itemCount: verses.length,
      itemBuilder: (context, index) {
        return VerseCard(
          verseNumber: index + 1,
          verseText: verses[index],
          fontSize: fontSize,
          onTap: () => onVerseTap?.call(index),
          onLongPress: () => onVerseLongPress?.call(index),
          isDark: isDark,
          animationDelay: index * 50,
        );
      },
    );
  }
}
