import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'dart:convert';

import '../../../core/database/app_database.dart'; // Access to DB and Tables
import '../../journal/presentation/journal_providers.dart'; // Access appDatabaseProvider
import '../../journal/data/journal_repository.dart'; // For theme-filtered entries
import '../presentation/widgets/journey_card.dart'; // Journey model


// --- Models ---

class MentorThread {
  final int id;
  final String title; // Usually the verse reference
  final String snippet; // Brief summary or first line of insight
  final DateTime updatedAt;
  final bool hasAiInsight;
  final String? theme; // Extracted theme for grouping

  MentorThread({
    required this.id,
    required this.title,
    required this.snippet,
    required this.updatedAt,
    required this.hasAiInsight,
    this.theme,
  });
  
  String get timeAgo {
    final diff = DateTime.now().difference(updatedAt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return 'Just now';
  }
}

class LinguisticTerm {
  final String term; // e.g., "Logos"
  final String definition; // e.g., "The Word, Reason"
  final String language; // "Greek" or "Hebrew"

  LinguisticTerm({required this.term, required this.definition, required this.language});
}

// --- Providers ---

/// 1. Thread Registry Provider
/// Aggregates both Journal Entries (with verse refs) and AI Interactions
final threadHistoryProvider = FutureProvider<List<MentorThread>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  
  // A. Fetch recent Journal Entries that have a verse reference
  final journalThreads = await (db.select(db.journalEntries)
    ..where((t) => t.verseReference.isNotNull())
    ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
    ..limit(10)).get();

  // B. Fetch recent AI Interactions
  final aiThreads = await (db.select(db.aiInteractions)
    ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
    ..limit(10)).get();

  // C. Merge and Deduplicate based on Verse Reference
  // Ideally, we group by Verse Reference.
  // For MVP, we'll just map them and list them. Better UX: Group by verse.
  
  final Map<String, MentorThread> threadMap = {};

  // Process AI Interactions first (usually richer content)
  for (final ai in aiThreads) {
    if (!threadMap.containsKey(ai.verseReference)) {
      String snippet = "Deep dive into context...";
      try {
        final jsonMap = json.decode(ai.aiResponse);
        if (jsonMap is Map && jsonMap.containsKey('naturalMeaning')) {
             snippet = jsonMap['naturalMeaning'].toString().split('.').first;
        }
      } catch (_) {}
      
      threadMap[ai.verseReference] = MentorThread(
        id: ai.id,
        title: ai.verseReference,
        snippet: snippet,
        updatedAt: ai.createdAt,
        hasAiInsight: true,
        theme: _extractTheme(ai.verseReference, snippet),
      );
    }
  }

  // Process Journal Entries (override or add if new)
  // If we already have the verse from AI, we ideally want to show we have BOTH.
  // But for simple list, let's just ensure we have the latest timestamp.
  for (final je in journalThreads) {
    final verse = je.verseReference!;
    if (threadMap.containsKey(verse)) {
       // Update timestamp if newer
       if (je.createdAt.isAfter(threadMap[verse]!.updatedAt)) {
         final existing = threadMap[verse]!;
         threadMap[verse] = MentorThread(
           id: existing.id, // Keep AI ID reference preferred? Or just use arbitrary unique.
           title: existing.title,
           snippet: je.content.length > 30 ? '${je.content.substring(0, 30)}...' : je.content,
           updatedAt: je.createdAt,
           hasAiInsight: true, // We know AI exists
           theme: existing.theme,
         );
       }
    } else {
      // New thread from Journal only
      threadMap[verse] = MentorThread(
        id: je.id,
        title: verse,
        snippet: je.content.length > 30 ? '${je.content.substring(0, 30)}...' : je.content,
        updatedAt: je.createdAt,
        hasAiInsight: false,
        theme: _extractTheme(verse, je.content),
      );
    }
  }
  
  final sortedList = threadMap.values.toList()
    ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

  return sortedList;
});

/// Helper to extract theme from verse reference or content
String? _extractTheme(String verseRef, String content) {
  final lower = (verseRef + ' ' + content).toLowerCase();
  
  // Match common biblical themes
  if (lower.contains('love') || lower.contains('agape')) return 'Love';
  if (lower.contains('peace') || lower.contains('shalom')) return 'Peace';
  if (lower.contains('faith') || lower.contains('trust') || lower.contains('believe')) return 'Faith';
  if (lower.contains('patience') || lower.contains('wait')) return 'Patience';
  if (lower.contains('hope')) return 'Hope';
  if (lower.contains('joy') || lower.contains('rejoice')) return 'Joy';
  if (lower.contains('grace')) return 'Grace';
  if (lower.contains('mercy')) return 'Mercy';
  if (lower.contains('truth') || lower.contains('logos')) return 'Truth';
  if (lower.contains('life') || lower.contains('zoe')) return 'Life';
  if (lower.contains('god') || lower.contains('theos')) return 'God';
  if (lower.contains('identity') || lower.contains('who i am')) return 'Identity';
  if (lower.contains('work') || lower.contains('calling')) return 'Work';
  
  return null;
}

/// 2. Journey Groups Provider
/// Groups threads by theme for the new Journeys view
final journeyGroupsProvider = FutureProvider<List<Journey>>((ref) async {
  final threads = await ref.watch(threadHistoryProvider.future);
  
  // Group threads by theme
  final Map<String, List<MentorThread>> themeGroups = {};
  
  for (final thread in threads) {
    final theme = thread.theme ?? 'Uncategorized';
    themeGroups.putIfAbsent(theme, () => []);
    themeGroups[theme]!.add(thread);
  }
  
  // Convert to Journey objects
  final journeys = <Journey>[];
  
  for (final entry in themeGroups.entries) {
    final threadList = entry.value;
    if (threadList.isEmpty) continue;
    
    // Count different types
    final reflectionCount = threadList.where((t) => !t.hasAiInsight).length;
    final verseCount = threadList.length;
    final questionCount = threadList.where((t) => t.hasAiInsight).length;
    
    // Get latest activity
    final lastActivity = threadList
        .map((t) => t.updatedAt)
        .reduce((a, b) => a.isAfter(b) ? a : b);
    
    // Get recent snippets
    final snippets = threadList
        .take(3)
        .map((t) => t.snippet)
        .toList();
    
    journeys.add(Journey(
      theme: entry.key,
      reflectionCount: reflectionCount,
      verseCount: verseCount,
      questionCount: questionCount,
      lastActivity: lastActivity,
      recentSnippets: snippets,
    ));
  }
  
  // Sort by last activity
  journeys.sort((a, b) => b.lastActivity.compareTo(a.lastActivity));
  
  return journeys;
});

/// Provider that fetches journal entries filtered by theme keywords
/// Used in Look Back tab to show real user reflections
final journalEntriesByThemeProvider = StreamProvider.family<List<JournalEntry>, String>((ref, theme) {
  final db = ref.watch(appDatabaseProvider);
  final repo = JournalRepository(db);
  
  // Get all entries and filter client-side by theme keywords
  return repo.watchAllEntries().map((entries) {
    final themeKeywords = theme.toLowerCase().split(' ');
    
    return entries.where((entry) {
      final content = entry.content.toLowerCase();
      final verse = entry.verseReference?.toLowerCase() ?? '';
      
      // Match if content or verse contains any theme keyword
      return themeKeywords.any((keyword) => 
        content.contains(keyword) || verse.contains(keyword)
      );
    }).toList();
  });
});

/// 3. Linguistic Service Provider
/// Parses AI logs to extract Greek/Hebrew terms
final linguisticTermsProvider = FutureProvider<List<LinguisticTerm>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  
  // Get all AI interactions
  final logs = await (db.select(db.aiInteractions)..limit(20)).get();
  
  final Set<String> uniqueTerms = {};
  final List<LinguisticTerm> terms = [];
  
  for (final log in logs) {
    try {
        final jsonMap = json.decode(log.aiResponse);
        final originalContext = jsonMap['originalContext'] as String? ?? "";
        
        // Regex to find terms in parentheses like "(Logos)" or "Greek: Logos"
        // This is a naive extraction for the MVP.
        // Stronger prompt engineering in `AiMentorService` would structure this better.
        // For now, let's look for capitalized words inside parentheses.
        final regex = RegExp(r'\(([A-Z][a-z]+)\)');
        final matches = regex.allMatches(originalContext);
        
        for (final match in matches) {
          final term = match.group(1);
          if (term != null && !uniqueTerms.contains(term) && term.length > 2) {
             uniqueTerms.add(term);
             terms.add(LinguisticTerm(
               term: term,
               definition: "From ${log.verseReference}",
               language: "Original",
             ));
          }
        }
    } catch (_) {
      continue;
    }
  }
  
  if (terms.isEmpty) {
    // Return expanded seed data with 15 common biblical terms
    return [
      // Greek terms
      LinguisticTerm(term: "Logos", definition: "The Word", language: "Greek"),
      LinguisticTerm(term: "Agape", definition: "Unconditional Love", language: "Greek"),
      LinguisticTerm(term: "Pistis", definition: "Faith/Trust", language: "Greek"),
      LinguisticTerm(term: "Charis", definition: "Grace", language: "Greek"),
      LinguisticTerm(term: "Eirene", definition: "Peace", language: "Greek"),
      LinguisticTerm(term: "Zoe", definition: "Life (Eternal)", language: "Greek"),
      LinguisticTerm(term: "Theos", definition: "God", language: "Greek"),
      LinguisticTerm(term: "Pneuma", definition: "Spirit/Breath", language: "Greek"),
      LinguisticTerm(term: "Sozo", definition: "Save/Heal/Deliver", language: "Greek"),
      LinguisticTerm(term: "Doxa", definition: "Glory", language: "Greek"),
      // Hebrew terms
      LinguisticTerm(term: "Shalom", definition: "Peace/Wholeness", language: "Hebrew"),
      LinguisticTerm(term: "Hesed", definition: "Steadfast Love", language: "Hebrew"),
      LinguisticTerm(term: "Ruach", definition: "Spirit/Wind", language: "Hebrew"),
      LinguisticTerm(term: "Shema", definition: "Hear/Obey", language: "Hebrew"),
      LinguisticTerm(term: "Amen", definition: "Truth/So be it", language: "Hebrew"),
    ];
  }

  return terms;
});

