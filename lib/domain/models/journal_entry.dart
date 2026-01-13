/// Domain model for journal entries
/// 
/// Pure Dart model with no external dependencies.

class JournalEntry {
  final int id;
  final String content;
  final String emotionTag;
  final String? verseReference;
  final bool aiAccessEnabled;
  final String? lookForwardNotes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  const JournalEntry({
    required this.id,
    required this.content,
    required this.emotionTag,
    this.verseReference,
    this.aiAccessEnabled = false,
    this.lookForwardNotes,
    required this.createdAt,
    this.updatedAt,
  });
  
  /// Create from database row
  factory JournalEntry.fromDb(Map<String, dynamic> row) {
    return JournalEntry(
      id: row['id'] as int,
      content: row['content'] as String,
      emotionTag: row['emotion_tag'] as String,
      verseReference: row['verse_reference'] as String?,
      aiAccessEnabled: (row['ai_access_enabled'] as int?) == 1,
      lookForwardNotes: row['look_forward_notes'] as String?,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: row['updated_at'] != null 
          ? DateTime.parse(row['updated_at'] as String)
          : null,
    );
  }
  
  /// Convert to map for database insertion
  Map<String, dynamic> toDb() {
    return {
      if (id != 0) 'id': id,
      'content': content,
      'emotion_tag': emotionTag,
      'verse_reference': verseReference,
      'ai_access_enabled': aiAccessEnabled ? 1 : 0,
      'look_forward_notes': lookForwardNotes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
  
  /// Create copy with modified fields
  JournalEntry copyWith({
    int? id,
    String? content,
    String? emotionTag,
    String? verseReference,
    bool? aiAccessEnabled,
    String? lookForwardNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      content: content ?? this.content,
      emotionTag: emotionTag ?? this.emotionTag,
      verseReference: verseReference ?? this.verseReference,
      aiAccessEnabled: aiAccessEnabled ?? this.aiAccessEnabled,
      lookForwardNotes: lookForwardNotes ?? this.lookForwardNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  /// Get pulse value from emotion tag (1-5 scale)
  double get pulseValue {
    switch (emotionTag.toLowerCase()) {
      case 'joyful':
      case 'grateful':
      case 'peaceful':
        return 5.0;
      case 'hopeful':
      case 'reflective':
        return 4.0;
      case 'uncertain':
      case 'contemplative':
        return 3.0;
      case 'anxious':
      case 'struggling':
        return 2.0;
      case 'despairing':
      case 'grieving':
        return 1.0;
      default:
        return 3.0;
    }
  }
}
