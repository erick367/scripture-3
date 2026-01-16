import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_constants.dart';

/// Dynamic Island Header
/// 
/// Features:
/// - Animated logo with shimmer
/// - Greeting based on time of day
/// - Notification badge with count
/// - Search button
/// - Profile avatar
class DynamicIslandHeader extends StatelessWidget {
  final String greeting;
  final String userName;
  final int notificationCount;
  final VoidCallback onProfileTap;
  final VoidCallback onSearchTap;
  final VoidCallback onNotificationTap;
  final bool isDark;

  const DynamicIslandHeader({
    super.key,
    required this.greeting,
    required this.userName,
    this.notificationCount = 0,
    required this.onProfileTap,
    required this.onSearchTap,
    required this.onNotificationTap,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.10)
            : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.2)
              : Colors.grey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Animated Logo
          _AnimatedLogo(isDark: isDark),

          const SizedBox(width: 12),

          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: AppTextStyles.caption(
                    color: isDark
                        ? Colors.white.withOpacity(0.6)
                        : Colors.grey[500],
                  ),
                ),
                Text(
                  userName,
                  style: AppTextStyles.heading2(
                    color: isDark ? Colors.white : Colors.grey[900],
                  ),
                ),
              ],
            ),
          ),

          // Notification Button with Badge
          _NotificationButton(
            count: notificationCount,
            onTap: onNotificationTap,
            isDark: isDark,
          ),

          const SizedBox(width: 8),

          // Search Button
          _IconButton(
            icon: LucideIcons.search,
            onTap: onSearchTap,
            isDark: isDark,
          ),

          const SizedBox(width: 8),

          // Profile Button
          _ProfileButton(
            onTap: onProfileTap,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _AnimatedLogo extends StatefulWidget {
  final bool isDark;

  const _AnimatedLogo({required this.isDark});

  @override
  State<_AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<_AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDurations.shimmer,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.logoSize,
      height: AppSizes.logoSize,
      decoration: BoxDecoration(
        gradient: AppColors.logoGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Shimmer effect
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: FractionallySizedBox(
                  widthFactor: 2.0,
                  alignment: Alignment(-1 + (_controller.value * 3), 0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // Icon
          const Center(
            child: Icon(
              LucideIcons.bookOpen,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  final bool isDark;

  const _NotificationButton({
    required this.count,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.bell,
              color: isDark ? Colors.white.withOpacity(0.7) : Colors.grey[600],
              size: 20,
            ),
          ),
          if (count > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  gradient: AppColors.notificationBadge,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    count > 9 ? '9+' : '$count',
                    style: AppTextStyles.badge(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _IconButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isDark ? Colors.white.withOpacity(0.7) : Colors.grey[600],
          size: 20,
        ),
      ),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isDark;

  const _ProfileButton({
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Stack(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.logoGradient,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'E',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          // Online indicator
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.emerald500,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.backgroundDark : Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
