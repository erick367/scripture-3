/// Domain models for verse insights
/// 
/// These models are pure Dart and have no external dependencies.

class VerseInsight {
  final String naturalMeaning;
  final String originalContext;
  final String soWhat;
  final String scenario;
  final List<String> threads;

  const VerseInsight({
    required this.naturalMeaning,
    required this.originalContext,
    required this.soWhat,
    required this.scenario,
    required this.threads,
  });

  factory VerseInsight.fromJson(Map<String, dynamic> json) {
    return VerseInsight(
      naturalMeaning: json['naturalMeaning'] as String? ?? '',
      originalContext: json['originalContext'] as String? ?? '',
      soWhat: json['soWhat'] as String? ?? '',
      scenario: json['scenario'] as String? ?? '',
      threads: (json['threads'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'naturalMeaning': naturalMeaning,
      'originalContext': originalContext,
      'soWhat': soWhat,
      'scenario': scenario,
      'threads': threads,
    };
  }
  
  /// Create an empty VerseInsight for loading states
  static VerseInsight empty() => const VerseInsight(
    naturalMeaning: '',
    originalContext: '',
    soWhat: '',
    scenario: '',
    threads: [],
  );
  
  /// Create a partial insight (e.g., from Qwen preview)
  VerseInsight copyWith({
    String? naturalMeaning,
    String? originalContext,
    String? soWhat,
    String? scenario,
    List<String>? threads,
  }) {
    return VerseInsight(
      naturalMeaning: naturalMeaning ?? this.naturalMeaning,
      originalContext: originalContext ?? this.originalContext,
      soWhat: soWhat ?? this.soWhat,
      scenario: scenario ?? this.scenario,
      threads: threads ?? this.threads,
    );
  }
  
  bool get isEmpty => naturalMeaning.isEmpty && originalContext.isEmpty;
}

class ChapterPreview {
  final String book;
  final int chapter;
  final String coreTheme;
  final String provocativeQuestion;
  final List<String> keyVerses;

  const ChapterPreview({
    required this.book,
    required this.chapter,
    required this.coreTheme,
    required this.provocativeQuestion,
    this.keyVerses = const [],
  });

  factory ChapterPreview.fromJson(Map<String, dynamic> json) {
    return ChapterPreview(
      book: json['book'] as String,
      chapter: json['chapter'] as int,
      coreTheme: json['coreTheme'] as String,
      provocativeQuestion: json['provocativeQuestion'] as String,
      keyVerses: (json['keyVerses'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'book': book,
      'chapter': chapter,
      'coreTheme': coreTheme,
      'provocativeQuestion': provocativeQuestion,
      'keyVerses': keyVerses,
    };
  }
}
