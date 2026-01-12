import 'package:flutter_test/flutter_test.dart';
import 'package:scripture_lens/services/ai_mentor_service.dart';
import 'package:scripture_lens/services/token_counter_service.dart';
import 'package:scripture_lens/services/qwen_service.dart';
import 'package:scripture_lens/services/battery_guard_service.dart';
import 'package:scripture_lens/services/model_preloader_service.dart';
import 'package:scripture_lens/models/verse_insight.dart';

void main() {
  group('AI Mentor XML Parser Tests', () {
    late AiMentorService service;
    
    setUp(() {
      // Create mock dependencies for testing
      final tokenCounter = TokenCounterService();
      final batteryGuard = BatteryGuardService();
      final modelPreloader = ModelPreloaderService();
      final qwenService = QwenService(batteryGuard, modelPreloader);
      
      service = AiMentorService(tokenCounter, qwenService);
    });
    
    test('Should correctly parse complete XML response', () async {
      // 1. Mock Claude Response (matching actual XML structure)
      const mockClaudeResponse = '''
<verse_insight>
  <meaning>
    <natural_language>In the beginning (Arche) refers to the source of all things.</natural_language>
    <original_context>The Greek word Arche carries deep philosophical meaning.</original_context>
  </meaning>
  <apply>
    <so_what>Seek purpose. Trust the process.</so_what>
    <scenario>Consider how beginnings shape your journey.</scenario>
  </apply>
  <threads>
    <connection>You felt hopeful on Jan 1; this verse confirms that hope.</connection>
  </threads>
</verse_insight>
''';

      // 2. Parse the response (now async due to compute())
      final result = await service.parseMentorResponse(mockClaudeResponse);

      // 3. Assertions
      expect(result, isA<VerseInsight>());
      
      // Verify Meaning tab content
      expect(
        result.naturalMeaning,
        contains('In the beginning (Arche)'),
        reason: 'Should extract natural meaning correctly',
      );

      expect(
        result.originalContext,
        contains('Greek word Arche'),
        reason: 'Should extract original context correctly',
      );

      // Verify Apply tab content
      expect(
        result.soWhat,
        contains('Seek purpose'),
        reason: 'Should extract so_what content',
      );

      expect(
        result.scenario,
        contains('beginnings shape your journey'),
        reason: 'Should extract scenario content',
      );

      // Verify Threads tab content
      expect(
        result.threads,
        isNotEmpty,
        reason: 'Should have at least one thread',
      );
      expect(
        result.threads.first,
        contains('You felt hopeful on Jan 1'),
        reason: 'Should extract thread content correctly',
      );
    });

    test('Should handle malformed XML gracefully', () async {
      const malformedXml = '<verse_insight><meaning>Incomplete';

      // Should return fallback, not crash
      final result = await service.parseMentorResponse(malformedXml);
      
      expect(result, isA<VerseInsight>());
      // Should have fallback content
      expect(result.naturalMeaning, isNotEmpty);
    });

    test('Should handle empty XML tags', () async {
      const emptyXml = '''
<verse_insight>
  <meaning>
    <natural_language></natural_language>
    <original_context></original_context>
  </meaning>
  <apply>
    <so_what></so_what>
    <scenario></scenario>
  </apply>
  <threads>
  </threads>
</verse_insight>
''';

      final result = await service.parseMentorResponse(emptyXml);

      expect(result, isA<VerseInsight>());
      // Should have default/empty values, not crash
    });
  });
}
