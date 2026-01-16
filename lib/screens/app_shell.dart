import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';
import '../../theme/app_colors.dart';
import '../../widgets/navigation/dynamic_island_nav.dart';
import '../../screens/home_page.dart';
import '../../screens/read_page.dart';
import '../../screens/plans_page.dart';
import '../../screens/journal_page.dart';

/// App Shell - Main Container
/// 
/// Manages:
/// - Page switching via Dynamic Island nav
/// - Profile overlay
/// - Search overlay
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(currentPageProvider);
    final isDark = ref.watch(effectiveDarkModeProvider);

    return Scaffold(
      backgroundColor: AppColors.background(isDark),
      body: Stack(
        children: [
          // Main Page Content
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.02),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _buildPage(currentPage, ref),
          ),

          // Dynamic Island Navigation
          DynamicIslandNav(
            currentPage: currentPage,
            onPageChange: (page) {
              ref.read(currentPageProvider.notifier).state = page;
            },
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildPage(String page, WidgetRef ref) {
    switch (page) {
      case 'sanctuary':
        return HomePage(
          key: const ValueKey('home'),
          onSearchTap: () => _showSearch(ref),
          onProfileTap: () => _showProfile(ref),
          onNotificationTap: () {},
          onContinueReading: (book, chapter) {
            _navigateToReader(ref, book, chapter);
          },
        );
      case 'lens':
        return ReadPage(
          key: const ValueKey('read'),
          book: 'Genesis',
          chapter: 1,
          verses: _sampleVerses,
          onBack: () => ref.read(currentPageProvider.notifier).state = 'sanctuary',
          onNextChapter: () {},
          onPrevChapter: () {},
        );
      case 'plans':
        return PlansPage(
          key: const ValueKey('plans'),
          onCreatePlan: () {},
          onPlanTap: (id) {},
        );
      case 'mentor':
        return JournalPage(
          key: const ValueKey('journal'),
          onNewEntry: () {},
          onEntryTap: (id) {},
        );
      default:
        return const HomePage();
    }
  }

  void _showSearch(WidgetRef ref) {
    // Show search overlay
  }

  void _showProfile(WidgetRef ref) {
    // Show profile overlay
  }

  void _navigateToReader(WidgetRef ref, String book, int chapter) {
    ref.read(currentPageProvider.notifier).state = 'lens';
  }

  // Sample verses for demo
  static const List<String> _sampleVerses = [
    'In the beginning God created the heavens and the earth.',
    'Now the earth was formless and empty, darkness was over the surface of the deep, and the Spirit of God was hovering over the waters.',
    'And God said, "Let there be light," and there was light.',
    'God saw that the light was good, and he separated the light from the darkness.',
    'God called the light "day," and the darkness he called "night." And there was evening, and there was morning—the first day.',
    'And God said, "Let there be a vault between the waters to separate water from water."',
    'So God made the vault and separated the water under the vault from the water above it. And it was so.',
    'God called the vault "sky." And there was evening, and there was morning—the second day.',
    'And God said, "Let the water under the sky be gathered to one place, and let dry ground appear." And it was so.',
    'God called the dry ground "land," and the gathered waters he called "seas." And God saw that it was good.',
  ];
}
