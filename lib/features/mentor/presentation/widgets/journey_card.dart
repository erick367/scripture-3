import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'mentor_design.dart';

/// Data model for a themed spiritual journey
class Journey {
  final String theme;
  final int reflectionCount;
  final int verseCount;
  final int questionCount;
  final DateTime lastActivity;
  final List<String> recentSnippets;
  
  Journey({
    required this.theme,
    required this.reflectionCount,
    required this.verseCount,
    required this.questionCount,
    required this.lastActivity,
    this.recentSnippets = const [],
  });
  
  String get timeAgo {
    final diff = DateTime.now().difference(lastActivity);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return 'Just now';
  }
  
  int get totalItems => reflectionCount + verseCount + questionCount;
}

/// Journey Card - Shows theme-grouped spiritual journey
class JourneyCard extends StatelessWidget {
  final Journey journey;
  final VoidCallback? onTap;
  
  const JourneyCard({
    super.key,
    required this.journey,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final themeColor = MentorDesign.themeColor(journey.theme);
    
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      accentColor: themeColor,
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
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
                  color: themeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getThemeIcon(journey.theme),
                  color: themeColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      journey.theme,
                      style: GoogleFonts.lora(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      journey.timeAgo,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, color: Colors.white24, size: 20),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Stats row
          Row(
            children: [
              _buildStatBadge(
                icon: LucideIcons.penTool,
                count: journey.reflectionCount,
                label: 'Reflections',
                color: themeColor,
              ),
              const SizedBox(width: 12),
              _buildStatBadge(
                icon: LucideIcons.bookOpen,
                count: journey.verseCount,
                label: 'Verses',
                color: Colors.white54,
              ),
              const SizedBox(width: 12),
              _buildStatBadge(
                icon: LucideIcons.helpCircle,
                count: journey.questionCount,
                label: 'Questions',
                color: Colors.amber,
              ),
            ],
          ),
          
          // Recent snippet preview
          if (journey.recentSnippets.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.quote, size: 14, color: Colors.white24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      journey.recentSnippets.first,
                      style: GoogleFonts.lora(
                        fontSize: 12,
                        color: Colors.white54,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildStatBadge({
    required IconData icon,
    required int count,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
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
    if (lower.contains('god') || lower.contains('theos')) return LucideIcons.compass;
    if (lower.contains('life') || lower.contains('zoe')) return LucideIcons.zap;
    if (lower.contains('word') || lower.contains('logos')) return LucideIcons.bookOpen;
    return LucideIcons.sparkles;
  }
}
