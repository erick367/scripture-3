import 'package:flutter_riverpod/flutter_riverpod.dart';

final tokenCounterServiceProvider = Provider<TokenCounterService>((ref) {
  return TokenCounterService();
});

class TokenCounterService {
  // Approximate conversion rate for English text
  static const double _charsPerToken = 4.0;
  
  // Safe limit allowing for response tokens
  static const int _maxInputTokens = 4000;

  /// Estimates token count based on character length
  int estimateTokens(String text) {
    if (text.isEmpty) return 0;
    return (text.length / _charsPerToken).ceil();
  }

  /// Truncates conversation history to fit within token limit
  /// Strategy: Keep System Prompt + Latest User Message.
  /// Prune oldest history until fit.
  List<Map<String, String>> optimizeHistory(
    String systemPrompt, 
    List<Map<String, String>> history, 
    String newMessage
  ) {
    int currentTokens = estimateTokens(systemPrompt) + estimateTokens(newMessage);
    
    // Reverse list to safely remove from start (oldest)
    // Actually, we want to construct a new list
    List<Map<String, String>> keptHistory = [];
    
    // Always calculate from end (latest) backwards
    for (int i = history.length - 1; i >= 0; i--) {
      final msg = history[i];
      final content = msg['content'] ?? '';
      final cost = estimateTokens(content);
      
      if (currentTokens + cost < _maxInputTokens) {
        keptHistory.insert(0, msg);
        currentTokens += cost;
      } else {
        // Stop adding history once we hit limit
        break;
      }
    }
    
    return keptHistory;
  }
}
