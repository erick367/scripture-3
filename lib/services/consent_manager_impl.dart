import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../domain/services/consent_manager.dart';
import '../core/database/app_database.dart';
import 'qwen_service.dart';

/// Implementation of ConsentManager for privacy and consent handling
/// 
/// Responsibilities:
/// - Track user consent for AI features
/// - Run PII scrubbing on journal text before cloud handoff
/// - Maintain audit log of consent decisions
/// - Gate embedding/sync features behind consent
class ConsentManagerImpl implements ConsentManager {
  final AppDatabase _db;
  final FlutterSecureStorage _secureStorage;
  final QwenService? _qwenService;
  
  static const _globalAiEnabledKey = 'global_cloud_ai_enabled';
  
  ConsentManagerImpl({
    required AppDatabase db,
    FlutterSecureStorage? secureStorage,
    QwenService? qwenService,
  }) : _db = db,
       _secureStorage = secureStorage ?? const FlutterSecureStorage(),
       _qwenService = qwenService;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Consent Tracking
  // ═══════════════════════════════════════════════════════════════════════════
  
  @override
  Future<bool> hasConsent(ConsentFeature feature) async {
    final events = await getAuditLog(limit: 100);
    
    // Find most recent decision for this feature
    for (final event in events) {
      if (event.feature == feature) {
        return event.granted;
      }
    }
    
    // Default: no consent
    return false;
  }
  
  @override
  Future<bool> requestConsent(ConsentFeature feature) async {
    // This would typically trigger a UI modal
    // For now, return current state (UI handles modal display)
    return hasConsent(feature);
  }
  
  @override
  Future<void> recordConsent({
    required ConsentFeature feature,
    required bool granted,
  }) async {
    await _db.insertConsentEvent(
      feature: feature.name,
      granted: granted,
    );
  }
  
  @override
  Future<void> revokeConsent(ConsentFeature feature) async {
    await recordConsent(feature: feature, granted: false);
  }
  
  @override
  Future<List<ConsentEvent>> getAuditLog({int limit = 50}) async {
    final rows = await _db.getConsentEvents(limit: limit);
    return rows.map((row) => ConsentEvent.fromDb(row)).toList();
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PII Scrubbing
  // ═══════════════════════════════════════════════════════════════════════════
  
  @override
  Future<String> scrubPII(String rawText) async {
    var scrubbed = rawText;
    
    // 1. Email addresses
    scrubbed = _emailPattern.replaceAll(scrubbed, '[REDACTED_EMAIL]');
    
    // 2. Phone numbers (various formats)
    scrubbed = _phonePattern.replaceAll(scrubbed, '[REDACTED_PHONE]');
    
    // 3. Social Security Numbers (US)
    scrubbed = _ssnPattern.replaceAll(scrubbed, '[REDACTED_ID]');
    
    // 4. Credit card numbers
    scrubbed = _creditCardPattern.replaceAll(scrubbed, '[REDACTED_CARD]');
    
    // 5. Names (use Qwen if available, otherwise regex heuristics)
    if (_qwenService != null) {
      try {
        scrubbed = await _scrubNamesWithQwen(scrubbed);
      } catch (e) {
        // Fallback to regex
        scrubbed = _scrubNamesWithRegex(scrubbed);
      }
    } else {
      scrubbed = _scrubNamesWithRegex(scrubbed);
    }
    
    // 6. Addresses (basic pattern)
    scrubbed = _addressPattern.replaceAll(scrubbed, '[REDACTED_ADDRESS]');
    
    return scrubbed;
  }
  
  /// Use Qwen for intelligent name detection
  Future<String> _scrubNamesWithQwen(String text) async {
    if (_qwenService == null) return text;
    
    final prompt = '''
Identify all personal names in this text and return only a comma-separated list of names found. 
Return ONLY the names, nothing else. If no names, return "NONE".

Text: "$text"

Names:''';
    
    final response = await _qwenService!.generate(prompt, maxTokens: 50);
    
    if (response.trim().toUpperCase() == 'NONE') return text;
    
    var scrubbed = text;
    final names = response.split(',').map((n) => n.trim()).where((n) => n.isNotEmpty);
    
    for (final name in names) {
      if (name.length > 2) {
        scrubbed = scrubbed.replaceAll(RegExp(RegExp.escape(name), caseSensitive: false), '[REDACTED_NAME]');
      }
    }
    
    return scrubbed;
  }
  
  /// Fallback regex-based name detection
  String _scrubNamesWithRegex(String text) {
    // Common name patterns (capitalized words that aren't at start of sentence)
    // This is imperfect but provides basic protection
    var scrubbed = text;
    
    // Pattern: "my [relationship] [Name]" e.g., "my friend John"
    scrubbed = _relationshipNamePattern.replaceAllMapped(scrubbed, (match) {
      return '${match.group(1)}[REDACTED_NAME]';
    });
    
    return scrubbed;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Global AI Settings
  // ═══════════════════════════════════════════════════════════════════════════
  
  @override
  Future<bool> isCloudAIEnabled() async {
    final value = await _secureStorage.read(key: _globalAiEnabledKey);
    return value == 'true';
  }
  
  @override
  Future<void> setCloudAIEnabled(bool enabled) async {
    await _secureStorage.write(key: _globalAiEnabledKey, value: enabled.toString());
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Regex Patterns
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Email: standard email pattern
  static final _emailPattern = RegExp(
    r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
  );
  
  // Phone: various formats (US-centric + international)
  static final _phonePattern = RegExp(
    r'(?:\+?\d{1,3}[-.\s]?)?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}',
  );
  
  // SSN: XXX-XX-XXXX
  static final _ssnPattern = RegExp(
    r'\d{3}[-]?\d{2}[-]?\d{4}',
  );
  
  // Credit cards: 13-19 digits with optional separators
  static final _creditCardPattern = RegExp(
    r'\d{4}[-\s]?\d{4}[-\s]?\d{4}[-\s]?\d{1,4}',
  );
  
  // Address: basic street address pattern
  static final _addressPattern = RegExp(
    r'\d+\s+[A-Za-z]+\s+(?:Street|St|Avenue|Ave|Road|Rd|Boulevard|Blvd|Drive|Dr|Lane|Ln|Court|Ct|Way)\.?(?:\s+(?:Apt|Suite|Unit|#)\s*\d+)?',
    caseSensitive: false,
  );
  
  // Relationship + name pattern
  static final _relationshipNamePattern = RegExp(
    r'(my\s+(?:friend|brother|sister|mom|mother|dad|father|husband|wife|partner|boss|coworker|colleague|neighbor)\s+)([A-Z][a-z]+)',
    caseSensitive: false,
  );
}

/// Riverpod provider for ConsentManager
final consentManagerProvider = Provider<ConsentManager>((ref) {
  final db = ref.read(appDatabaseProvider);
  final qwen = ref.read(qwenServiceProvider);
  return ConsentManagerImpl(
    db: db,
    qwenService: qwen,
  );
});
