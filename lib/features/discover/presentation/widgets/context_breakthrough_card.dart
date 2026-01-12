import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../../../../services/stuck_detector_service.dart';
import '../../../../services/ai_mentor_service.dart';

/// Context Breakthrough Card
/// Displayed when user is stuck in their reading for 3+ days
/// Provides AI-generated historical context tailored to their emotional state
class ContextBreakthroughCard extends ConsumerStatefulWidget {
  final StuckStatus stuckStatus;

  const ContextBreakthroughCard({
    super.key,
    required this.stuckStatus,
  });

  @override
  ConsumerState<ContextBreakthroughCard> createState() => _ContextBreakthroughCardState();
}

class _ContextBreakthroughCardState extends ConsumerState<ContextBreakthroughCard> {
  String? _contextInsight;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContextInsight();
  }

  Future<void> _loadContextInsight() async {
    final aiMentor = ref.read(aiMentorServiceProvider);
    
    try {
      final insight = await aiMentor.getContextBreakthrough(
        book: widget.stuckStatus.lastBook,
        chapter: widget.stuckStatus.lastChapter,
        emotionalState: widget.stuckStatus.dominantEmotion,
      );
      
      if (mounted) {
        setState(() {
          _contextInsight = insight;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _contextInsight = 'Could not load context. Please try again later.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.orange.withValues(alpha: 0.2),
                  Colors.deepOrange.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.orange.withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline,
                        color: Colors.orangeAccent,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CONTEXT BREAKTHROUGH',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              color: Colors.orangeAccent,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Stuck in ${widget.stuckStatus.lastBook}? Here\'s the Historical Backdrop',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Days since progress badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    '${widget.stuckStatus.daysSinceProgress} days since last progress',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // AI-generated context
                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(
                        color: Colors.orangeAccent,
                      ),
                    ),
                  )
                else
                  Text(
                    _contextInsight ?? '',
                    style: GoogleFonts.lora(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.95),
                      height: 1.6,
                    ),
                  ),

                const SizedBox(height: 16),

                // Action hint
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 16,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Feeling ready? Continue reading ${widget.stuckStatus.lastBook} or explore the timeline below.',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.6),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
