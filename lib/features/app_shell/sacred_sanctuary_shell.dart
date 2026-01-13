import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui';

// Import the 4 main screens
import '../sanctuary/presentation/sanctuary_screen.dart';
import '../lens/presentation/lens_screen.dart';
import '../mentor/presentation/mentor_screen_unified.dart';
import '../search_settings/presentation/search_settings_screen.dart';

/// State provider for Bottom Navigation Index
/// 
/// Tab mapping:
/// 0 = The Sanctuary (Hub & Identity)
/// 1 = The Lens (Immersive Reader)
/// 2 = The Mentor (Journal & DBS)
/// 3 = Search & Settings
final sacredNavIndexProvider = StateProvider<int>((ref) => 0);

/// The main Sacred Sanctuary app shell with 4-tab navigation
/// 
/// Uses a floating glassmorphic dock at the bottom for navigation.
/// IndexedStack preserves state across tab switches.
class SacredSanctuaryShell extends ConsumerWidget {
  const SacredSanctuaryShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(sacredNavIndexProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF000000), // Deep Space Black
      extendBody: true, // Allow body to extend behind nav bar
      
      body: SafeArea(
        bottom: false, // Don't add safe area at bottom (nav bar handles it)
        child: IndexedStack(
          index: currentIndex,
          children: const [
            SanctuaryScreen(),  // Tab 0: The Sanctuary
            LensScreen(),       // Tab 1: The Lens
            MentorScreenUnified(), // Tab 2: The Mentor
            SearchSettingsScreen(), // Tab 3: Search & Settings
          ],
        ),
      ),
      
      bottomNavigationBar: _GlassmorphicNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (currentIndex != index) {
            HapticFeedback.selectionClick();
            ref.read(sacredNavIndexProvider.notifier).state = index;
          }
        },
      ),
    );
  }
}

/// Floating glassmorphic navigation bar
/// 
/// Implements the "Liquid Glass" design language with:
/// - Backdrop blur (sigma 25)
/// - Semi-transparent surface
/// - Subtle border
/// - 120fps-smooth animations
class _GlassmorphicNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  
  const _GlassmorphicNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF12121E).withOpacity(0.85),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavItem(
                  icon: LucideIcons.sparkles,
                  label: 'Sanctuary',
                  isSelected: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
                _NavItem(
                  icon: LucideIcons.search,
                  label: 'Lens',
                  isSelected: currentIndex == 1,
                  onTap: () => onTap(1),
                ),
                _NavItem(
                  icon: LucideIcons.messageCircle,
                  label: 'Mentor',
                  isSelected: currentIndex == 2,
                  onTap: () => onTap(2),
                ),
                _NavItem(
                  icon: LucideIcons.settings,
                  label: 'Settings',
                  isSelected: currentIndex == 3,
                  onTap: () => onTap(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Individual navigation item with animated selection state
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF00F2FF).withOpacity(0.15) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected 
                  ? const Color(0xFF00F2FF) 
                  : Colors.white54,
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected 
                    ? const Color(0xFF00F2FF) 
                    : Colors.white54,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
