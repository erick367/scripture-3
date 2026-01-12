class VerseInsight {
  final String naturalMeaning;
  final String originalContext;
  final String soWhat;
  final String scenario;
  final List<String> threads;

  VerseInsight({
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
}

class ChapterPreview {
  final String book;
  final int chapter;
  final String coreTheme;
  final String provocativeQuestion;
  final List<String> keyVerses;

  ChapterPreview({
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
