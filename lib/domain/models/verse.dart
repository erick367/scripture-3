/// Domain model for a Bible verse
/// 
/// Pure Dart model for verse data.

class Verse {
  final int id;
  final String book;
  final int chapter;
  final int verse;
  final String content;
  final String version;
  
  const Verse({
    required this.id,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.content,
    this.version = 'WEB',
  });
  
  /// Create from database row
  factory Verse.fromDb(Map<String, dynamic> row) {
    return Verse(
      id: row['id'] as int,
      book: row['book'] as String,
      chapter: row['chapter'] as int,
      verse: row['verse'] as int,
      content: row['content'] as String,
      version: row['version'] as String? ?? 'WEB',
    );
  }
  
  /// Get formatted reference (e.g., "John 3:16")
  String get reference => '$book $chapter:$verse';
  
  /// Get short reference (e.g., "Jn 3:16")
  String get shortReference {
    final abbrev = _bookAbbreviations[book] ?? book.substring(0, 3);
    return '$abbrev $chapter:$verse';
  }
  
  @override
  String toString() => '$reference - $content';
  
  static const Map<String, String> _bookAbbreviations = {
    'Genesis': 'Gen',
    'Exodus': 'Exod',
    'Leviticus': 'Lev',
    'Numbers': 'Num',
    'Deuteronomy': 'Deut',
    'Joshua': 'Josh',
    'Judges': 'Judg',
    'Ruth': 'Ruth',
    '1 Samuel': '1 Sam',
    '2 Samuel': '2 Sam',
    '1 Kings': '1 Kgs',
    '2 Kings': '2 Kgs',
    '1 Chronicles': '1 Chr',
    '2 Chronicles': '2 Chr',
    'Ezra': 'Ezra',
    'Nehemiah': 'Neh',
    'Esther': 'Esth',
    'Job': 'Job',
    'Psalms': 'Ps',
    'Proverbs': 'Prov',
    'Ecclesiastes': 'Eccl',
    'Song of Solomon': 'Song',
    'Isaiah': 'Isa',
    'Jeremiah': 'Jer',
    'Lamentations': 'Lam',
    'Ezekiel': 'Ezek',
    'Daniel': 'Dan',
    'Hosea': 'Hos',
    'Joel': 'Joel',
    'Amos': 'Amos',
    'Obadiah': 'Obad',
    'Jonah': 'Jonah',
    'Micah': 'Mic',
    'Nahum': 'Nah',
    'Habakkuk': 'Hab',
    'Zephaniah': 'Zeph',
    'Haggai': 'Hag',
    'Zechariah': 'Zech',
    'Malachi': 'Mal',
    'Matthew': 'Matt',
    'Mark': 'Mark',
    'Luke': 'Luke',
    'John': 'John',
    'Acts': 'Acts',
    'Romans': 'Rom',
    '1 Corinthians': '1 Cor',
    '2 Corinthians': '2 Cor',
    'Galatians': 'Gal',
    'Ephesians': 'Eph',
    'Philippians': 'Phil',
    'Colossians': 'Col',
    '1 Thessalonians': '1 Thess',
    '2 Thessalonians': '2 Thess',
    '1 Timothy': '1 Tim',
    '2 Timothy': '2 Tim',
    'Titus': 'Titus',
    'Philemon': 'Phlm',
    'Hebrews': 'Heb',
    'James': 'Jas',
    '1 Peter': '1 Pet',
    '2 Peter': '2 Pet',
    '1 John': '1 John',
    '2 John': '2 John',
    '3 John': '3 John',
    'Jude': 'Jude',
    'Revelation': 'Rev',
  };
}
