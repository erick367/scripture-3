import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui';

import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';

/// Dynamic Island Navigation
/// 
/// Features:
/// - Collapsed: 80x56px pill with current icon
/// - Expanded: 320x64px with all 4 icons
/// - Spring animation (300ms)
/// - Per-tab gradient backgrounds
class DynamicIslandNav extends StatefulWidget {
  final String currentPage;
  final Function(String) onPageChange;
  final bool isDark;

  const DynamicIslandNav({
    super.key,
    required this.currentPage,
    required this.onPageChange,
    this.isDark = true,
  });

  @override
  State<DynamicIslandNav> createState() => _DynamicIslandNavState();
}

class _DynamicIslandNavState extends State<DynamicIslandNav>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  late Animation<double> _heightAnimation;

  static const List<_NavItem> _navItems = [
    _NavItem(
      id: 'sanctuary',
      icon: LucideIcons.home,
      label: 'Home',
      gradient: AppColors.homeGradient,
    ),
    _NavItem(
      id: 'lens',
      icon: LucideIcons.bookOpen,
      label: 'Read',
      gradient: AppColors.readingGradient,
    ),
    _NavItem(
      id: 'plans',
      icon: LucideIcons.bookMarked,
      label: 'Plans',
      gradient: AppColors.plansGradient,
    ),
    _NavItem(
      id: 'mentor',
      icon: LucideIcons.sparkles,
      label: 'Journal',
      gradient: AppColors.journalGradient,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDurations.medium,
      vsync: this,
    );

    _widthAnimation = Tween<double>(
      begin: AppSizes.navCollapsedWidth,
      end: AppSizes.navExpandedWidth,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _heightAnimation = Tween<double>(
      begin: AppSizes.navCollapsedHeight,
      end: AppSizes.navExpandedHeight,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleExpanded() {
    HapticFeedback.lightImpact();
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _onNavTap(String pageId) {
    HapticFeedback.selectionClick();
    widget.onPageChange(pageId);
    
    // Auto-collapse after selection
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted && isExpanded) {
        toggleExpanded();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Tap outside to collapse
        if (isExpanded)
          Positioned.fill(
            child: GestureDetector(
              onTap: toggleExpanded,
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),
          ),

        // Navigation dock
        Positioned(
          bottom: AppSizes.navBottomPadding,
          left: 0,
          right: 0,
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return GestureDetector(
                  onTap: !isExpanded ? toggleExpanded : null,
                  child: Container(
                    width: _widthAnimation.value,
                    height: _heightAnimation.value,
                    decoration: BoxDecoration(
                      color: isExpanded
                          ? (widget.isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.white.withOpacity(0.2))
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: isExpanded
                          ? Border.all(
                              color: widget.isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.white.withOpacity(0.3),
                            )
                          : null,
                      boxShadow: isExpanded
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 40,
                                offset: const Offset(0, 10),
                              ),
                            ]
                          : [],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: BackdropFilter(
                        filter: isExpanded
                            ? ImageFilter.blur(sigmaX: 24, sigmaY: 24)
                            : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                        child: _buildCollapsedNav(), // Always show collapsed
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCollapsedNav() {
    final currentItem = _navItems.firstWhere(
      (item) => item.id == widget.currentPage,
      orElse: () => _navItems[0],
    );

    return Center(
      child: Container(
        width: AppSizes.navIconSize,
        height: AppSizes.navIconSize,
        decoration: BoxDecoration(
          gradient: currentItem.gradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          currentItem.icon,
          color: Colors.white,
          size: AppSizes.iconLarge,
        ),
      ),
    );
  }

  Widget _buildExpandedNav() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _navItems.map((item) {
          final isActive = item.id == widget.currentPage;
          
          return GestureDetector(
            onTap: () => _onNavTap(item.id),
            behavior: HitTestBehavior.opaque,
            child: _NavButton(
              item: item,
              isActive: isActive,
              isDark: widget.isDark,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final bool isDark;

  const _NavButton({
    required this.item,
    required this.isActive,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDurations.fast,
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: isActive ? item.gradient : null,
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: (item.gradient.colors.first).withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Icon(
        item.icon,
        color: isActive
            ? Colors.white
            : isDark
                ? Colors.white.withOpacity(0.6)
                : Colors.grey[600],
        size: 22,
      ),
    );
  }
}

class _NavItem {
  final String id;
  final IconData icon;
  final String label;
  final LinearGradient gradient;

  const _NavItem({
    required this.id,
    required this.icon,
    required this.label,
    required this.gradient,
  });
}
