import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'qwen_service.dart';

final intentClassifierServiceProvider = Provider<IntentClassifierService>((ref) {
  return IntentClassifierService(
    ref.watch(qwenServiceProvider),
  );
});

/// Intent classification buckets
enum UserIntent {
  navigation,      // (A) "Go to John 1", "Open Psalms"
  simpleSearch,    // (B) "What does Logos mean?", "Define grace"
  theological,     // (C) "Why did this happen to me?", "How does this apply?"
}

/// Service for on-device intent classification using Qwen 2.5 0.5B Instruct
/// Now uses shared QwenService for model management
class IntentClassifierService {
  final QwenService _qwenService;

  IntentClassifierService(this._qwenService);

  /// Classify user query into one of three buckets
  /// Returns in ~150ms using on-device Qwen AI
  Future<UserIntent> classifyIntent(String userQuery) async {
    // Check if Qwen can run (battery guard)
    if (!await _qwenService.canInitialize()) {
      print('⚡ Intent classifier: Battery too low, defaulting to theological');
      return UserIntent.theological; // Safe default triggers full Claude response
    }

    final prompt = _buildClassificationPrompt(userQuery);

    try {
      final response = await _qwenService.generate(
        prompt,
        maxTokens: 10, // Very short response (just A, B, or C)
        temperature: 0.3, // Low creativity for consistent classification
      );
      
      // Parse response (should be A, B, or C)
      final classification = response.trim().toUpperCase();
      
      if (classification.contains('A')) {
        print('⚡ Intent classified: Navigation');
        return UserIntent.navigation;
      } else if (classification.contains('B')) {
        print('⚡ Intent classified: Simple Search');
        return UserIntent.simpleSearch;
      } else {
        print('⚡ Intent classified: Theological');
        return UserIntent.theological;
      }
    } catch (e) {
      print('⚡ Intent classification error: $e');
      // Default to theological for safety (triggers full Claude response)
      return UserIntent.theological;
    }
  }

  String _buildClassificationPrompt(String userQuery) {
    return '''Classify this user query into ONE category:
A) Navigation - user wants to go to a specific Bible passage (e.g., "Go to John 1", "Open Psalms 23")
B) Simple Search - user wants a definition or fact (e.g., "What does Logos mean?", "Define grace")
C) Theological - user wants spiritual reflection or application (e.g., "Why did this happen to me?", "How does this apply to my struggle?")

Query: "$userQuery"

Respond with ONLY the letter (A, B, or C). No explanation.''';
  }

  /// Check if the classifier is ready to use
  Future<bool> isReady() async {
    return await _qwenService.canInitialize();
  }
}
