import 'package:flutter_riverpod/flutter_riverpod.dart';

/// L0: Heuristic Router - Instant verse navigation using Dart Regex
/// 
/// Performance target: <1ms for all operations
/// 
/// Handles verse references like:
/// - "John 3:16" → Direct match
/// - "Jn 3:16", "Joh 3" → Abbreviation matching
/// - "ch 5" → Chapter in current book
/// - "v 12" → Verse in current chapter
/// - "3:16" → Chapter:verse in current book
class HeuristicRouter {
  /// Parse a verse reference string into structured components
  /// 
  /// Returns null if the input doesn't match any known pattern.
  /// Returns a [VerseLocation] with book, chapter, and optional verse.
  VerseLocation? parseReference(String input, {String? currentBook, int? currentChapter}) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;
    
    // Try patterns in order of specificity
    
    // Pattern 1: Full reference "John 3:16" or "1 John 3:16"
    final fullMatch = _fullReferencePattern.firstMatch(trimmed);
    if (fullMatch != null) {
      return _parseFullMatch(fullMatch);
    }
    
    // Pattern 2: Abbreviated reference "Jn 3:16" or "1Jn 3:16"
    final abbrevMatch = _abbreviatedPattern.firstMatch(trimmed);
    if (abbrevMatch != null) {
      return _parseAbbrevMatch(abbrevMatch);
    }
    
    // Pattern 3: Chapter only "John 3" or "Jn 3"
    final chapterOnlyMatch = _chapterOnlyPattern.firstMatch(trimmed);
    if (chapterOnlyMatch != null) {
      return _parseChapterOnlyMatch(chapterOnlyMatch);
    }
    
    // Pattern 4: Chapter:verse in current book "3:16"
    if (currentBook != null) {
      final cvMatch = _chapterVersePattern.firstMatch(trimmed);
      if (cvMatch != null) {
        final chapter = int.tryParse(cvMatch.group(1) ?? '');
        final verse = int.tryParse(cvMatch.group(2) ?? '');
        if (chapter != null) {
          return VerseLocation(book: currentBook, chapter: chapter, verse: verse);
        }
      }
    }
    
    // Pattern 5: "ch 5" or "chapter 5" in current book
    if (currentBook != null) {
      final chMatch = _chapterShortcutPattern.firstMatch(trimmed);
      if (chMatch != null) {
        final chapter = int.tryParse(chMatch.group(1) ?? '');
        if (chapter != null) {
          return VerseLocation(book: currentBook, chapter: chapter);
        }
      }
    }
    
    // Pattern 6: "v 12" or "verse 12" in current chapter
    if (currentBook != null && currentChapter != null) {
      final vMatch = _verseShortcutPattern.firstMatch(trimmed);
      if (vMatch != null) {
        final verse = int.tryParse(vMatch.group(1) ?? '');
        if (verse != null) {
          return VerseLocation(book: currentBook, chapter: currentChapter, verse: verse);
        }
      }
    }
    
    return null;
  }
  
  /// Check if a string looks like a verse reference (fast check)
  bool looksLikeReference(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty || trimmed.length < 2) return false;
    
    // Quick heuristic checks
    if (_containsNumber.hasMatch(trimmed)) {
      // Has a number - could be a reference
      if (_looksLikeBook.hasMatch(trimmed) || 
          _chapterVersePattern.hasMatch(trimmed) ||
          _chapterShortcutPattern.hasMatch(trimmed) ||
          _verseShortcutPattern.hasMatch(trimmed)) {
        return true;
      }
    }
    
    return false;
  }
  
  /// Resolve a book name or abbreviation to the canonical book name
  String? resolveBookName(String input) {
    final normalized = input.toLowerCase().trim();
    
    // Direct match in abbreviations
    final match = _bookAbbreviations[normalized];
    if (match != null) return match;
    
    // Partial match (starts with)
    for (final entry in _bookAbbreviations.entries) {
      if (entry.key.startsWith(normalized) || entry.value.toLowerCase().startsWith(normalized)) {
        return entry.value;
      }
    }
    
    return null;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Private Methods
  // ═══════════════════════════════════════════════════════════════════════════
  
  VerseLocation? _parseFullMatch(RegExpMatch match) {
    final prefix = match.group(1) ?? '';
    final bookName = match.group(2) ?? '';
    final chapter = int.tryParse(match.group(3) ?? '');
    final verse = int.tryParse(match.group(4) ?? '');
    
    if (chapter == null) return null;
    
    final fullBookInput = '$prefix$bookName'.trim();
    final book = resolveBookName(fullBookInput);
    if (book == null) return null;
    
    return VerseLocation(book: book, chapter: chapter, verse: verse);
  }
  
  VerseLocation? _parseAbbrevMatch(RegExpMatch match) {
    final abbrev = match.group(1) ?? '';
    final chapter = int.tryParse(match.group(2) ?? '');
    final verse = int.tryParse(match.group(3) ?? '');
    
    if (chapter == null) return null;
    
    final book = resolveBookName(abbrev);
    if (book == null) return null;
    
    return VerseLocation(book: book, chapter: chapter, verse: verse);
  }
  
  VerseLocation? _parseChapterOnlyMatch(RegExpMatch match) {
    final prefix = match.group(1) ?? '';
    final bookName = match.group(2) ?? '';
    final chapter = int.tryParse(match.group(3) ?? '');
    
    if (chapter == null) return null;
    
    final fullBookInput = '$prefix$bookName'.trim();
    final book = resolveBookName(fullBookInput);
    if (book == null) return null;
    
    return VerseLocation(book: book, chapter: chapter);
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Regex Patterns
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Full reference: "John 3:16", "1 John 3:16", "Song of Solomon 1:1"
  static final _fullReferencePattern = RegExp(
    r'^(\d?\s?)([a-zA-Z]+(?:\s+of\s+[a-zA-Z]+)?)\s+(\d+)(?::(\d+))?$',
    caseSensitive: false,
  );
  
  // Abbreviated: "Jn 3:16", "1Jn 3:16", "Gen 1:1"
  static final _abbreviatedPattern = RegExp(
    r'^(\d?[a-zA-Z]{2,5})\s+(\d+)(?::(\d+))?$',
    caseSensitive: false,
  );
  
  // Chapter only: "John 3", "Genesis 1"
  static final _chapterOnlyPattern = RegExp(
    r'^(\d?\s?)([a-zA-Z]+(?:\s+of\s+[a-zA-Z]+)?)\s+(\d+)$',
    caseSensitive: false,
  );
  
  // Chapter:verse only: "3:16"
  static final _chapterVersePattern = RegExp(
    r'^(\d+):(\d+)$',
  );
  
  // Chapter shortcut: "ch 5", "chapter 5"
  static final _chapterShortcutPattern = RegExp(
    r'^(?:ch(?:apter)?)\s*(\d+)$',
    caseSensitive: false,
  );
  
  // Verse shortcut: "v 12", "verse 12"
  static final _verseShortcutPattern = RegExp(
    r'^(?:v(?:erse)?)\s*(\d+)$',
    caseSensitive: false,
  );
  
  // Quick check patterns
  static final _containsNumber = RegExp(r'\d');
  static final _looksLikeBook = RegExp(r'^(\d?\s?)?[a-zA-Z]{2,}', caseSensitive: false);
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Book Abbreviations Dictionary
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const _bookAbbreviations = <String, String>{
    // Genesis
    'genesis': 'Genesis', 'gen': 'Genesis', 'ge': 'Genesis', 'gn': 'Genesis',
    // Exodus
    'exodus': 'Exodus', 'exod': 'Exodus', 'exo': 'Exodus', 'ex': 'Exodus',
    // Leviticus
    'leviticus': 'Leviticus', 'lev': 'Leviticus', 'le': 'Leviticus', 'lv': 'Leviticus',
    // Numbers
    'numbers': 'Numbers', 'num': 'Numbers', 'nu': 'Numbers', 'nm': 'Numbers',
    // Deuteronomy
    'deuteronomy': 'Deuteronomy', 'deut': 'Deuteronomy', 'de': 'Deuteronomy', 'dt': 'Deuteronomy',
    // Joshua
    'joshua': 'Joshua', 'josh': 'Joshua', 'jos': 'Joshua',
    // Judges
    'judges': 'Judges', 'judg': 'Judges', 'jdg': 'Judges', 'jg': 'Judges',
    // Ruth
    'ruth': 'Ruth', 'ru': 'Ruth', 'rth': 'Ruth',
    // 1 Samuel
    '1 samuel': '1 Samuel', '1samuel': '1 Samuel', '1sam': '1 Samuel', '1sa': '1 Samuel',
    '1 sam': '1 Samuel', 'i samuel': '1 Samuel', 'i sam': '1 Samuel',
    // 2 Samuel
    '2 samuel': '2 Samuel', '2samuel': '2 Samuel', '2sam': '2 Samuel', '2sa': '2 Samuel',
    '2 sam': '2 Samuel', 'ii samuel': '2 Samuel', 'ii sam': '2 Samuel',
    // 1 Kings
    '1 kings': '1 Kings', '1kings': '1 Kings', '1kgs': '1 Kings', '1ki': '1 Kings',
    '1 kgs': '1 Kings', 'i kings': '1 Kings', 'i kgs': '1 Kings',
    // 2 Kings
    '2 kings': '2 Kings', '2kings': '2 Kings', '2kgs': '2 Kings', '2ki': '2 Kings',
    '2 kgs': '2 Kings', 'ii kings': '2 Kings', 'ii kgs': '2 Kings',
    // 1 Chronicles
    '1 chronicles': '1 Chronicles', '1chronicles': '1 Chronicles', '1chr': '1 Chronicles',
    '1 chr': '1 Chronicles', 'i chronicles': '1 Chronicles', 'i chr': '1 Chronicles',
    // 2 Chronicles
    '2 chronicles': '2 Chronicles', '2chronicles': '2 Chronicles', '2chr': '2 Chronicles',
    '2 chr': '2 Chronicles', 'ii chronicles': '2 Chronicles', 'ii chr': '2 Chronicles',
    // Ezra
    'ezra': 'Ezra', 'ezr': 'Ezra',
    // Nehemiah
    'nehemiah': 'Nehemiah', 'neh': 'Nehemiah', 'ne': 'Nehemiah',
    // Esther
    'esther': 'Esther', 'esth': 'Esther', 'est': 'Esther', 'es': 'Esther',
    // Job
    'job': 'Job', 'jb': 'Job',
    // Psalms
    'psalms': 'Psalms', 'psalm': 'Psalms', 'ps': 'Psalms', 'psa': 'Psalms', 'pss': 'Psalms',
    // Proverbs
    'proverbs': 'Proverbs', 'prov': 'Proverbs', 'pro': 'Proverbs', 'pr': 'Proverbs',
    // Ecclesiastes
    'ecclesiastes': 'Ecclesiastes', 'eccles': 'Ecclesiastes', 'eccl': 'Ecclesiastes', 
    'ecc': 'Ecclesiastes', 'ec': 'Ecclesiastes',
    // Song of Solomon
    'song of solomon': 'Song of Solomon', 'song': 'Song of Solomon', 'sos': 'Song of Solomon',
    'ss': 'Song of Solomon', 'song of songs': 'Song of Solomon',
    // Isaiah
    'isaiah': 'Isaiah', 'isa': 'Isaiah', 'is': 'Isaiah',
    // Jeremiah
    'jeremiah': 'Jeremiah', 'jer': 'Jeremiah', 'je': 'Jeremiah',
    // Lamentations
    'lamentations': 'Lamentations', 'lam': 'Lamentations', 'la': 'Lamentations',
    // Ezekiel
    'ezekiel': 'Ezekiel', 'ezek': 'Ezekiel', 'eze': 'Ezekiel', 'ez': 'Ezekiel',
    // Daniel
    'daniel': 'Daniel', 'dan': 'Daniel', 'da': 'Daniel', 'dn': 'Daniel',
    // Hosea
    'hosea': 'Hosea', 'hos': 'Hosea', 'ho': 'Hosea',
    // Joel
    'joel': 'Joel', 'jl': 'Joel',
    // Amos
    'amos': 'Amos', 'am': 'Amos',
    // Obadiah
    'obadiah': 'Obadiah', 'obad': 'Obadiah', 'ob': 'Obadiah',
    // Jonah
    'jonah': 'Jonah', 'jon': 'Jonah', 'jnh': 'Jonah',
    // Micah
    'micah': 'Micah', 'mic': 'Micah', 'mi': 'Micah',
    // Nahum
    'nahum': 'Nahum', 'nah': 'Nahum', 'na': 'Nahum',
    // Habakkuk
    'habakkuk': 'Habakkuk', 'hab': 'Habakkuk', 'hb': 'Habakkuk',
    // Zephaniah
    'zephaniah': 'Zephaniah', 'zeph': 'Zephaniah', 'zep': 'Zephaniah', 'zp': 'Zephaniah',
    // Haggai
    'haggai': 'Haggai', 'hag': 'Haggai', 'hg': 'Haggai',
    // Zechariah
    'zechariah': 'Zechariah', 'zech': 'Zechariah', 'zec': 'Zechariah', 'zc': 'Zechariah',
    // Malachi
    'malachi': 'Malachi', 'mal': 'Malachi', 'ml': 'Malachi',
    // Matthew
    'matthew': 'Matthew', 'matt': 'Matthew', 'mat': 'Matthew', 'mt': 'Matthew',
    // Mark
    'mark': 'Mark', 'mk': 'Mark', 'mr': 'Mark',
    // Luke
    'luke': 'Luke', 'lk': 'Luke', 'lu': 'Luke',
    // John
    'john': 'John', 'jn': 'John', 'jhn': 'John',
    // Acts
    'acts': 'Acts', 'act': 'Acts', 'ac': 'Acts',
    // Romans
    'romans': 'Romans', 'rom': 'Romans', 'ro': 'Romans', 'rm': 'Romans',
    // 1 Corinthians
    '1 corinthians': '1 Corinthians', '1corinthians': '1 Corinthians', '1cor': '1 Corinthians',
    '1 cor': '1 Corinthians', 'i corinthians': '1 Corinthians', 'i cor': '1 Corinthians',
    // 2 Corinthians
    '2 corinthians': '2 Corinthians', '2corinthians': '2 Corinthians', '2cor': '2 Corinthians',
    '2 cor': '2 Corinthians', 'ii corinthians': '2 Corinthians', 'ii cor': '2 Corinthians',
    // Galatians
    'galatians': 'Galatians', 'gal': 'Galatians', 'ga': 'Galatians',
    // Ephesians
    'ephesians': 'Ephesians', 'eph': 'Ephesians', 'ep': 'Ephesians',
    // Philippians
    'philippians': 'Philippians', 'phil': 'Philippians', 'php': 'Philippians', 'pp': 'Philippians',
    // Colossians
    'colossians': 'Colossians', 'col': 'Colossians', 'co': 'Colossians',
    // 1 Thessalonians
    '1 thessalonians': '1 Thessalonians', '1thessalonians': '1 Thessalonians', 
    '1thess': '1 Thessalonians', '1 thess': '1 Thessalonians', '1th': '1 Thessalonians',
    'i thessalonians': '1 Thessalonians', 'i thess': '1 Thessalonians',
    // 2 Thessalonians
    '2 thessalonians': '2 Thessalonians', '2thessalonians': '2 Thessalonians',
    '2thess': '2 Thessalonians', '2 thess': '2 Thessalonians', '2th': '2 Thessalonians',
    'ii thessalonians': '2 Thessalonians', 'ii thess': '2 Thessalonians',
    // 1 Timothy
    '1 timothy': '1 Timothy', '1timothy': '1 Timothy', '1tim': '1 Timothy',
    '1 tim': '1 Timothy', 'i timothy': '1 Timothy', 'i tim': '1 Timothy',
    // 2 Timothy
    '2 timothy': '2 Timothy', '2timothy': '2 Timothy', '2tim': '2 Timothy',
    '2 tim': '2 Timothy', 'ii timothy': '2 Timothy', 'ii tim': '2 Timothy',
    // Titus
    'titus': 'Titus', 'tit': 'Titus', 'ti': 'Titus',
    // Philemon
    'philemon': 'Philemon', 'phlm': 'Philemon', 'phm': 'Philemon', 'pm': 'Philemon',
    // Hebrews
    'hebrews': 'Hebrews', 'heb': 'Hebrews', 'he': 'Hebrews',
    // James
    'james': 'James', 'jas': 'James', 'jm': 'James',
    // 1 Peter
    '1 peter': '1 Peter', '1peter': '1 Peter', '1pet': '1 Peter', '1pe': '1 Peter',
    '1 pet': '1 Peter', 'i peter': '1 Peter', 'i pet': '1 Peter',
    // 2 Peter
    '2 peter': '2 Peter', '2peter': '2 Peter', '2pet': '2 Peter', '2pe': '2 Peter',
    '2 pet': '2 Peter', 'ii peter': '2 Peter', 'ii pet': '2 Peter',
    // 1 John
    '1 john': '1 John', '1john': '1 John', '1jn': '1 John', '1jo': '1 John',
    '1 jn': '1 John', 'i john': '1 John', 'i jn': '1 John',
    // 2 John
    '2 john': '2 John', '2john': '2 John', '2jn': '2 John', '2jo': '2 John',
    '2 jn': '2 John', 'ii john': '2 John', 'ii jn': '2 John',
    // 3 John
    '3 john': '3 John', '3john': '3 John', '3jn': '3 John', '3jo': '3 John',
    '3 jn': '3 John', 'iii john': '3 John', 'iii jn': '3 John',
    // Jude
    'jude': 'Jude', 'jud': 'Jude', 'jd': 'Jude',
    // Revelation
    'revelation': 'Revelation', 'rev': 'Revelation', 're': 'Revelation', 'rv': 'Revelation',
    'revelations': 'Revelation', 'apocalypse': 'Revelation',
  };
}

/// Represents a parsed verse location
class VerseLocation {
  final String book;
  final int chapter;
  final int? verse;
  
  const VerseLocation({
    required this.book,
    required this.chapter,
    this.verse,
  });
  
  /// Get formatted reference string
  String get reference => verse != null ? '$book $chapter:$verse' : '$book $chapter';
  
  @override
  String toString() => 'VerseLocation($reference)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VerseLocation &&
        other.book == book &&
        other.chapter == chapter &&
        other.verse == verse;
  }
  
  @override
  int get hashCode => Object.hash(book, chapter, verse);
}

/// Riverpod provider for the HeuristicRouter
final heuristicRouterProvider = Provider<HeuristicRouter>((ref) {
  return HeuristicRouter();
});
