/// Domain interface for privacy consent management
/// 
/// Handles explicit user consent for AI features and tracks decisions.
abstract class ConsentManager {
  /// Check if user has granted consent for a specific feature
  Future<bool> hasConsent(ConsentFeature feature);
  
  /// Request consent from user for a feature
  /// 
  /// Returns true if consent was granted, false if denied.
  Future<bool> requestConsent(ConsentFeature feature);
  
  /// Record a consent decision
  Future<void> recordConsent({
    required ConsentFeature feature,
    required bool granted,
  });
  
  /// Revoke previously granted consent
  Future<void> revokeConsent(ConsentFeature feature);
  
  /// Get audit log of consent decisions
  Future<List<ConsentEvent>> getAuditLog({int limit = 50});
  
  /// Run PII scrubbing on text before cloud handoff
  /// 
  /// Removes emails, phone numbers, names, and identifiers.
  Future<String> scrubPII(String rawText);
  
  /// Check if cloud AI features are allowed (global toggle)
  Future<bool> isCloudAIEnabled();
  
  /// Toggle cloud AI features globally
  Future<void> setCloudAIEnabled(bool enabled);
}

/// Features that require explicit consent
enum ConsentFeature {
  /// Send journal entries to Claude for personalized insights
  journalAIAccess,
  
  /// Sync embeddings to Pinecone for semantic search
  pineconeSync,
  
  /// Use on-device sentiment analysis
  sentimentAnalysis,
  
  /// Share anonymized usage data for improvements
  analyticsData,
}

/// Record of a consent decision
class ConsentEvent {
  final ConsentFeature feature;
  final bool granted;
  final DateTime timestamp;
  final String? notes;
  
  const ConsentEvent({
    required this.feature,
    required this.granted,
    required this.timestamp,
    this.notes,
  });
  
  factory ConsentEvent.fromDb(Map<String, dynamic> row) {
    return ConsentEvent(
      feature: ConsentFeature.values.firstWhere(
        (f) => f.name == row['feature'],
        orElse: () => ConsentFeature.journalAIAccess,
      ),
      granted: (row['granted'] as int) == 1,
      timestamp: DateTime.parse(row['timestamp'] as String),
      notes: row['notes'] as String?,
    );
  }
  
  @override
  String toString() {
    final action = granted ? 'Granted' : 'Denied';
    return '[$timestamp] ${feature.name}: $action';
  }
}
