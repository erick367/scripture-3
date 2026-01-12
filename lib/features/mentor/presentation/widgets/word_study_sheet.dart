import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui' as ui;
import 'mentor_design.dart';
import '../../../../services/ai_mentor_service.dart';

/// Provider for fetching instant definition using Qwen
final wordDefinitionProvider = FutureProvider.family<String, String>((ref, term) async {
  final service = ref.read(aiMentorServiceProvider);
  return service.getSimpleDefinition(term);
});

/// Word Study Sheet - Shows instant Greek/Hebrew definitions
/// Uses getSimpleDefinition() for ~250ms response
class WordStudySheet extends ConsumerWidget {
  final String term;
  final String? language;
  final String? basicDefinition;
  
  const WordStudySheet({
    super.key,
    required this.term,
    this.language,
    this.basicDefinition,
  });
  
  /// Show as a bottom sheet
  static Future<void> show(BuildContext context, {
    required String term,
    String? language,
    String? basicDefinition,
  }) {
    HapticFeedback.lightImpact();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => WordStudySheet(
          term: term,
          language: language,
          basicDefinition: basicDefinition,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final definitionAsync = ref.watch(wordDefinitionProvider(term));
    final accentColor = MentorDesign.languageColor(language ?? 'greek');
    
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Stack(
        children: [
          // Blur background
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.transparent),
          ),
          // Glass container
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.3),
                width: 1.5,
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1E1E1E).withValues(alpha: 0.95),
                  const Color(0xFF0A0A0A).withValues(alpha: 0.98),
                ],
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Grab handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Term header
                  _buildTermHeader(accentColor),
                  const SizedBox(height: 24),
                  
                  // Quick definition (basic)
                  if (basicDefinition != null) ...[
                    _buildBasicDefinition(),
                    const SizedBox(height: 24),
                  ],
                  
                  // AI-powered deep definition
                  _buildAiDefinition(definitionAsync, accentColor),
                  
                  const SizedBox(height: 32),
                  
                  // Related verses section
                  _buildRelatedVersesSection(accentColor),
                  
                  const SizedBox(height: 32),
                  
                  // Study actions
                  _buildStudyActions(context, accentColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTermHeader(Color accentColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accentColor.withValues(alpha: 0.3)),
          ),
          child: Text(
            term.substring(0, 1).toUpperCase(),
            style: GoogleFonts.lora(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                term,
                style: GoogleFonts.lora(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (language != null)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    language!,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(LucideIcons.bookmark, color: Colors.white38),
          onPressed: () {
            HapticFeedback.lightImpact();
            // TODO: Save to personal concordance
          },
        ),
      ],
    );
  }
  
  Widget _buildBasicDefinition() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.book, color: Colors.white38, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              basicDefinition!,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAiDefinition(AsyncValue<String> definitionAsync, Color accentColor) {
    return definitionAsync.when(
      loading: () => _buildDefinitionLoading(accentColor),
      error: (e, _) => _buildDefinitionError(),
      data: (definition) => _buildDefinitionContent(definition, accentColor),
    );
  }
  
  Widget _buildDefinitionLoading(Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withValues(alpha: 0.1),
            accentColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Generating insight...',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: accentColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Shimmer placeholder lines
          Container(
            width: double.infinity,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 200,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDefinitionContent(String definition, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withValues(alpha: 0.1),
            accentColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.sparkles, color: accentColor, size: 18),
              const SizedBox(width: 8),
              Text(
                'Scholar\'s Insight',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            definition,
            style: GoogleFonts.lora(
              fontSize: 15,
              color: Colors.white,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDefinitionError() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.alertCircle, color: Colors.red, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Unable to load insight. Check your connection.',
              style: GoogleFonts.inter(fontSize: 13, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRelatedVersesSection(Color accentColor) {
    // Placeholder - in production, query verses containing this term
    final mockVerses = [
      'John 1:1 - "In the beginning was the Word..."',
      'John 1:14 - "The Word became flesh..."',
      'Hebrews 4:12 - "The word of God is living..."',
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'VERSES CONTAINING "${term.toUpperCase()}"',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: Colors.white38,
          ),
        ),
        const SizedBox(height: 12),
        ...mockVerses.map((verse) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                HapticFeedback.lightImpact();
                // TODO: Navigate to verse in Bible reader
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.bookOpen, size: 16, color: accentColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        verse,
                        style: GoogleFonts.lora(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(LucideIcons.chevronRight, size: 16, color: Colors.white24),
                  ],
                ),
              ),
            ),
          ),
        )).toList(),
      ],
    );
  }
  
  Widget _buildStudyActions(BuildContext context, Color accentColor) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              HapticFeedback.lightImpact();
              // TODO: Deepen study with Claude
            },
            icon: const Icon(LucideIcons.brain, size: 18),
            label: const Text('Deepen Study'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            icon: const Icon(LucideIcons.check, size: 18),
            label: const Text('Done'),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
