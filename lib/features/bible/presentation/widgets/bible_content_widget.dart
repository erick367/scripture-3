import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/bible_verse.dart';
import '../state/bible_reader_state.dart';

import 'bridge_toggle_widget.dart';
import 'ai_mentor_panel.dart';
import 'chronological_slider_widget.dart';
import '../../../../services/ai_preloader_service.dart';
import '../../../../services/ai_mentor_service.dart';
import '../../../search/presentation/search_screen.dart';

class BibleContentWidget extends ConsumerWidget {
  const BibleContentWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize AI Preloader (Silent Anticipation)
    ref.watch(aiPreloaderServiceProvider);

    final state = ref.watch(bibleReaderStateProvider);
    final passageAsync = ref.watch(currentPassageProvider);

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -0.5),
              radius: 1.0,
              colors: [
                Colors.amber.withValues(alpha: 0.15),
                Colors.transparent,
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               const CircleAvatar(
                foregroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                radius: 16,
              ),
              Text(
                'ScriptureLens AI',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.amber.withValues(alpha: 0.3),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(LucideIcons.flame, color: Colors.orange, size: 20),
                  const SizedBox(width: 4),
                  Text('Streak', style: GoogleFonts.inter(color: Colors.white, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
        
        // Search Bar Placeholder
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.search, color: Colors.white54, size: 18),
                const SizedBox(width: 8),
                Text('Search / How\'re you feeling?', style: GoogleFonts.inter(color: Colors.white54)),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Bible Text Content
        Expanded(
          child: passageAsync.when(
            data: (passage) {
              // Watch reflected verses for Golden Glow
              final reflectedAsync = ref.watch(reflectedVersesProvider);
              final reflectedRefs = reflectedAsync.valueOrNull ?? {};
              return _buildPassageView(context, ref, passage, state.isAppliedMode, reflectedRefs, state.currentVersion);
            },
            loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
            error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
          ),
        ),

        // Bottom Controls
        Container(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              BridgeToggleWidget(
                isAppliedMode: state.isAppliedMode,
                onToggle: (val) => ref.read(bibleReaderStateProvider.notifier).toggleBridgeMode(),
              ),
              const SizedBox(height: 16),
              ChronologicalSliderWidget(
                currentBook: state.currentBook,
                currentChapter: state.currentChapter,
                currentVersion: state.currentVersion,
                onBookChanged: (book) => ref.read(bibleReaderStateProvider.notifier).setBook(book),
                onChapterChanged: (chapter) => ref.read(bibleReaderStateProvider.notifier).setChapter(chapter),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPassageView(BuildContext context, WidgetRef ref, BiblePassage passage, bool isAppliedMode, Set<String> reflectedRefs, String version) {
    if (passage.verses.isEmpty) {
      return Center(
        child: Text(
          'No content available for ${passage.book} yet.',
           style: GoogleFonts.lora(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return ListView(
      // Key ensures scroll position is preserved when toggling modes
      key: PageStorageKey('passage_list_${passage.book}_${passage.chapter}_$version'),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      children: [
        Text(
          '${passage.book} Chapter ${passage.chapter} ($version)',
          style: GoogleFonts.lora(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        ...passage.verses.map((verse) => _buildVerseText(context, ref, verse, isAppliedMode, reflectedRefs)),
      ],
    );
  }

  Widget _buildVerseText(BuildContext context, WidgetRef ref, BibleVerse verse, bool isAppliedMode, Set<String> reflectedRefs) {
    // Check if this verse has a journal reflection
    final verseRef = '${verse.book} ${verse.chapter}:${verse.verse}';
    final hasReflection = reflectedRefs.any((ref) => ref.contains(verseRef));
    List<InlineSpan> spans = [];
    String remainingText = verse.text;
    List<String> words = remainingText.split(' ');
    
    for (String word in words) {
        // Simplified: just render the word without inline insight icons
        spans.add(TextSpan(
          text: '$word ',
          style: GoogleFonts.lora(
            fontSize: 18,
            height: 1.6,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ));
    }

    // Create a mock InsightKeyword for the full verse
    final verseKeyword = InsightKeyword(
      word: '${verse.book} ${verse.chapter}:${verse.verse}',
      originalWord: verse.text.substring(0, verse.text.length > 50 ? 50 : verse.text.length),
      definition: verse.text,
      pronunciation: '',
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: hasReflection ? BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withValues(alpha: 0.2),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ) : null,
        padding: hasReflection ? const EdgeInsets.all(8) : null,
        child: GestureDetector(
          onLongPress: () {
            HapticFeedback.mediumImpact();
            _showInsightPanel(context, verseKeyword);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                 width: 20,
                 padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${verse.verse}',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: hasReflection ? Colors.amber : Colors.white38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(children: spans),
                ),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _showInsightPanel(context, verseKeyword);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                  child: Icon(
                    hasReflection ? LucideIcons.bookmark : LucideIcons.search,
                    size: 20, // Increased from 16
                    color: hasReflection ? Colors.amber : Colors.amber.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Keeping the simplify logic in code but unused for now as per user request to remove button
  Future<void> _showSimplifyDialog(BuildContext context, WidgetRef ref, String verseText) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    try {
      final simplified = await ref.read(aiMentorServiceProvider).simplifyVerse(verseText);
      
      if (context.mounted) {
        Navigator.pop(context); // Close loader
        
        showDialog(
          context: context,
          builder: (c) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text('Simply Put:', style: GoogleFonts.lora(color: Colors.white)),
            content: Text(
              simplified,
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 16, height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c),
                child: const Text('Got it'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
    }
  }

  void _showInsightPanel(BuildContext context, InsightKeyword keyword) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, 
      builder: (context) => AiMentorPanel(keyword: keyword),
    );
  }
}
