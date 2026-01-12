class BibleVerse {
  final String book;
  final int chapter;
  final int verse;
  final String text;
  final List<InsightKeyword> keywords;

  BibleVerse({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
    this.keywords = const [],
  });
}

class InsightKeyword {
  final String word;
  final String originalWord; // Greek or Hebrew
  final String definition;
  final String pronunciation;

  InsightKeyword({
    required this.word,
    required this.originalWord,
    required this.definition,
    required this.pronunciation,
  });
}

class BiblePassage {
  final String book;
  final int chapter;
  final List<BibleVerse> verses;

  BiblePassage({
    required this.book,
    required this.chapter,
    required this.verses,
  });
}
