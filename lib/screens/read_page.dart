import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui';

import '../../providers/app_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_constants.dart';
import '../../widgets/cards/verse_card.dart';
import '../../widgets/cards/chapter_complete_card.dart';

/// Read Page (Lens)
/// 
/// Features:
/// - Floating glassmorphic header
/// - Animated verse cards
/// - Chapter complete celebration
class ReadPage extends ConsumerStatefulWidget {
  final String book;
  final int chapter;
  final List<String> verses;
  final VoidCallback? onBack;
  final VoidCallback? onNextChapter;
  final VoidCallback? onPrevChapter;

  const ReadPage({
    super.key,
    required this.book,
    required this.chapter,
    required this.verses,
    this.onBack,
    this.onNextChapter,
    this.onPrevChapter,
  });

  @override
  ConsumerState<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends ConsumerState<ReadPage> {
  final _scrollController = ScrollController();
  bool _showChapterComplete = false;
  double _headerOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Fade header on scroll
    final offset = _scrollController.offset;
    setState(() {
      _headerOpacity = (1 - (offset / 100)).clamp(0.0, 1.0);
    });

    // Check if reached end
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 50) {
      if (!_showChapterComplete) {
        setState(() => _showChapterComplete = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(effectiveDarkModeProvider);
    final fontSize = ref.watch(scriptureFontSizeProvider);

    return Scaffold(
      backgroundColor: AppColors.background(isDark),
      body: Stack(
        children: [
          // Verse List
          VerseList(
            verses: widget.verses,
            fontSize: fontSize,
            scrollController: _scrollController,
            onVerseTap: (index) => _showVerseActions(index),
            onVerseLongPress: (index) => _showVerseActions(index),
            isDark: isDark,
          ),

          // Floating Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: AppDurations.fast,
              opacity: _headerOpacity,
              child: _buildFloatingHeader(isDark, fontSize),
            ),
          ),

          // Chapter Complete Overlay
          if (_showChapterComplete)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: ChapterCompleteCard(
                    versesRead: widget.verses.length,
                    minutesSpent: 23,
                    currentStreak: 47,
                    onNextChapter: () {
                      setState(() => _showChapterComplete = false);
                      widget.onNextChapter?.call();
                    },
                    onBackToPlans: () {
                      setState(() => _showChapterComplete = false);
                      widget.onBack?.call();
                    },
                    onJournalReflection: () {
                      setState(() => _showChapterComplete = false);
                      // Navigate to journal
                    },
                    isDark: isDark,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFloatingHeader(bool isDark, double fontSize) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withOpacity(0.8)
            : Colors.white.withOpacity(0.8),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            height: AppSizes.headerHeight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Back Button
                IconButton(
                  icon: Icon(
                    LucideIcons.arrowLeft,
                    color: isDark ? Colors.white : Colors.grey[900],
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    widget.onBack?.call();
                  },
                ),

                const SizedBox(width: 8),

                // Book Name
                Text(
                  widget.book,
                  style: AppTextStyles.heading3(
                    color: isDark ? Colors.white : Colors.grey[900],
                  ),
                ),

                const Spacer(),

                // Chapter Navigation
                IconButton(
                  icon: Icon(
                    LucideIcons.chevronLeft,
                    color: isDark
                        ? Colors.white.withOpacity(0.6)
                        : Colors.grey[600],
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    widget.onPrevChapter?.call();
                  },
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Chapter ${widget.chapter}',
                    style: AppTextStyles.bodyBold(
                      color: isDark ? Colors.white : Colors.grey[900],
                    ),
                  ),
                ),

                IconButton(
                  icon: Icon(
                    LucideIcons.chevronRight,
                    color: isDark
                        ? Colors.white.withOpacity(0.6)
                        : Colors.grey[600],
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    widget.onNextChapter?.call();
                  },
                ),

                const Spacer(),

                // Font Size Controls
                IconButton(
                  icon: Icon(
                    LucideIcons.minus,
                    color: isDark
                        ? Colors.white.withOpacity(0.6)
                        : Colors.grey[600],
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    final newSize = (fontSize - 2).clamp(16.0, 32.0);
                    ref.read(scriptureFontSizeProvider.notifier).state = newSize;
                  },
                ),

                IconButton(
                  icon: Icon(
                    LucideIcons.plus,
                    color: isDark
                        ? Colors.white.withOpacity(0.6)
                        : Colors.grey[600],
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    final newSize = (fontSize + 2).clamp(16.0, 32.0);
                    ref.read(scriptureFontSizeProvider.notifier).state = newSize;
                  },
                ),

                // Theme Toggle
                IconButton(
                  icon: Icon(
                    isDark ? LucideIcons.sun : LucideIcons.moon,
                    color: isDark
                        ? Colors.white.withOpacity(0.6)
                        : Colors.grey[600],
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    ref.read(forceLightModeProvider.notifier).state = isDark;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showVerseActions(int verseIndex) {
    HapticFeedback.mediumImpact();
    // Show bottom sheet with verse actions
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _VerseActionsSheet(
        verseNumber: verseIndex + 1,
        isDark: ref.read(effectiveDarkModeProvider),
      ),
    );
  }
}

class _VerseActionsSheet extends StatelessWidget {
  final int verseNumber;
  final bool isDark;

  const _VerseActionsSheet({
    required this.verseNumber,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Verse $verseNumber',
            style: AppTextStyles.heading2(
              color: isDark ? Colors.white : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 24),
          _buildActionButton(
            icon: LucideIcons.copy,
            label: 'Copy',
            onTap: () => Navigator.pop(context),
          ),
          _buildActionButton(
            icon: LucideIcons.highlighter,
            label: 'Highlight',
            onTap: () => Navigator.pop(context),
          ),
          _buildActionButton(
            icon: LucideIcons.stickyNote,
            label: 'Add Note',
            onTap: () => Navigator.pop(context),
          ),
          _buildActionButton(
            icon: LucideIcons.share2,
            label: 'Share',
            onTap: () => Navigator.pop(context),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.spiritualGold),
      title: Text(
        label,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.grey[900],
        ),
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
    );
  }
}
