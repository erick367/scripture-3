/*
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../core/database/app_database.dart';
import '../features/journal/presentation/journal_providers.dart';

final biblePreloaderServiceProvider = Provider<BiblePreloaderService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return BiblePreloaderService(db);
});

/// Preloads bundled Bible translations into local database on first launch
/// Uses background Isolate for bulk insertion to maintain 60fps
class BiblePreloaderService {
  final AppDatabase _db;
  
  // Bundled translations (public domain / free license)
  static const List<String> bundledVersions = ['web', 'kjv', 'rv1909'];
  
  BiblePreloaderService(this._db);

  /// Check if a specific version needs preloading
  Future<bool> _needsPreloadVersion(String version) async {
    final count = await (_db.select(_db.verses)
      ..where((v) => v.version.equals(version.toUpperCase()))
      ..limit(1))
      .get();
    return count.isEmpty;
  }

  /// Preload all bundled Bible translations
  /// Should be called on first app launch
  Future<void> preloadBundledBibles() async {
    print('📖 Checking bundled Bibles...');
    
    for (final version in bundledVersions) {
      if (await _needsPreloadVersion(version)) {
        print('⏳ Preloading $version...');
        try {
          await _preloadVersion(version);
        } catch (e) {
          print('❌ Error preloading $version: $e');
        }
      } else {
        print('✅ $version already loaded');
      }
    }
    
    print('✅ Bible preload check complete');
  }

  Future<void> _preloadVersion(String version) async {
    final assetPath = 'assets/bibles/$version.json';
    
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      
      // Parse on background isolate
      final verses = await compute(_parseBibleJson, {
        'json': jsonString,
        'version': version.toUpperCase(),
      });
      
      // Bulk insert in batches
      await _bulkInsert(verses);
      
      print('✅ Loaded ${verses.length} verses for $version');
    } catch (e) {
      print('❌ Failed to load $assetPath: $e');
    }
  }

  Future<void> _bulkInsert(List<VersesCompanion> verses) async {
    // Insert in batches of 500 to avoid memory issues
    const batchSize = 500;
    
    for (var i = 0; i < verses.length; i += batchSize) {
      final batch = verses.skip(i).take(batchSize).toList();
      await _db.batch((b) {
        b.insertAll(_db.verses, batch, mode: InsertMode.insertOrIgnore);
      });
    }
  }
}

/// Top-level function for isolate parsing
List<VersesCompanion> _parseBibleJson(Map<String, dynamic> args) {
  final jsonString = args['json'] as String;
  final version = args['version'] as String;
  
  final dynamic decoded = json.decode(jsonString);
  final verses = <VersesCompanion>[];

  // 1. Handle Schema A: { "books": [ ... ] } (Our custom WEB format & getbible API style)
  if (decoded is Map<String, dynamic> && decoded.containsKey('books')) {
    final books = decoded['books'] as List<dynamic>;
    for (final book in books) {
      final bookName = book['name'] as String;
      final chapters = book['chapters'] as List<dynamic>;
      
      for (final chapter in chapters) {
        final chapterNum = chapter['number'] as int;
        final verseList = chapter['verses'] as List<dynamic>;
        
        for (final verse in verseList) {
          verses.add(VersesCompanion(
            version: Value(version),
            book: Value(bookName),
            chapter: Value(chapterNum),
            verse: Value(verse['number'] as int),
            content: Value(verse['text'] as String),
            isBundled: const Value(true),
          ));
        }
      }
    }
  } 
  // 2. Handle Schema B: [ { "name": "Genesis", "chapters": [ ["verse1", ...], ... ] } ] (thiagobodruk legacy format)
  // This format iterates chapters as arrays of strings
  else if (decoded is List) {
    for (final book in decoded) {
      final bookName = book['name'] as String;
      final chapters = book['chapters'] as List<dynamic>;
      
      for (var c = 0; c < chapters.length; c++) {
        final chapterNum = c + 1;
        final chapterData = chapters[c];
        
        // Ensure chapterData is List (array of verses)
        if (chapterData is List) {
          for (var v = 0; v < chapterData.length; v++) {
            final verseNum = v + 1;
            final verseText = chapterData[v].toString();
            
            verses.add(VersesCompanion(
              version: Value(version),
              book: Value(bookName),
              chapter: Value(chapterNum),
              verse: Value(verseNum),
              // Clean leading numbers if present (e.g. "1 In the beginning")
              content: Value(verseText), 
              isBundled: const Value(true),
            ));
          }
        }
      }
    }
  } else {
    print('❌ Unknown JSON format for version $version');
  }
  
  return verses;
}
*/
