import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/verse_insight.dart';

/// Simple in-memory cache for verse insights
class InsightCache {
  final Map<String, VerseInsight> _cache = {};
  
  VerseInsight? get(String verseReference) {
    return _cache[verseReference];
  }
  
  void set(String verseReference, VerseInsight insight) {
    _cache[verseReference] = insight;
  }
  
  void clear() {
    _cache.clear();
  }
}

final insightCacheProvider = Provider<InsightCache>((ref) => InsightCache());
