import 'package:flutter/material.dart';
import 'dart:ui';

import '../theme/app_colors.dart';
import '../theme/app_constants.dart';

/// Glassmorphic Card Widget
/// 
/// Features:
/// - Backdrop blur (24px)
/// - Opacity layers (5-10% white)
/// - Border (1px with 10-20% opacity)
/// - Multi-layer shadows
class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final double borderRadius;
  final EdgeInsets? padding;
  final double blurAmount;
  final Color? accentColor;
  final bool showBorder;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.isDark = true,
    this.borderRadius = AppRadius.xl,
    this.padding,
    this.blurAmount = 24.0,
    this.accentColor,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      Colors.white.withOpacity(0.10),
                      Colors.white.withOpacity(0.05),
                      Colors.white.withOpacity(0.10),
                    ]
                  : [
                      Colors.white,
                      const Color(0xFFEBF8FF).withOpacity(0.3),
                      const Color(0xFFF3E8FF).withOpacity(0.3),
                    ],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: showBorder
                ? Border.all(
                    color: accentColor?.withOpacity(0.3) ??
                        (isDark
                            ? Colors.white.withOpacity(0.2)
                            : Colors.black.withOpacity(0.1)),
                    width: 1,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              if (accentColor != null)
                BoxShadow(
                  color: accentColor!.withOpacity(0.15),
                  blurRadius: 30,
                  spreadRadius: 0,
                ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Simple Glass Container (No blur)
class GlassContainer extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final double borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final LinearGradient? gradient;
  final List<BoxShadow>? boxShadow;

  const GlassContainer({
    super.key,
    required this.child,
    this.isDark = true,
    this.borderRadius = AppRadius.md,
    this.padding,
    this.margin,
    this.gradient,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient ?? LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.04),
                ]
              : [
                  Colors.white.withOpacity(0.95),
                  Colors.white.withOpacity(0.8),
                ],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.white,
        ),
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Gradient Accent Bar (for card left borders)
class GradientAccentBar extends StatelessWidget {
  final double width;
  final double? height;
  final LinearGradient gradient;
  final double borderRadius;

  const GradientAccentBar({
    super.key,
    this.width = 4.0,
    this.height,
    required this.gradient,
    this.borderRadius = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
