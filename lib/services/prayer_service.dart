import 'dart:convert';
import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'qwen_service.dart';

final prayerServiceProvider = Provider<PrayerService>((ref) {
  final qwenService = ref.watch(qwenServiceProvider);
  return PrayerService(qwenService);
});

/// Service for generating biblical prayers using the ACTS model
/// (Adoration, Confession, Thanksgiving, Supplication)
/// 
/// Hybrid workflow:
/// - Quick Prayer: Qwen generates 2-sentence prayer instantly (~200ms)
/// - Deep Prayer: Claude generates full ACTS 3-sentence prayer (~1-2s)
class PrayerService {
  final QwenService _qwenService;
  AnthropicClient? _client;
  String? _apiKey;

  PrayerService(this._qwenService);

  Future<void> _ensureInitialized() async {
    if (_client != null) return;
    
    // Load API key from config.json
    final configString = await rootBundle.loadString('config.json');
    final config = json.decode(configString);
    _apiKey = config['CLAUDE_API_KEY'] as String;
    
    _client = AnthropicClient(apiKey: _apiKey!);
  }

  /// Check if device is online and API key is present
  Future<bool> _canConnect() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final isOnline = !connectivityResult.contains(ConnectivityResult.none);
    
    await _ensureInitialized();
    final hasApiKey = _apiKey != null && _apiKey!.isNotEmpty;
    
    return isOnline && hasApiKey;
  }

  // ============================================================
  // QWEN-POWERED QUICK PRAYER (Phase 2)
  // ============================================================

  /// Generate a quick 2-sentence prayer using Qwen (instant ~200ms)
  /// Perfect for in-app moments when user wants immediate guidance
  /// 
  /// [verseReference] - e.g., "John 3:16"
  /// [userTheme] - The user's current spiritual theme (e.g., "Patience", "Seeking")
  Future<String> generateQuickPrayer({
    required String verseReference,
    required String userTheme,
  }) async {
    // Try Qwen first (on-device, instant)
    try {
      if (await _qwenService.canInitialize()) {
        final prompt = '''Generate a short 2-sentence prayer:

Verse: $verseReference
User's current theme: $userTheme

Sentence 1: Praise God for the truth in this verse's message
Sentence 2: Ask for help with the user's theme

Be warm, personal, and biblically sound. End with "In Jesus' name, Amen."''';

        final response = await _qwenService.generate(
          prompt,
          maxTokens: 80,
          temperature: 0.8, // Slightly creative for prayer variety
        );

        if (response.isNotEmpty && !response.contains('Error')) {
          print('⚡ Qwen quick prayer generated');
          return response.trim();
        }
      }
    } catch (e) {
      print('⚡ Qwen prayer failed: $e');
    }

    // Fallback to template prayer (no Claude call for quick prayers)
    return _getFallbackPrayer(verseReference, userTheme);
  }

  // ============================================================
  // CLAUDE-POWERED DEEP PRAYER (Original ACTS Model)
  // ============================================================

  /// Generate a 3-sentence prayer following the ACTS model
  /// Uses Claude for deep, theologically rich prayers
  /// 
  /// [verseText] - The actual verse content
  /// [verseReference] - e.g., "John 3:16"
  /// [userTheme] - The user's current spiritual theme/struggle (e.g., "Seeking", "Grateful")
  Future<String> generatePrayer({
    required String verseText,
    required String verseReference,
    required String userTheme,
  }) async {
    if (!await _canConnect()) {
      return _getFallbackPrayer(verseReference, userTheme);
    }
    
    await _ensureInitialized();

    final prompt = _buildPrayerPrompt(verseText, verseReference, userTheme);

    try {
      String responseText = '';
      
      final stream = _client!.createMessageStream(
        request: CreateMessageRequest(
          model: Model.modelId('claude-sonnet-4-5-20250929'),
          maxTokens: 200, // Short prayer
          messages: [
            Message(
              role: MessageRole.user,
              content: MessageContent.text(prompt),
            ),
          ],
          temperature: 0.7, // Slightly creative but consistent
        ),
      );

      await for (final event in stream) {
        event.map(
          messageStart: (_) {},
          messageDelta: (_) {},
          messageStop: (_) {},
          contentBlockStart: (_) {},
          contentBlockDelta: (delta) {
            delta.delta.map(
              textDelta: (textDelta) {
                responseText += textDelta.text;
              },
              inputJsonDelta: (_) {},
            );
          },
          contentBlockStop: (_) {},
          ping: (_) {},
          error: (error) {
            print('Stream error: ${error.error}');
          },
        );
      }

      return responseText.trim();
    } catch (e) {
      print('Error generating prayer: $e');
      return _getFallbackPrayer(verseReference, userTheme);
    }
  }

  /// Convenience method: Try quick prayer first, then offer deep prayer
  /// Returns a tuple of (quickPrayer, deepPrayerFuture)
  Future<({String quickPrayer, Future<String> deepPrayer})> generateProgressivePrayer({
    required String verseText,
    required String verseReference,
    required String userTheme,
  }) async {
    // Get quick prayer immediately
    final quick = await generateQuickPrayer(
      verseReference: verseReference,
      userTheme: userTheme,
    );

    // Prepare deep prayer future (only called if user wants more)
    final deepFuture = generatePrayer(
      verseText: verseText,
      verseReference: verseReference,
      userTheme: userTheme,
    );

    return (quickPrayer: quick, deepPrayer: deepFuture);
  }

  String _buildPrayerPrompt(String verseText, String verseReference, String userTheme) {
    return '''You are the ScriptureLens Prayer Guide, a warm and theologically sound spiritual companion.

Generate a 3-sentence prayer following the ACTS model:

**Sentence 1: Adoration**
- Praise God using themes from the verse below
- Be specific to the verse's content

**Sentence 2: Supplication**
- Address the user's current spiritual theme: "$userTheme"
- Connect it to the verse's message

**Sentence 3: Seal**
- Close the prayer in Jesus' name
- Make it personal and warm

**Verse:** $verseReference
"$verseText"

**User's Current Theme:** $userTheme

Generate ONLY the 3-sentence prayer. No introduction, no explanation. Keep it warm, personal, and theologically sound.''';
  }

  String _getFallbackPrayer(String verseReference, String userTheme) {
    return '''Father, we praise You for the truth revealed in $verseReference. 
As we reflect on Your Word, guide us through this season of $userTheme and draw us closer to Your heart. 
In Jesus' name, Amen.''';
  }
}
