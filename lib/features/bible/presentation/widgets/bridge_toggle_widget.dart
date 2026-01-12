import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BridgeToggleWidget extends StatelessWidget {
  final bool isAppliedMode;
  final ValueChanged<bool> onToggle;

  const BridgeToggleWidget({
    super.key,
    required this.isAppliedMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    // Smaller dimensions: 200x44 instead of 240x56
    const double width = 200;
    const double height = 44;
    const double borderRadius = 22;
    const double padding = 3;

    return GlassmorphicContainer(
      width: width,
      height: height,
      borderRadius: borderRadius,
      blur: 15,
      alignment: Alignment.center,
      border: 1.0, // Thinner border
      linearGradient: LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.08),
          Colors.white.withValues(alpha: 0.04),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
           Colors.white.withValues(alpha: 0.3),
           Colors.white.withValues(alpha: 0.05),
        ],
      ),
      child: Stack(
        children: [
          // Animated Selection Indicator
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack, // Bouncy effect
            alignment: isAppliedMode ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(padding),
              child: Container(
                width: (width / 2) - padding,
                height: height - (padding * 2),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isAppliedMode
                        ? [const Color(0xFF6366F1), const Color(0xFF8B5CF6)]
                        : [const Color(0xFFF59E0B), const Color(0xFFD97706)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(borderRadius - padding),
                  boxShadow: [
                    BoxShadow(
                      color: (isAppliedMode ? const Color(0xFF6366F1) : Colors.amber)
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Touch Targets & Labels
          Row(
            children: [
              _buildOption(
                context: context,
                text: 'Literal',
                icon: LucideIcons.bookOpen,
                isSelected: !isAppliedMode,
                onTap: () {
                  if (isAppliedMode) {
                    HapticFeedback.lightImpact();
                    onToggle(false);
                  }
                },
              ),
              _buildOption(
                context: context,
                text: 'Applied',
                icon: LucideIcons.sparkles, // Changed icon to Sparkles for 'Applied'
                isSelected: isAppliedMode,
                onTap: () {
                  if (!isAppliedMode) {
                    HapticFeedback.lightImpact();
                    onToggle(true);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required String text,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent, // Critical for easy tapping
        onTap: onTap,
        child: SizedBox(
          height: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14, // Smaller icon
                color: isSelected ? Colors.white : Colors.white54,
              ),
              const SizedBox(width: 6),
              Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 12, // Smaller font
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
