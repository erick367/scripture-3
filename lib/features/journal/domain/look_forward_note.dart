import 'dart:convert';

/// Model for a Look Forward note attached to a journal entry
/// Represents an action item or intention based on a mentorship reflection question
class LookForwardNote {
  final DateTime createdAt;
  final String question; // The mentorship question that prompted this
  final String note; // User's action plan/intention
  final String theme; // The journey theme (e.g., "God", "Peace")
  
  LookForwardNote({
    required this.createdAt,
    required this.question,
    required this.note,
    required this.theme,
  });
  
  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'question': question,
      'note': note,
      'theme': theme,
    };
  }
  
  /// Create from JSON
  factory LookForwardNote.fromJson(Map<String, dynamic> json) {
    return LookForwardNote(
      createdAt: DateTime.parse(json['createdAt'] as String),
      question: json['question'] as String,
      note: json['note'] as String,
      theme: json['theme'] as String,
    );
  }
  
  /// Parse array from JSON string
  static List<LookForwardNote> parseList(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return [];
    
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => LookForwardNote.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error parsing Look Forward notes: $e');
      return [];
    }
  }
  
  /// Convert list to JSON string
  static String encodeList(List<LookForwardNote> notes) {
    return jsonEncode(notes.map((note) => note.toJson()).toList());
  }
}
