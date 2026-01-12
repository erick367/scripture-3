import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final devotionalServiceProvider = Provider((ref) => DevotionalService());

final dailyDevotionalProvider = FutureProvider<DevotionalData?>((ref) async {
  final service = ref.watch(devotionalServiceProvider);
  return service.getDailyDevotional();
});

class DevotionalData {
  final String text;
  final String reference;
  final String version;

  DevotionalData({
    required this.text,
    required this.reference,
    required this.version,
  });
}

class DevotionalService {
  static const String apiUrl = 'https://devotionalium.com/api/v2';

  Future<DevotionalData?> getDailyDevotional() async {
    try {
      // Fetching KJV daily verse
      final response = await http.get(
        Uri.parse('$apiUrl?lang=en-us&bibleVersion=kjv'),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'ScriptureLens/1.0',
        },
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        
        dynamic first;
        if (decoded is List && decoded.isNotEmpty) {
          first = decoded.first;
        } else if (decoded is Map) {
          // Devotionalium v2 uses numeric strings "0", "1", etc. for multiple readings
          if (decoded.containsKey('0')) {
            first = decoded['0'];
          } else if (decoded.containsKey('verses') && decoded['verses'] is List) {
            first = decoded['verses'].first;
          } else if (decoded.containsKey('text')) {
             first = decoded;
          }
        }

        if (first != null) {
          return DevotionalData(
            text: first['text'] ?? '',
            reference: first['reference'] ?? '',
            version: 'KJV',
          );
        }
      }
      return null;
    } catch (e) {
      print('Error fetching Devotionalium: $e');
      return null;
    }
  }
}
