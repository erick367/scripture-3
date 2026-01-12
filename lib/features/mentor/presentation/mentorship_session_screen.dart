import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui' as ui;
import 'widgets/mentor_design.dart';
import 'widgets/journey_card.dart';
import '../../../services/ai_mentor_service.dart';
import '../../../services/prayer_service.dart';
import '../../journal/presentation/widgets/journal_entry_editor.dart';
import '../../bible/presentation/bible_reader_screen.dart';
import '../application/mentor_providers.dart'; // For journalEntriesByThemeProvider
import 'widgets/look_forward_note_sheet.dart';

/// Provider for Qwen-powered theme definition
final themeDefinitionProvider = FutureProvider.family<String, String>((ref, theme) async {
  final service = ref.read(aiMentorServiceProvider);
  return service.getSimpleDefinition(theme);
});

/// DBS (Discovery Bible Study) session with Look Back, Look Up, Look Forward
class MentorshipSessionScreen extends ConsumerStatefulWidget {
  final Journey journey;
  
  const MentorshipSessionScreen({
    super.key,
    required this.journey,
  });

  @override
  ConsumerState<MentorshipSessionScreen> createState() => _MentorshipSessionScreenState();
}

class _MentorshipSessionScreenState extends ConsumerState<MentorshipSessionScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _lookForwardQuestion;
  bool _isLoadingQuestion = false;
  String? _quickPrayer;
  bool _isLoadingPrayer = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadLookForwardQuestion();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _loadLookForwardQuestion() async {
    setState(() => _isLoadingQuestion = true);
    try {
      final service = ref.read(aiMentorServiceProvider);
      final question = await service.getMentorFollowUp(
        'I have been reflecting on ${widget.journey.theme}. '
        'I have ${widget.journey.reflectionCount} reflections on this theme.'
      );
      setState(() {
        _lookForwardQuestion = question;
        _isLoadingQuestion = false;
      });
    } catch (e) {
      setState(() {
        _lookForwardQuestion = 'How might God be inviting you to grow in ${widget.journey.theme}?';
        _isLoadingQuestion = false;
      });
    }
  }
  
  Future<void> _generateQuickPrayer() async {
    setState(() => _isLoadingPrayer = true);
    try {
      final prayerService = ref.read(prayerServiceProvider);
      final prayer = await prayerService.generateQuickPrayer(
        verseReference: 'Psalm 23:1',
        userTheme: widget.journey.theme,
      );
      setState(() {
        _quickPrayer = prayer;
        _isLoadingPrayer = false;
      });
      _showPrayerDialog(prayer);
    } catch (e) {
      setState(() {
        _quickPrayer = 'Father, guide me in my journey of ${widget.journey.theme}. Draw me closer to You. In Jesus\' name, Amen.';
        _isLoadingPrayer = false;
      });
      _showPrayerDialog(_quickPrayer!);
    }
  }
  
  void _showPrayerDialog(String prayer) {
    final themeColor = MentorDesign.themeColor(widget.journey.theme);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: themeColor.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(LucideIcons.heart, color: themeColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Quick Prayer',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: themeColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              prayer,
              style: GoogleFonts.lora(
                fontSize: 18,
                color: Colors.white,
                height: 1.6,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Amen'),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Opens look forward note sheet
  void _openJournalEditor() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LookForwardNoteSheet(
        theme: widget.journey.theme,
        question: _lookForwardQuestion ?? 'How might God be inviting you to grow in ${widget.journey.theme}?',
      ),
    );
  }
  
  /// Navigates to Bible reader
  void _navigateToBibleReader() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BibleReaderScreen()),
    );
  }
  
  /// Shows full verse in a beautiful modal
  void _showFullVerse(Map<String, String> verse, Color themeColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: themeColor.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
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
            
            // Reference badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: themeColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.bookOpen, size: 16, color: themeColor),
                  const SizedBox(width: 8),
                  Text(
                    verse['reference']!,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Full verse text
            Text(
              _getFullVerseText(verse['reference']!),
              style: GoogleFonts.lora(
                fontSize: 20,
                color: Colors.white,
                height: 1.6,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateToBibleReader();
                  },
                  icon: Icon(LucideIcons.book, size: 18, color: themeColor),
                  label: Text('Open in Bible', style: TextStyle(color: themeColor)),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.x, size: 18, color: Colors.white54),
                  label: const Text('Close', style: TextStyle(color: Colors.white54)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  /// Gets full verse text (expanded versions)
  String _getFullVerseText(String reference) {
    // Return expanded verse text based on reference
    switch (reference) {
      case 'Proverbs 3:5-6':
        return 'Trust in the Lord with all your heart, and lean not on your own understanding; in all your ways acknowledge Him, and He shall direct your paths.';
      case 'Psalm 119:105':
        return 'Your word is a lamp to my feet and a light to my path.';
      case 'James 1:3-4':
        return 'Knowing that the testing of your faith produces patience. But let patience have its perfect work, that you may be perfect and complete, lacking nothing.';
      case 'Romans 12:12':
        return 'Rejoicing in hope, patient in tribulation, continuing steadfastly in prayer.';
      case 'Galatians 5:22':
        return 'But the fruit of the Spirit is love, joy, peace, longsuffering, kindness, goodness, faithfulness.';
      case 'Philippians 4:7':
        return 'And the peace of God, which surpasses all understanding, will guard your hearts and minds through Christ Jesus.';
      case 'John 14:27':
        return 'Peace I leave with you, My peace I give to you; not as the world gives do I give to you. Let not your heart be troubled, neither let it be afraid.';
      case 'Isaiah 26:3':
        return 'You will keep him in perfect peace, whose mind is stayed on You, because he trusts in You.';
      case 'Jeremiah 29:11':
        return 'For I know the thoughts that I think toward you, says the Lord, thoughts of peace and not of evil, to give you a future and a hope.';
      default:
        return 'Scripture verse text would appear here.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = MentorDesign.themeColor(widget.journey.theme);
    
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Background with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  themeColor.withValues(alpha: 0.1),
                  const Color(0xFF0A0A0A),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // App bar
                _buildAppBar(themeColor),
                
                // DBS Tab bar - FIXED overflow
                _buildTabBar(themeColor),
                
                const SizedBox(height: 8),
                
                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildLookBackTab(),
                      _buildLookUpTab(themeColor),
                      _buildLookForwardTab(themeColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAppBar(Color themeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              LucideIcons.compass,
              color: themeColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.journey.theme,
                  style: GoogleFonts.lora(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Mentorship Session',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTabBar(Color themeColor) {
    // Clean pill-style tabs without visible indicator outline
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        onTap: (_) => HapticFeedback.selectionClick(),
        indicator: BoxDecoration(
          color: themeColor.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white38,
        labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 13),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Look Back'),
          Tab(text: 'Look Up'),
          Tab(text: 'Forward'),
        ],
      ),
    );
  }
  
  Widget _buildLookBackTab() {
    final themeColor = MentorDesign.themeColor(widget.journey.theme);
    final entriesAsync = ref.watch(journalEntriesByThemeProvider(widget.journey.theme));
    
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Intro message about looking back
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                themeColor.withValues(alpha: 0.1),
                themeColor.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: themeColor.withValues(alpha: 0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(LucideIcons.quote, size: 18, color: themeColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Reflecting on your journey helps you see how God has been working in your life. Your past insights often hold wisdom for today.',
                  style: GoogleFonts.lora(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        Text(
          'YOUR REFLECTIONS ON ${widget.journey.theme.toUpperCase()}',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: Colors.white38,
          ),
        ),
        const SizedBox(height: 16),
        
        // Display real journal entries filtered by theme
        entriesAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          error: (_, __) => _buildEmptyState(),
          data: (entries) {
            if (entries.isEmpty) {
              return _buildEmptyState();
            }
            
            return Column(
              children: entries.take(5).map((entry) {
                final timeDiff = DateTime.now().difference(entry.createdAt);
                int daysAgo;
                
                if (timeDiff.inDays == 0) {
                  daysAgo = 0; // Today
                } else if (timeDiff.inDays == 1) {
                  daysAgo = 1;
                } else {
                  daysAgo = timeDiff.inDays;
                }
                
                return _buildReflectionCard(
                  entry.content,
                  daysAgo: daysAgo,
                  verseRef: entry.verseReference,
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            LucideIcons.bookOpen,
            size: 48,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'No reflections yet on ${widget.journey.theme}',
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
              fontSize: 16,
              color: Colors.white54,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start journaling to build your spiritual journey',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white38,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildReflectionCard(String content, {int daysAgo = 1, String? verseRef}) {
    String timeLabel;
    if (daysAgo == 0) {
      timeLabel = 'Today';
    } else if (daysAgo == 1) {
      timeLabel = '1 day ago';
    } else {
      timeLabel = '$daysAgo days ago';
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.penTool, size: 14, color: Colors.white38),
              const SizedBox(width: 8),
              Text(
                timeLabel,
                style: GoogleFonts.inter(fontSize: 11, color: Colors.white38),
              ),
              if (verseRef != null) ...[
                const Spacer(),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      verseRef,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontSize: 10, color: Colors.amber),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content.length > 120 ? '${content.substring(0, 120)}...' : content,
            style: GoogleFonts.lora(
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLookUpTab(Color themeColor) {
    // Use Qwen for instant theme definition
    final definitionAsync = ref.watch(themeDefinitionProvider(widget.journey.theme));
    
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'SCRIPTURE ON ${widget.journey.theme.toUpperCase()}',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: Colors.white38,
          ),
        ),
        const SizedBox(height: 16),
        
        // Qwen-powered insight card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                themeColor.withValues(alpha: 0.15),
                themeColor.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: themeColor.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.sparkles, color: themeColor, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Mentor\'s Insight',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: themeColor,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '⚡ Qwen',
                      style: GoogleFonts.inter(fontSize: 9, color: Colors.green),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              definitionAsync.when(
                loading: () => Row(
                  children: [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Generating insight...',
                      style: GoogleFonts.inter(fontSize: 12, color: themeColor),
                    ),
                  ],
                ),
                error: (_, __) => Text(
                  _getThemeInsight(widget.journey.theme),
                  style: GoogleFonts.lora(fontSize: 14, color: Colors.white, height: 1.5),
                ),
                data: (definition) => Text(
                  definition,
                  style: GoogleFonts.lora(fontSize: 14, color: Colors.white, height: 1.5),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        Text(
          'SUGGESTED VERSES',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: Colors.white38,
          ),
        ),
        const SizedBox(height: 12),
        
        ..._getThemeVerses(widget.journey.theme).map((verse) => _buildVerseCard(verse, themeColor)),
      ],
    );
  }
  
  Widget _buildVerseCard(Map<String, String> verse, Color themeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            HapticFeedback.lightImpact();
            _showFullVerse(verse, themeColor);
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: themeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          verse['reference']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: themeColor,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(LucideIcons.chevronRight, size: 14, color: Colors.white24),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  verse['text']!,
                  style: GoogleFonts.lora(
                    fontSize: 13,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildLookForwardTab(Color themeColor) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'NEXT STEPS',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: Colors.white38,
          ),
        ),
        const SizedBox(height: 16),
        
        // AI-generated question
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.amber.withValues(alpha: 0.15),
                Colors.amber.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.helpCircle, color: Colors.amber, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Question for Reflection',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '⚡ Qwen',
                      style: GoogleFonts.inter(fontSize: 9, color: Colors.green),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_isLoadingQuestion)
                Row(
                  children: [
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Generating...',
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.amber),
                    ),
                  ],
                )
              else
                Text(
                  _lookForwardQuestion ?? 'How might God be inviting you to grow in ${widget.journey.theme}?',
                  style: GoogleFonts.lora(fontSize: 15, color: Colors.white, height: 1.5),
                ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Action buttons - Just Journal and Quick Prayer
        _buildActionCard(
          icon: LucideIcons.penTool,
          title: 'Journal Response',
          subtitle: 'Write your thoughts',
          color: themeColor,
          onTap: () {
            HapticFeedback.lightImpact();
            _openJournalEditor();
          },
        ),
        
        _buildActionCard(
          icon: LucideIcons.heart,
          title: 'Quick Prayer',
          subtitle: _isLoadingPrayer ? 'Generating...' : 'Generate a prayer',
          color: Colors.pinkAccent,
          isLoading: _isLoadingPrayer,
          badge: '⚡ Qwen',
          onTap: _isLoadingPrayer ? () {} : _generateQuickPrayer,
        ),
      ],
    );
  }
  
  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isLoading = false,
    String? badge,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                          ),
                        )
                      : Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          if (badge != null) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                badge,
                                style: GoogleFonts.inter(fontSize: 8, color: Colors.green),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(fontSize: 11, color: Colors.white54),
                      ),
                    ],
                  ),
                ),
                const Icon(LucideIcons.chevronRight, color: Colors.white24, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  String _getThemeInsight(String theme) {
    final lower = theme.toLowerCase();
    if (lower.contains('patience')) {
      return 'Patience (Greek: makrothymia) means "long-suffering"—the ability to wait for God\'s timing without losing heart.';
    }
    if (lower.contains('peace')) {
      return 'Peace (Hebrew: shalom) is complete wholeness and well-being. Jesus offers peace "not as the world gives."';
    }
    if (lower.contains('trust') || lower.contains('faith')) {
      return 'Faith (Greek: pistis) is confident assurance in God\'s promises—"the substance of things hoped for."';
    }
    if (lower.contains('love')) {
      return 'Agape love (Greek: ἀγάπη) is unconditional, sacrificial love—the kind God demonstrates.';
    }
    return 'Your journey with $theme reflects a deep desire to grow spiritually in this area.';
  }
  
  List<Map<String, String>> _getThemeVerses(String theme) {
    final lower = theme.toLowerCase();
    if (lower.contains('patience')) {
      return [
        {'reference': 'James 1:3-4', 'text': 'The testing of your faith produces patience...'},
        {'reference': 'Romans 12:12', 'text': 'Rejoicing in hope, patient in tribulation...'},
      ];
    }
    if (lower.contains('peace')) {
      return [
        {'reference': 'Philippians 4:7', 'text': 'The peace of God surpasses all understanding...'},
        {'reference': 'John 14:27', 'text': 'Peace I leave with you, My peace I give to you...'},
      ];
    }
    return [
      {'reference': 'Proverbs 3:5-6', 'text': 'Trust in the Lord with all your heart...'},
      {'reference': 'Psalm 119:105', 'text': 'Your word is a lamp to my feet...'},
    ];
  }
}
