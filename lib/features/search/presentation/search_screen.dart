import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/database/app_database.dart';
import '../../bible/presentation/state/bible_reader_state.dart';
import '../../journal/presentation/journal_providers.dart';
import '../../../../services/ai_mentor_service.dart';
import '../../../../services/heuristic_router.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  List<Verse> _results = [];
  List<String> _aiKeywords = [];
  bool _isLoading = false;
  bool _isAiAnalyzing = false;
  String? _statusMessage;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _results = [];
      _aiKeywords = [];
      _statusMessage = null;
    });

    try {
      final db = ref.read(appDatabaseProvider);
      final router = ref.read(heuristicRouterProvider);
      final bibleState = ref.read(bibleReaderStateProvider);
      
      // L0: Try Heuristic Router first for instant verse jumps (<1ms)
      final location = router.parseReference(
        query,
        currentBook: bibleState.currentBook,
        currentChapter: bibleState.currentChapter,
      );
      
      if (location != null) {
        // Direct verse navigation - instant!
        HapticFeedback.selectionClick();
        ref.read(bibleReaderStateProvider.notifier).setBook(location.book);
        ref.read(bibleReaderStateProvider.notifier).setChapter(location.chapter);
        if (mounted) Navigator.pop(context);
        return;
      }
      
      // Check if it's a "Feeling" (Natural Language)
      // Heuristic: If >= 3 words and doesn't look like a reference (e.g. "John 3")
      final isNaturalLanguage = query.split(' ').length >= 3 && !RegExp(r'\d').hasMatch(query);

      if (isNaturalLanguage) {
        setState(() {
          _isAiAnalyzing = true;
          _statusMessage = "Consulting AI Mentor...";
        });

        // 1. Extract Keywords using Qwen (L1)
        final keywords = await ref.read(aiMentorServiceProvider).extractSearchKeywords(query);
        
        if (mounted) {
           setState(() {
            _aiKeywords = keywords;
            _isAiAnalyzing = false;
            _statusMessage = "Searching Scripture...";
          });
        }

        // 2. Search for the primary keyword (or first 2)
        if (keywords.isNotEmpty) {
          // Priority search on first keyword
          final results = await db.searchVerses(keywords.first);
          if (mounted) {
            setState(() {
              _results = results;
            });
          }
        }
      } else {
        // Direct Keyword Search - Try exact first, then fuzzy
        var results = await db.searchVerses(query);
        
        // If no results, try fuzzy search (handles typos)
        if (results.isEmpty) {
          results = await db.searchVersesFuzzy(query);
          
          if (mounted && results.isNotEmpty) {
            setState(() {
              _statusMessage = "Showing closest matches";
            });
          }
        }
        
        if (mounted) {
          setState(() {
            _results = results;
            if (results.isEmpty) {
              _statusMessage = "No matches found. Try a different spelling or phrase.";
            }
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _statusMessage = "Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Deep dark background
      body: SafeArea(
        child: Column(
          children: [
            // Glassmorphic Search Header
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Back Button
                  IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                    icon: const Icon(LucideIcons.arrowLeft, color: Colors.white70, size: 22),
                  ),
                  // Search Icon
                  const Icon(LucideIcons.search, color: Colors.amber, size: 20),
                  const SizedBox(width: 12),
                  // Search Input
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: "Search / How're you feeling?",
                        hintStyle: GoogleFonts.inter(
                          color: Colors.white38,
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onSubmitted: _performSearch,
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                  // Loading Indicator
                  if (_isLoading && !_isAiAnalyzing)
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.amber.withValues(alpha: 0.8)),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // AI Status / Chips
            if (_isAiAnalyzing || _aiKeywords.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.amber.withValues(alpha: 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isAiAnalyzing)
                      Row(
                        children: [
                          const Icon(LucideIcons.sparkles, color: Colors.amber, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            "Analyzing emotion...",
                            style: GoogleFonts.inter(color: Colors.amber, fontSize: 12),
                          ),
                        ],
                      ),
                    if (_aiKeywords.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        children: [
                          Text("Searching for:", style: GoogleFonts.inter(color: Colors.white54, fontSize: 12)),
                          ..._aiKeywords.map((k) => Chip(
                            label: Text(k, style: GoogleFonts.inter(fontSize: 12)),
                            backgroundColor: Colors.amber.withValues(alpha: 0.2),
                            labelPadding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          ))
                        ],
                      )
                  ],
                ),
              ),

            // Smart Suggestions (Popular Topics & Feelings)
            if (_results.isEmpty && !_isLoading)
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Popular searches",
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'Hope', 'Faith', 'Love', 'Peace', 'Joy', 'Strength',
                        'I feel anxious', 'I feel lonely', 'I need guidance',
                      ].map((suggestion) => GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _searchController.text = suggestion;
                          _performSearch(suggestion);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.1),
                                Colors.white.withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Text(
                            suggestion,
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                ),
              ),

            // Results List
            Expanded(
              child: _results.isEmpty 
                  ? Center(
                      child: _statusMessage != null 
                        ? Text(_statusMessage!, style: GoogleFonts.inter(color: Colors.white38))
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.search,
                                size: 64,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Try 'Hope' or 'I feel lonely'",
                                style: GoogleFonts.inter(
                                  color: Colors.white24,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        final verse = _results[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withValues(alpha: 0.08),
                                Colors.white.withValues(alpha: 0.03),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.amber.withValues(alpha: 0.15),
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            title: Row(
                              children: [
                                Icon(
                                  LucideIcons.bookmark,
                                  size: 14,
                                  color: Colors.amber.withValues(alpha: 0.8),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${verse.book} ${verse.chapter}:${verse.verse}',
                                  style: GoogleFonts.inter(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                verse.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lora(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            onTap: () {
                              HapticFeedback.lightImpact();
                              // Navigate to Reader
                              ref.read(bibleReaderStateProvider.notifier).setBook(verse.book);
                              ref.read(bibleReaderStateProvider.notifier).setChapter(verse.chapter);
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
