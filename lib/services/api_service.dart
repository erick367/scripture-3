import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_service.g.dart';

@riverpod
class ApiService extends _$ApiService {
  @override
  FutureOr<void> build() async {
    // Initialization logic if needed
  }

  Future<void> initializeSupabase() async {
    try {
      final String configString = await rootBundle.loadString('config.json');
      final Map<String, dynamic> config = json.decode(configString);

      final String supabaseUrl = config['SUPABASE_URL'];
      final String supabaseAnonKey = config['SUPABASE_ANON_KEY'];

      if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
        await Supabase.initialize(
          url: supabaseUrl,
          anonKey: supabaseAnonKey,
        );
        print('Supabase initialized successfully.');
      } else {
        throw Exception('Missing Supabase configuration in config.json');
      }
    } catch (e) {
      print('Error initializing Supabase: $e');
      rethrow;
    }
  }

  /// Retrieves journal entries similar to the given verse embedding
  /// Respects ai_access_enabled at the database level
  Future<List<Map<String, dynamic>>> getJournalContext(List<double> verseEmbedding) async {
    try {
      final supabase = Supabase.instance.client;
      
      final response = await supabase.rpc('match_journal_entries', params: {
        'query_embedding': verseEmbedding,
        'match_threshold': 0.7,
        'match_count': 5,
      });
      
      if (response == null) return [];
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print('Error fetching journal context: $e');
      return [];
    }
  }
}
