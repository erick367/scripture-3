import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'mentor_design.dart';
import '../../../profile/application/theme_service.dart';

/// Mentor Status Card - Shows current spiritual focus based on recent journals
/// Uses Qwen for fast sentiment/topic extraction (~400ms)
class MentorStatusCard extends ConsumerWidget {
  const MentorStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themesAsync = ref.watch(spiritualThemesProvider);
    
    return themesAsync.when(
      loading: () => _buildLoadingState(),
      error: (_, __) => _buildFallbackState(),
      data: (themes) {
        if (themes.isEmpty) return _buildEmptyState();
        
        // Get the top theme as current focus
        final currentFocus = themes.first;
        final totalReflections = themes.fold<int>(0, (sum, t) => sum + t.frequency);
        
        return GlassCard(
          accentColor: MentorDesign.themeColor(currentFocus.name),
          onTap: () {
            HapticFeedback.lightImpact();
            // TODO: Navigate to focus detail view
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: MentorDesign.themeColor(currentFocus.name).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getThemeIcon(currentFocus.name),
                      color: MentorDesign.themeColor(currentFocus.name),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Focus',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.white38,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          currentFocus.name,
                          style: GoogleFonts.lora(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Trend indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.trendingUp, color: Colors.green, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          '${currentFocus.frequency}x',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Progress toward milestone
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Journey Progress',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.white38,
                        ),
                      ),
                      Text(
                        '$totalReflections / 10 reflections',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.white54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (totalReflections / 10).clamp(0.0, 1.0),
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        MentorDesign.themeColor(currentFocus.name),
                      ),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getMilestoneMessage(totalReflections),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildLoadingState() {
    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 150,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return GlassCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.compass, color: Colors.amber, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Begin Your Journey',
                  style: GoogleFonts.lora(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Journal a reflection to discover your focus.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          const Icon(LucideIcons.chevronRight, color: Colors.white24, size: 20),
        ],
      ),
    );
  }
  
  Widget _buildFallbackState() {
    return GlassCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.heart, color: Colors.blue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Current Focus',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.white38,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'Your Spiritual Walk',
                  style: GoogleFonts.lora(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  IconData _getThemeIcon(String theme) {
    final lower = theme.toLowerCase();
    if (lower.contains('patience')) return LucideIcons.clock;
    if (lower.contains('trust') || lower.contains('faith')) return LucideIcons.shield;
    if (lower.contains('peace') || lower.contains('rest')) return LucideIcons.cloud;
    if (lower.contains('love') || lower.contains('agape')) return LucideIcons.heart;
    if (lower.contains('identity')) return LucideIcons.user;
    if (lower.contains('gratitude') || lower.contains('thankful')) return LucideIcons.gift;
    if (lower.contains('hope')) return LucideIcons.sunrise;
    if (lower.contains('joy')) return LucideIcons.smile;
    if (lower.contains('work')) return LucideIcons.briefcase;
    return LucideIcons.sparkles;
  }
  
  String _getMilestoneMessage(int count) {
    if (count < 3) return '3 reflections unlock your first insight pattern.';
    if (count < 5) return '5 reflections reveal your growth trajectory.';
    if (count < 10) return 'Approaching your first Spiritual Milestone!';
    return '🎉 Milestone reached! Keep going!';
  }
}
