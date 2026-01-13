import '../models/verse_insight.dart';

/// Domain interface for AI intelligence operations
/// 
/// This defines the contract for all AI-powered features in ScriptureLens.
/// Implementations can use different AI backends (Qwen on-device, Claude cloud)
/// while the domain layer remains agnostic to the specific implementation.
abstract class AIService {
  // ═══════════════════════════════════════════════════════════════════════════
  // L1: On-Device Operations (Qwen 2.5 0.5B - <250ms)
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Generate an instant 1-2 sentence preview for a verse
  /// 
  /// Returns quickly (<250ms) while deeper insights load in background.
  /// Returns null if on-device AI is unavailable.
  Future<String?> getInstantPreview({
    required String verseText,
    required String verseReference,
  });
  
  /// Stream instant preview for typing effect
  Stream<String> getInstantPreviewStream({
    required String verseText,
    required String verseReference,
  });
  
  /// Extract search keywords from a user feeling/phrase
  /// 
  /// Example: "I feel anxious about work" → ["anxiety", "work", "stress"]
  Future<List<String>> extractSearchKeywords(String feeling);
  
  /// Get a simple definition for a biblical term
  /// 
  /// Returns 2-3 sentence definition with original language insight.
  Future<String> getSimpleDefinition(String term);
  
  /// Rewrite a verse in simple, modern English
  Future<String> simplifyVerse(String verseText);
  
  /// Generate the geometry state for Soul Sphere based on sentiment scores
  /// 
  /// Returns state ID: "Peaceful", "Jagged", or "Radiant"
  Future<String> getGeometryState(List<double> scores);
  
  /// Summarize weekly journey into a 15-word "Aura Narrative"
  Future<String> getJourneySummary(List<String> entries);
  
  // ═══════════════════════════════════════════════════════════════════════════
  // L2: Cloud Operations (Claude 3.5 Sonnet - 2-4s)
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Get full AI-powered insight for a Bible verse
  /// 
  /// Returns a complete [VerseInsight] with meaning, application, and threads.
  Future<VerseInsight> getVerseInsight({
    required String verseText,
    required String verseReference,
    List<String> userThreads = const [],
    bool isAppliedMode = false,
  });
  
  /// Stream verse insights progressively as they generate
  Stream<VerseInsight> getVerseInsightStream({
    required String verseText,
    required String verseReference,
    List<String> userThreads = const [],
    bool isAppliedMode = false,
  });
  
  /// Generate a short, empathetic follow-up question
  /// 
  /// Used on Home Screen to encourage continued reflection.
  Future<String> getMentorFollowUp(String userContent);
  
  /// Generate personalized prayer based on context and theme
  Future<String> generatePrayer(String context, String theme);
  
  /// Get historical context for archaeological discoveries
  Future<String> getDiscoveryContext({
    required String discoveryName,
    required String connectedVerse,
    required String description,
  });
  
  /// Get context breakthrough for users stuck on a passage
  Future<String> getContextBreakthrough({
    required String book,
    required String chapter,
    required String emotionalState,
  });
  
  /// Compare user's summary to actual text with gentle correction
  Future<String> getScholarCorrection({
    required String passageReference,
    required String actualText,
    required String userRetelling,
  });
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Service Status
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Check if on-device AI is available
  Future<bool> isOnDeviceAvailable();
  
  /// Check if cloud AI is available (online + API key present)
  Future<bool> isCloudAvailable();
}
