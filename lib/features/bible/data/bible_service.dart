import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/bible_verse.dart';

part 'bible_service.g.dart';

@riverpod
class BibleService extends _$BibleService {
  // WEBBE (World English Bible British Edition): 7142879509583d59-01
  // GNBUK is not available on the free tier key provided.
  static const String _defaultBibleId = '7142879509583d59-01'; 
  String? _apiKey;

  @override
  FutureOr<void> build() async {
    try {
      final String configString = await rootBundle.loadString('config.json');
      final Map<String, dynamic> config = json.decode(configString);
      _apiKey = config['BIBLE_API_KEY'];
    } catch (e) {
      print('Error loading config for BibleService: $e');
    }
  }

  Future<BiblePassage> getPassage(String book, int chapter) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      print('Warning: BIBLE_API_KEY is missing. Returning empty passage.');
       return BiblePassage(book: book, chapter: chapter, verses: []);
    }

    final passageId = _getPassageId(book, chapter);
    // Request JSON content
    final url = Uri.parse('https://rest.api.bible/v1/bibles/$_defaultBibleId/passages/$passageId?content-type=json&include-notes=false&include-titles=true&include-chapter-numbers=false&include-verse-numbers=true');

    try {
      final response = await http.get(
        url,
        headers: {
          'api-key': _apiKey!,
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseApiResponse(book, chapter, data['data']);
      } else {
        print('Error fetching passage: ${response.statusCode} - ${response.body}');
        return BiblePassage(book: book, chapter: chapter, verses: []);
      }
    } catch (e) {
       print('Exception fetching passage: $e');
       return BiblePassage(book: book, chapter: chapter, verses: []);
    }
  }

  String _getPassageId(String book, int chapter) {
    final Map<String, String> bookIds = {
      // Old Testament
      'Genesis': 'GEN', 'Exodus': 'EXO', 'Leviticus': 'LEV', 'Numbers': 'NUM', 'Deuteronomy': 'DEU',
      'Joshua': 'JOS', 'Judges': 'JDG', 'Ruth': 'RUT', '1 Samuel': '1SA', '2 Samuel': '2SA',
      '1 Kings': '1KI', '2 Kings': '2KI', '1 Chronicles': '1CH', '2 Chronicles': '2CH',
      'Ezra': 'EZR', 'Nehemiah': 'NEH', 'Esther': 'EST', 'Job': 'JOB', 'Psalms': 'PSA',
      'Proverbs': 'PRO', 'Ecclesiastes': 'ECC', 'Song of Solomon': 'SNG',
      'Isaiah': 'ISA', 'Jeremiah': 'JER', 'Lamentations': 'LAM', 'Ezekiel': 'EZK', 'Daniel': 'DAN',
      'Hosea': 'HOS', 'Joel': 'JOL', 'Amos': 'AMO', 'Obadiah': 'OBA', 'Jonah': 'JON',
      'Micah': 'MIC', 'Nahum': 'NAM', 'Habakkuk': 'HAB', 'Zephaniah': 'ZEP', 'Haggai': 'HAG',
      'Zechariah': 'ZEC', 'Malachi': 'MAL',
      // New Testament
      'Matthew': 'MAT', 'Mark': 'MRK', 'Luke': 'LUK', 'John': 'JHN', 'Acts': 'ACT',
      'Romans': 'ROM', '1 Corinthians': '1CO', '2 Corinthians': '2CO', 'Galatians': 'GAL',
      'Ephesians': 'EPH', 'Philippians': 'PHP', 'Colossians': 'COL',
      '1 Thessalonians': '1TH', '2 Thessalonians': '2TH', '1 Timothy': '1TI', '2 Timothy': '2TI',
      'Titus': 'TIT', 'Philemon': 'PHM', 'Hebrews': 'HEB', 'James': 'JAS',
      '1 Peter': '1PE', '2 Peter': '2PE', '1 John': '1JN', '2 John': '2JN', '3 John': '3JN',
      'Jude': 'JUD', 'Revelation': 'REV',
    };
    final bookId = bookIds[book] ?? 'JHN';
    return '$bookId.$chapter';
  }

  BiblePassage _parseApiResponse(String book, int chapter, Map<String, dynamic> data) {
    // Map to aggregate text segments by verse number
    final Map<int, StringBuffer> verseTextMap = {};

    // Recursive parsing function that looks for text nodes with verseId
    void traverse(List<dynamic> nodes) {
      for (var node in nodes) {
        if (node is! Map) continue;
        
        final type = node['type'];
        
        if (type == 'text') {
           // check for verseId in attrs
           final attrs = node['attrs'];
           if (attrs != null && attrs['verseId'] != null) {
              final String verseId = attrs['verseId'];
              // Format usually BOOK.CHAPTER.VERSE (e.g. GEN.1.1)
              final parts = verseId.split('.');
              if (parts.isNotEmpty) {
                 final verseNum = int.tryParse(parts.last);
                 if (verseNum != null) {
                    final text = node['text'] ?? '';
                    verseTextMap.putIfAbsent(verseNum, () => StringBuffer());
                    verseTextMap[verseNum]!.write(text);
                 }
              }
           }
        }
        
        // Recurse items/content
        if (node.containsKey('items')) {
           traverse(node['items']);
        } else if (node.containsKey('content')) {
           traverse(node['content']);
        }
      }
    }

    // Start traversal
    if (data['content'] != null) {
      traverse(data['content']);
    }

    List<BibleVerse> verses = [];
    final sortedVerseNums = verseTextMap.keys.toList()..sort();

    for (var vNum in sortedVerseNums) {
       final rawText = verseTextMap[vNum]!.toString().trim();
       if (rawText.isNotEmpty) {
         final verse = BibleVerse(
           book: book,
           chapter: chapter,
           verse: vNum,
           text: rawText,
         );
         verses.add(_augmentWithInsights(verse));
       }
    }

    if (verses.isEmpty) {
        return BiblePassage(book: book, chapter: chapter, verses: [
            BibleVerse(book: book, chapter: chapter, verse: 1, text: "No content found or parsing failed.")
        ]);
    }

    return BiblePassage(
      book: book, 
      chapter: chapter, 
      verses: verses
    );
  }

  // Helper to inject demo insights for John 1 (since we don't have a real insight API yet)
  BibleVerse _augmentWithInsights(BibleVerse verse) {
    List<InsightKeyword> keywords = [];
    final text = verse.text.toLowerCase();

    if (verse.book == 'Genesis' && verse.chapter == 1) {
       if (verse.verse == 1) {
         if (text.contains('god')) {
           keywords.add(InsightKeyword(
            word: 'God',
            originalWord: 'Elohim (אֱלֹהִים)',
            definition: 'God; the Divine magistrate.',
            pronunciation: 'el-o-heem',
          ));
         }
         if (text.contains('created')) {
           keywords.add(InsightKeyword(
            word: 'created',
            originalWord: 'Bara (בָּרָא)',
            definition: 'To create, shape, form (ex nihilo).',
            pronunciation: 'baw-raw',
          ));
         }
       }
    }

    if (verse.book == 'John' && verse.chapter == 1) {

      if (verse.verse == 1) {
        if (text.contains('word')) {
          keywords.add(InsightKeyword(
            word: 'Word',
            originalWord: 'Logos (Λόγος)',
            definition: 'The divine reason and creative order.',
            pronunciation: 'log-os',
          ));
        }
        if (text.contains('god')) {
          keywords.add(InsightKeyword(
            word: 'God',
            originalWord: 'Theos (Θεός)',
            definition: 'The supreme Divinity.',
            pronunciation: 'theh-os',
          ));
        }
      }
      if (verse.verse == 4) {
         if (text.contains('life')) {
          keywords.add(InsightKeyword(
            word: 'life',
            originalWord: 'Zoe (Ζωή)',
            definition: 'Life, both physical (present) and spiritual (future).',
            pronunciation: 'dzo-ay',
          ));
        }
        if (text.contains('light')) {
          keywords.add(InsightKeyword(
            word: 'light',
            originalWord: 'Phos (Φῶς)',
            definition: 'Light, anything emitting light.',
            pronunciation: 'foce',
          ));
        }
      }
      
      if (keywords.isNotEmpty) {
        return BibleVerse(
          book: verse.book,
          chapter: verse.chapter,
          verse: verse.verse,
          text: verse.text,
          keywords: keywords,
        );
      }
    }
    return verse;
  }
}
