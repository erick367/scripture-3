import 'dart:convert';
import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'; // For compute()
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/verse_insight.dart';
import 'mentor_exception.dart';
import 'package:xml/xml.dart' as xml;
import 'token_counter_service.dart';
import 'qwen_service.dart';

/// Top-level function for compute() isolate - parses XML in background
VerseInsight _parseXmlInIsolate(String xmlString) {
  try {
    final document = xml.XmlDocument.parse(xmlString);
    final root = document.findElements('verse_insight').first;

    // Parse Meaning
    final meaning = root.findElements('meaning').first;
    final naturalMeaning = meaning.findElements('natural_language').first.innerText.trim();
    final originalContext = meaning.findElements('original_context').first.innerText.trim();

    // Parse Apply
    final apply = root.findElements('apply').first;
    final soWhat = apply.findElements('so_what').first.innerText.trim();
    final scenario = apply.findElements('scenario').first.innerText.trim();

    // Parse Threads
    final threadsElement = root.findElements('threads').first;
    final threads = threadsElement
        .findElements('connection')
        .map((e) => e.innerText.trim())
        .toList();

    return VerseInsight(
      naturalMeaning: naturalMeaning,
      originalContext: originalContext,
      soWhat: soWhat,
      scenario: scenario,
      threads: threads,
    );
  } catch (e) {
    return VerseInsight(
      naturalMeaning: 'Unable to parse AI response. Please try again.',
      originalContext: 'Error occurred while processing the insight.',
      soWhat: 'Please try refreshing the insight.',
      scenario: 'If this persists, check your connection.',
      threads: ['Error parsing response'],
    );
  }
}

final aiMentorServiceProvider = Provider<AiMentorService>((ref) {
  final tokenCounter = ref.read(tokenCounterServiceProvider);
  final qwenService = ref.read(qwenServiceProvider);
  return AiMentorService(tokenCounter, qwenService);
});

class AiMentorService {
  final TokenCounterService _tokenCounter;
  final QwenService _qwenService;
  AnthropicClient? _client;
  String? _apiKey;

  AiMentorService(this._tokenCounter, this._qwenService);

  Future<void> _ensureInitialized() async {
    if (_client != null) return;
    
    // Load API key from config.json
    final configString = await rootBundle.loadString('config.json');
    final config = json.decode(configString);
    _apiKey = config['CLAUDE_API_KEY'] as String;
    
    _client = AnthropicClient(apiKey: _apiKey!);
  }

  /// Check if device is online and API key is present
  /// Returns true only if both conditions are met
  Future<bool> _canConnect() async {
    // Check network connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    final isOnline = !connectivityResult.contains(ConnectivityResult.none);
    
    // Check if API key is loaded
    await _ensureInitialized();
    final hasApiKey = _apiKey != null && _apiKey!.isNotEmpty;
    
    return isOnline && hasApiKey;
  }

  /// Get AI-powered insights for a Bible verse
  /// 
  /// [verseText] - The actual verse content
  /// [verseReference] - e.g., "John 3:16"
  /// [userThreads] - List of relevant user journal entries for context
  /// [cache] - Optional cache for instant responses
  /// [isAppliedMode] - If true, AI prioritizes practical application
  Future<VerseInsight> getVerseInsight({
    required String verseText,
    required String verseReference,
    List<String> userThreads = const [],
    Map<String, VerseInsight>? cache,
    bool isAppliedMode = false,
  }) async {
    // Check cache first for instant response
    if (cache != null && cache.containsKey(verseReference)) {
      print('✨ Cache hit for $verseReference - instant response!');
      return cache[verseReference]!;
    }
    
    // Validate connectivity before making API call
    if (!await _canConnect()) {
      throw MentorException(
        'The Mentor requires an internet connection to bridge the gap.',
      );
    }
    
    await _ensureInitialized();

    // Build the prompt following theology_rules.md
    final prompt = _buildTheologicalPrompt(verseText, verseReference, userThreads, isAppliedMode: isAppliedMode);

    try {
      // Use streaming for progressive reveal
      String responseText = '';
      
      final stream = _client!.createMessageStream(
        request: CreateMessageRequest(
          model: Model.modelId('claude-3-5-haiku-20241022'), // Fastest model for responsive UX
          maxTokens: 1024, // Reduced from 2048 since we don't need book-length responses
          messages: [
            Message(
              role: MessageRole.user,
              content: MessageContent.text(prompt),
            ),
          ],
        ),
      );

      // Collect streamed response
      await for (final event in stream) {
        event.map(
          messageStart: (_) {},
          messageDelta: (_) {},
          messageStop: (_) {},
          contentBlockStart: (_) {},
          contentBlockDelta: (delta) {
            // Extract text from delta
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

      // Parse XML response (runs on background isolate)
      return await parseMentorResponse(responseText);
    } catch (e) {
      print('Error getting verse insight: $e');
      return _getFallbackInsight(verseReference);
    }
  }

  /// Stream AI-powered insights progressively as they generate
  /// Returns partial insights that update in real-time
  Stream<String> getVerseInsightStream({
    required String verseText,
    required String verseReference,
    List<String> userThreads = const [],
    bool isAppliedMode = false,
  }) async* {
    // Validate connectivity before making API call
    if (!await _canConnect()) {
      throw MentorException(
        'The Mentor requires an internet connection to bridge the gap.',
      );
    }
    
    await _ensureInitialized();

    // Build the prompt
    final prompt = _buildTheologicalPrompt(verseText, verseReference, userThreads, isAppliedMode: isAppliedMode);

    try {
      String responseText = '';
      
      final stream = _client!.createMessageStream(
        request: CreateMessageRequest(
          model: Model.modelId('claude-sonnet-4-5-20250929'),
          maxTokens: 1024,
          temperature: 0.7, // Higher creativity to avoid repetitive "This verse..." openings
          messages: [
            Message(
              role: MessageRole.user,
              content: MessageContent.text(prompt),
            ),
          ],
        ),
      );

      // Yield progressive updates as text arrives
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
                // Yield current accumulated text
                // Note: We yield raw XML, parsing happens in UI
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
        
        // Yield after each event
        if (responseText.isNotEmpty) {
          yield responseText;
        }
      }
    } catch (e) {
      print('Error streaming verse insight: $e');
      yield 'Error: Unable to generate insight';
    }
  }

  String _buildTheologicalPrompt(
    String verseText,
    String verseReference,
    List<String> userThreads, {
    bool isAppliedMode = false,
  }) {
    // Guidelines for Context Window (Token Guard)
    // We want to reserve ~1000 tokens for the system prompt & verse
    // Leaving ~3000 tokens for user threads (if limit is 4096)
    // Detailed optimization:
    
    String threadsContext = '';
    
    if (userThreads.isNotEmpty) {
      // 1. Estimate Base Cost
      final basePromptCost = _tokenCounter.estimateTokens(verseText + verseReference + "You are a Biblical scholar...");
      
      // 2. Budget for Threads
      final availableTokens = 3000 - basePromptCost;
      
      // 3. Select Threads that fit
      List<String> keptThreads = [];
      int usedTokens = 0;
      
      // Prioritize recent threads (assuming list is sorted recent-first or relevant-first)
      // If relevant-first (Vector Search), we keep top ones.
      for (final thread in userThreads) {
        final cost = _tokenCounter.estimateTokens(thread);
        if (usedTokens + cost < availableTokens) {
          keptThreads.add(thread);
          usedTokens += cost;
        } else {
          break; // Stop if budget exceeded
        }
      }
      
      if (keptThreads.isNotEmpty) {
        threadsContext = '\n\nUser\'s Past Reflections (Context):\n${keptThreads.join('\n')}';
      }
    }

    // Adjust priority based on Applied mode
    final modeGuidance = isAppliedMode
        ? '''**Priority Mode: Applied (Modern Guidance)**
- LEAD with practical application (the "So What?")
- Start your <natural_language> with a real-world takeaway
- Spend more detail on <apply> than <meaning>
'''
        : '''**Priority Mode: Literal (Scholarly)**
- LEAD with linguistic and historical context
- Prioritize Greek/Hebrew insights in your response
''';

    return '''You are a Biblical scholar and spiritual mentor. Provide rich, insightful analysis:

**Verse**: $verseReference
"$verseText"
$threadsContext

$modeGuidance

**Respond in this exact XML format:**

<verse_insight>
  <meaning>
    <natural_language>Provide an empathetic, conversational summary that captures the heart of this verse (2-3 sentences)</natural_language>
    <original_context>Share Greek/Hebrew insights, historical context, or cultural background that enriches understanding (2-3 sentences)</original_context>
  </meaning>
  <apply>
    <so_what>Explain the practical "So What?" - how this truth applies to modern life, relationships, work, or faith (2-3 sentences)</so_what>
    <scenario>Give a vivid, concrete example or scenario that brings this to life (1-2 sentences)</scenario>
  </apply>
  <threads>
    <connection>Related verse with reference and brief explanation</connection>
    <connection>Another related verse or Old Testament typology</connection>
    <connection>Cross-reference showing the narrative bridge</connection>
  </threads>
</verse_insight>

**Guidelines:**
- Be warm, scholarly, and encouraging
- Cite original language insights when meaningful
- Focus on practical wisdom and life application
- Make it feel like a trusted mentor speaking
- **CRITICAL**: Do NOT start sentences with "This verse", "Here we see", or "In this passage". Be creative and varied in your sentence structure.
- **CRITICAL**: Make every insight unique. Do not use a template.
''';
  }

  /// Parse XML response from Claude into VerseInsight model
  /// Uses compute() to run on a background isolate
  Future<VerseInsight> parseMentorResponse(String xmlString) async {
    return compute(_parseXmlInIsolate, xmlString);
  }
  
  /// Synchronous parse for cases where async isn't possible (legacy)
  VerseInsight parseMentorResponseSync(String xmlString) {
    return _parseXmlInIsolate(xmlString);
  }

  VerseInsight _getFallbackInsight(String verseReference) {
    return VerseInsight(
      naturalMeaning: 'Unable to generate insight at this time.',
      originalContext: 'Please try again later or check your internet connection.',
      soWhat: 'Take time to meditate on this verse yourself.',
      scenario: 'Consider journaling your own thoughts about what this verse means to you.',
      threads: [
        'Try tapping another insight trigger',
        'Check your connection and try again',
      ],
    );
  }

  // ============================================================
  // QWEN-POWERED INSTANT RESPONSES (Hybrid Workflow)
  // ============================================================

  /// Generate an instant 1-2 sentence preview using on-device Qwen AI
  /// Returns quickly (<250ms) while Claude loads the full insight
  /// 
  /// Returns null if Qwen is unavailable (falls through to Claude)
  Future<String?> getInstantPreview({
    required String verseText,
    required String verseReference,
  }) async {
    final totalStopwatch = Stopwatch()..start();
    
    try {
      // Check if Qwen can initialize (battery guard)
      final canInitStopwatch = Stopwatch()..start();
      if (!await _qwenService.canInitialize()) {
        print('⚡ Qwen skipped: Not available (Battery or Platform)');
        return null;
      }
      print('⚡ [PERF] canInitialize check: ${canInitStopwatch.elapsedMilliseconds}ms');

      final prompt = '''Task: Generate a bold, 1-sentence spiritual insight (max 20 words).

Verse: "The LORD is my shepherd; I shall not want."
Insight: Your lack of need is proof of God's personal ownership of your life.

Verse: "Trust in the LORD with all your heart"
Insight: Your anxiety is an invitation to surrender explicit control to God.

Verse: "$verseText"
Insight:''';

      print('⚡ [PERF] Starting Qwen generation...');
      final genStopwatch = Stopwatch()..start();
      
      final preview = await _qwenService.generate(
        prompt,
        maxTokens: 50,  // Adjusted from 30 for better length balance
        temperature: 0.7,  // Lowered to stop instruction regurgitation
      );
      
      genStopwatch.stop();
      totalStopwatch.stop();

      print('⚡ [PERF] Qwen generation only: ${genStopwatch.elapsedMilliseconds}ms');
      print('⚡ [PERF] TOTAL WALL CLOCK: ${totalStopwatch.elapsedMilliseconds}ms');
      print('⚡ Qwen preview generated: ${preview.length} chars');
      
      return preview;
    } catch (e) {
      totalStopwatch.stop();
      print('⚡ [PERF] Failed after ${totalStopwatch.elapsedMilliseconds}ms');
      print('⚡ Qwen preview failed (falling through to Claude): $e');
      return null; // Fail gracefully, Claude will load anyway
    }
  }

  /// Stream instant preview using Qwen (Typing Effect)
  Stream<String> getInstantPreviewStream({
    required String verseText,
    required String verseReference,
  }) async* {
    if (!await _qwenService.canInitialize()) {
      yield* const Stream.empty();
      return;
    }

    final prompt = '''Task: Generate a bold, 1-sentence spiritual insight (max 20 words).
Verse: "$verseText"
Insight:''';

    yield* _qwenService.generateStream(
      prompt,
      maxTokens: 50,
    ).map((text) {
      // Clean up common prefixes on the fly
      var cleaned = text
          .replaceFirst(RegExp(r'^Lesson:\s*', caseSensitive: false), '')
          .replaceFirst(RegExp(r'^Insight:\s*', caseSensitive: false), '')
          .replaceFirst(RegExp(r'^Takeaway:\s*', caseSensitive: false), '')
          .trim();
      // Remove quotes if they appear at start/end
      if (cleaned.startsWith('"')) cleaned = cleaned.substring(1);
      return cleaned;
    });
  }

  /// Generate a short, empathetic follow-up question for the Home Screen
  /// Uses Qwen first for instant response, falls back to Claude if needed
  Future<String> getMentorFollowUp(String userContent) async {
    // Try Qwen first (on-device, instant ~200ms)
    try {
      if (await _qwenService.canInitialize()) {
        final qwenPrompt = '''The user wrote: "$userContent"

Generate a 1-sentence follow-up question (max 15 words) that:
1. Acknowledges their specific situation
2. Points to a scriptural truth

Be warm and personal. No introduction, just the question.''';

        final response = await _qwenService.generate(
          qwenPrompt,
          maxTokens: 40,
          temperature: 0.7,
        );

        final cleaned = response.trim().replaceAll('"', '');
        if (cleaned.isNotEmpty) {
          print('⚡ Qwen follow-up generated successfully');
          return cleaned;
        }
      }
    } catch (e) {
      print('⚡ Qwen follow-up failed, trying Claude: $e');
    }

    // Fall back to Claude if Qwen fails or is unavailable
    return await _getClaudeFollowUp(userContent);
  }

  /// Claude-powered follow-up (fallback when Qwen unavailable)
  Future<String> _getClaudeFollowUp(String userContent) async {
    if (!await _canConnect()) {
      return "Reflect on your journey today.";
    }
    
    await _ensureInitialized();

    final systemPrompt = "You are the ScriptureLens Mentor (Rule 04). The user previously wrote: <user_context>$userContent</user_context>. Generate a one-sentence follow-up question. Acknowledge their specific situation from the context and bridge it to a relevant scriptural truth. Keep it under 15 words.";

    try {
      String responseText = '';
      
      final stream = _client!.createMessageStream(
        request: CreateMessageRequest(
          model: Model.modelId('claude-sonnet-4-5-20250929'),
          maxTokens: 100, // Short response
          messages: [
            Message(
              role: MessageRole.user,
              content: MessageContent.text(systemPrompt),
            ),
          ],
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
      
      return responseText.trim().replaceAll('"', '');
    } catch (e) {
      return "How is your heart feeling today?";
    }
  }

  /// Get a simple definition for a biblical term using Qwen (instant)
  /// Falls back to Claude for complex or unknown terms
  /// 
  /// [term] - The word or phrase to define (e.g., "Logos", "grace", "covenant")
  /// Returns a 2-3 sentence definition with original language insight
  Future<String> getSimpleDefinition(String term) async {
    // Try Qwen first (on-device, instant ~250ms)
    try {
      if (await _qwenService.canInitialize()) {
        final qwenPrompt = '''Define this biblical term in 2-3 sentences:

Term: "$term"

Include:
- Original language (Greek/Hebrew) if applicable
- Simple modern definition
- One example verse reference

Be concise and scholarly but accessible.''';

        final response = await _qwenService.generate(
          qwenPrompt,
          maxTokens: 150,
          temperature: 0.5, // Lower temp for factual accuracy
        );

        if (response.isNotEmpty && !response.contains('Error')) {
          print('⚡ Qwen definition generated for "$term"');
          return response.trim();
        }
      }
    } catch (e) {
      print('⚡ Qwen definition failed, trying Claude: $e');
    }

    // Fall back to Claude for complex terms or when Qwen unavailable
    return await _getClaudeDefinition(term);
  }

  /// Rewrite a verse in simple, modern English using Qwen
  Future<String> simplifyVerse(String verseText) async {
    // Try Qwen first (instant)
    try {
      if (await _qwenService.canInitialize()) {
        final prompt = '''Rewrite this Bible verse in clear, simple modern English (CEV style).
Keep the meaning but make it easy to understand. Max 1 sentence.

Verse: "$verseText"
Simple:''';

        final response = await _qwenService.generate(
          prompt,
          maxTokens: 60,
          temperature: 0.6, // Balanced for accuracy and readability
        );

        return response.trim();
      }
    } catch (e) {
      print('⚡ Qwen simplify failed: $e');
    }
    return "Simplification unavailable.";
  }


  /// Convert user feeling/sentence into Search Keywords (for Smart Search)
  Future<List<String>> extractSearchKeywords(String feeling) async {
    try {
      if (await _qwenService.canInitialize()) {
        final prompt = '''Extract 2-3 single-word Biblical keywords related to this feeling for a search query.
Output ONLY the keywords separated by commas. No extra text.

Feeling: "I feel anxious about money"
Keywords: Anxiety, Provision, Trust

Feeling: "I am lonely"
Keywords: Comfort, Friend, Presence

Feeling: "$feeling"
Keywords:''';

        final response = await _qwenService.generate(
          prompt,
          maxTokens: 20,
          temperature: 0.3, // Low temp for factual extraction
        );

        // Parse: "Commas, separated" -> ["Commas", "separated"]
        return response
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
    } catch (e) {
      print('⚡ Keyword extraction failed: $e');
    }
    // Fallback: use original words > 3 chars
    return feeling.split(' ').where((w) => w.length > 3).toList();
  }

  /// Claude-powered definition (fallback for complex terms)
  Future<String> _getClaudeDefinition(String term) async {
    if (!await _canConnect()) {
      return "Definition unavailable offline. '$term' is a significant biblical concept.";
    }
    
    await _ensureInitialized();

    final prompt = '''You are the ScriptureLens Mentor. Define this biblical term:

Term: "$term"

Provide:
1. Original language (Greek/Hebrew) with transliteration
2. Core meaning in 1-2 sentences
3. Theological significance
4. One key verse reference

Keep it under 100 words. Be scholarly but accessible.''';

    try {
      String responseText = '';
      
      final stream = _client!.createMessageStream(
        request: CreateMessageRequest(
          model: Model.modelId('claude-sonnet-4-5-20250929'),
          maxTokens: 200,
          messages: [
            Message(
              role: MessageRole.user,
              content: MessageContent.text(prompt),
            ),
          ],
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
      print('Error getting Claude definition: $e');
      return "'$term' - A significant biblical concept. Check a concordance for details.";
    }
  }

  /// Generate a specific historical context bridge for archaeological discoveries
  Future<String> getDiscoveryContext({
    required String discoveryName,
    required String connectedVerse,
    required String description,
  }) async {
    if (!await _canConnect()) {
      return "The Mentor requires an internet connection to bridge history.";
    }
    
    await _ensureInitialized();

    final systemPrompt = '''
You are the ScriptureLens Mentor (Rule 04).
Task: Explain how the archaeological discovery "$discoveryName" specifically supports the historical reliability of the verse "$connectedVerse".
Context: $description
Constraint: Keep it under 100 words. Be scholarly but accessible. Focus on the evidence.
''';

    try {
      String responseText = '';
      
      final stream = _client!.createMessageStream(
        request: CreateMessageRequest(
          model: Model.modelId('claude-sonnet-4-5-20250929'),
          maxTokens: 300,
          messages: [
            Message(
              role: MessageRole.user,
              content: MessageContent.text(systemPrompt),
            ),
          ],
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
      print('Error generating discovery context: $e');
      return "Unable to retrieve historical context at this moment.";
    }
  }

  /// Get context breakthrough for stuck users
  /// Generates historical background tailored to user's emotional state
  Future<String> getContextBreakthrough({
    required String book,
    required String chapter,
    required String emotionalState,
  }) async {
    if (!await _canConnect()) {
      return "You're reading $book $chapter. This passage holds important context for your spiritual journey. Try reconnecting to get personalized insights.";
    }

    await _ensureInitialized();

    try {
      final prompt = '''You are the ScriptureLens AI Mentor, a scholarly yet empathetic guide.

A user has been stuck in their Bible reading for 3+ days. Their last location was $book chapter $chapter, and their current emotional state is: $emotionalState.

Generate 3 concise bullet points explaining the historical background of $book chapter $chapter. Each point should:
1. Connect to why a modern person feeling "$emotionalState" might find this passage challenging
2. Be 1-2 sentences maximum
3. Focus on making the ancient context relatable to modern struggles

Format as plain bullet points with "•" prefix. No intro, no conclusion—just the 3 points.''';

      final request = CreateMessageRequest(
        model: const Model.model(Models.claude35Sonnet20241022),
        maxTokens: 300,
        messages: [
          Message(
            role: MessageRole.user,
            content: MessageContent.text(prompt),
          ),
        ],
        temperature: 0.7,
      );

      final response = await _client!.createMessage(request: request);
      
      // Extract text from response content
      String contextText = '';
      final contentBlock = response.content;
      contentBlock.mapOrNull(
        blocks: (blocks) {
          for (final block in blocks.value) {
            block.mapOrNull(
              text: (textBlock) {
                contextText = textBlock.text;
              },
            );
          }
        },
        text: (textValue) {
          contextText = textValue.value;
        },
      );

      return contextText.trim();
      
    } catch (e) {
      print('Error generating context breakthrough: $e');
      return "Historical context for $book is currently unavailable. Continue reading—the meaning will unfold.";
    }
  }

  /// Get scholar's correction for DBS retelling
  /// Compares user's summary to actual text and offers gentle correction
  Future<String?> getScholarCorrection({
    required String passageReference,
    required String actualText,
    required String userRetelling,
  }) async {
    if (!await _canConnect()) {
      return null; // Silently skip if offline
    }

    await _ensureInitialized();

    try {
      final prompt = '''You are the ScriptureLens AI Mentor.

A user just retold $passageReference in their own words. Compare their summary to the actual text.

**Actual Text:**
"$actualText"

**User's Retelling:**
"$userRetelling"

If they missed a KEY theological nuance (not minor details), provide a brief "Scholar's Correction" in exactly 2 sentences. Be encouraging, not critical.

If their retelling captures the core meaning well, respond with only: "APPROVED"

Examples of key nuances to correct:
- Misunderstanding who is speaking/acting
- Missing the central theological point (grace vs. works, covenant relationship, etc.)
- Reversing the meaning (e.g., saying judgment when it's mercy)

Do NOT correct minor details like exact wording, sequence of events, or names.''';

      final request = CreateMessageRequest(
        model: const Model.model(Models.claude35Sonnet20241022),
        maxTokens: 150,
        messages: [
          Message(
            role: MessageRole.user,
            content: MessageContent.text(prompt),
          ),
        ],
        temperature: 0.5,
      );

      final response = await _client!.createMessage(request: request);
      
      // Extract text from response content
      String correctionText = '';
      final contentBlock = response.content;
      contentBlock.mapOrNull(
        blocks: (blocks) {
          for (final block in blocks.value) {
            block.mapOrNull(
              text: (textBlock) {
                correctionText = textBlock.text;
              },
            );
          }
        },
        text: (textValue) {
          correctionText = textValue.value;
        },
      );

      final trimmed = correctionText.trim();
      return trimmed == "APPROVED" ? null : trimmed;
      
    } catch (e) {
      print('Error getting scholar correction: $e');
      return null; // Fail gracefully
    }
  }

  /// Generate a pastoral follow-up question based on user's initial intent
  /// Uses Claude for high-quality, empathetic questions (not generic Qwen)
  /// 
  /// [userMessage] - The user's initial spiritual request or concern
  /// Returns a warm, clarifying question to understand their situation better
  Future<String> generateFollowUpQuestion(String userMessage) async {
    // Validate connectivity before making API call
    if (!await _canConnect()) {
      // Fallback to a gentle default question
      return "Tell me more about what's on your heart today.";
    }
    
    await _ensureInitialized();

    final prompt = '''You are a warm, pastoral spiritual companion. The user just shared:

"$userMessage"

Generate ONE clarifying follow-up question to understand their specific situation better. Be:
- Warm and empathetic (not clinical)
- Specific to what they shared (not generic)
- Open-ended to invite sharing
- Brief (max 20 words)

Examples:
- If they mention stress: "What aspect of this situation weighs most heavily on you right now?"
- If seeking direction: "What decision or path are you prayerfully considering?"
- If expressing gratitude: "How has God's faithfulness shown up in your life lately?"

Question:''';

    try {
      final response = await _client!.createMessage(
        request: CreateMessageRequest(
          model: Model.modelId('claude-3-5-haiku-20241022'),
          maxTokens: 100,
          messages: [
            Message(
              role: MessageRole.user,
              content: MessageContent.text(prompt),
            ),
          ],
        ),
      );

      // Extract text from response
      String questionText = '';
      final contentBlock = response.content;
      contentBlock.mapOrNull(
        blocks: (blocks) {
          for (final block in blocks.value) {
            block.mapOrNull(
              text: (textBlock) {
                questionText = textBlock.text;
              },
            );
          }
        },
        text: (textValue) {
          questionText = textValue.value;
        },
      );

      final trimmed = questionText.trim();
      return trimmed.isEmpty 
          ? "Tell me more about what's on your heart today." 
          : trimmed;
      
    } catch (e) {
      print('Error generating follow-up: $e');
      return "Tell me more about what's on your heart today.";
    }
  }
}
