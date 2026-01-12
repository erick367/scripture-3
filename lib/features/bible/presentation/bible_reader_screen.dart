import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'widgets/bible_content_widget.dart';
import '../../discover/presentation/discover_screen.dart'; // Import Discover Screen
import '../../home/presentation/home_screen.dart';
import '../../journal/presentation/journal_screen.dart';
import '../../me/presentation/me_screen.dart';
import '../../mentor/presentation/mentor_hub_screen.dart';

// State provider for Bottom Navigation Index
final navIndexProvider = StateProvider<int>((ref) => 0); // Default to 'Home' tab (index 0)

class BibleReaderScreen extends ConsumerWidget {
  const BibleReaderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navIndexProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Dark theme background
      
      // Use IndexedStack to preserve state of each tab
      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: [
            const HomeScreen(), // The Home Dashboard
            const DiscoverScreen(), // The Discover Tab
            const BibleContentWidget(), // The Bible Reader
            const JournalScreen(), // The Journal Screen
            const MentorHubScreen(), // The Mentor Hub
            const MeScreen(), // The Profile Dashboard
          ],
        ),
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF151515),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          if (ref.read(navIndexProvider) != index) {
            HapticFeedback.selectionClick(); // Subtle haptic feedback
          }
          ref.read(navIndexProvider.notifier).state = index;
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.compass), label: 'Discover'), // New Tab
          BottomNavigationBarItem(icon: Icon(LucideIcons.bookOpen), label: 'Read'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.edit3), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.messageSquare), label: 'Mentor'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: 'Me'),
        ],
      ),
    );
  }
}
