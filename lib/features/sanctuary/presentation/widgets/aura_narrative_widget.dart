import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui';

import '../../../../services/qwen_service.dart';
import '../../../journal/presentation/journal_providers.dart';

/// Provider for the Aura Narrative text
/// 
/// Generates a 15-word summary of the user's weekly spiritual journey
/// using Qwen 2.5 on-device AI.
final auraNarrativeProvider = FutureProvider<String>((ref) async {
  final entriesAsync = ref.watch(journalEntriesProvider);
  
  return entriesAsync.when(
    data: (entries) async {
      if (entries.isEmpty) {
        return "Your spiritual journey awaits. Begin reflecting to see your story unfold.";
      }
      
      // Get last 7 days of entries
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));
      final recentEntries = entries
          .where((e) => e.createdAt.isAfter(weekAgo))
          .take(7)
          .map((e) => e.content)
          .toList();
      
      if (recentEntries.isEmpty) {
        return "A new week begins. What truth will you discover today?";
      }
      
      try {
        final qwenService = ref.read(qwenServiceProvider);
        return await qwenService.getJourneySummary(recentEntries);
      } catch (e) {
        // Fallback when Qwen is unavailable
        return "Your journey continues. Each reflection brings new insight.";
      }
    },
    loading: () async => "Reading your journey...",
    error: (_, __) async => "Your spiritual journey unfolds each day.",
  );
});

/// Aura Narrative Widget
/// 
/// Displays a glassmorphic ribbon with AI-generated summary of
/// the user's recent spiritual journey. Uses Qwen for instant generation.
class AuraNarrativeWidget extends ConsumerWidget {
  const AuraNarrativeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final narrativeAsync = ref.watch(auraNarrativeProvider);
    
    return narrativeAsync.when(
      data: (text) => _buildRibbon(text),
      loading: () => _buildRibbon("Reflecting on your journey..."),
      error: (_, __) => _buildRibbon("Your story continues to unfold."),
    );
  }
  
  Widget _buildRibbon(String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF12121E).withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              // Sparkle icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00F2FF).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.sparkles,
                  size: 16,
                  color: Color(0xFF00F2FF),
                ),
              ),
              const SizedBox(width: 12),
              
              // Narrative text
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.lora(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact version of Aura Narrative for headers
class AuraNarrativeCompact extends ConsumerWidget {
  const AuraNarrativeCompact({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final narrativeAsync = ref.watch(auraNarrativeProvider);
    
    return narrativeAsync.when(
      data: (text) => _buildCompact(text),
      loading: () => _buildCompact("..."),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
  
  Widget _buildCompact(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          LucideIcons.sparkles,
          size: 12,
          color: Color(0xFF00F2FF),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: GoogleFonts.lora(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.white54,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
