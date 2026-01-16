import 'dart:io';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'battery_guard_service.dart';
import 'model_preloader_service.dart';

final qwenServiceProvider = Provider<QwenService>((ref) {
  return QwenService(
    ref.watch(batteryGuardServiceProvider),
    ref.watch(modelPreloaderServiceProvider),
  );
});

/// Reusable service for on-device Qwen 2.5 0.5B Instruct inference
/// Provides instant AI responses (<250ms) for speed-critical operations
/// while reserving Claude for deep theological analysis.
/// 
/// Features:
/// - Battery-aware initialization (blocks when <15%)
/// - Auto-disposes after 60 seconds of inactivity
/// - Shared model instance across all callers
/// - Graceful fallback on unsupported platforms (simulators)
class QwenService {
  final BatteryGuardService _batteryGuard;
  final ModelPreloaderService _preloader;
  dynamic _model; // GemmaModel type from flutter_gemma
  DateTime? _lastActivity;
  bool _isInitialized = false;
  bool _isInitializing = false;
  bool _platformUnsupported = false; // Tracks if platform doesn't support on-device AI
  
  // Request queue to prevent concurrent calls
  bool _isProcessing = false;
  final List<_QwenRequest> _requestQueue = [];

  QwenService(this._batteryGuard, this._preloader);

  /// Initialize the Qwen 2.5 0.5B model
  /// Only called when app is in foreground and battery allows
  Future<void> _ensureInitialized() async {
    // Skip if platform is known to be unsupported (e.g., simulator)
    if (_platformUnsupported) {
      throw QwenException(
        'On-device AI not available on this platform',
        QwenErrorType.platformUnsupported,
      );
    }
    
    if (_isInitialized && _model != null) {
      _lastActivity = DateTime.now();
      return;
    }

    // Prevent double initialization
    if (_isInitializing) {
      // Wait for existing initialization to complete
      while (_isInitializing) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      if (_isInitialized && _model != null) {
        _lastActivity = DateTime.now();
        return;
      }
      // Check if platform was marked unsupported during initialization
      if (_platformUnsupported) {
        throw QwenException(
          'On-device AI not available on this platform',
          QwenErrorType.platformUnsupported,
        );
      }
    }

    _isInitializing = true;
    final initStopwatch = Stopwatch()..start();

    try {
      // Battery guard: Don't initialize if battery is low
      if (await _batteryGuard.shouldThrottle()) {
        throw QwenException(
          'Battery too low for on-device AI. Connect charger or enable Claude-only mode.',
          QwenErrorType.batteryLow,
        );
      }

      // 1. Ensure model is preloaded to docs dir
      print('🔄 [INIT] Step 1: Preloading model file...');
      final preloadStopwatch = Stopwatch()..start();
      final modelPath = await _preloader.preloadModel();
      print('🔄 [INIT] Preload time: ${preloadStopwatch.elapsedMilliseconds}ms');
      
      // 2. Install model into flutter_gemma registry
      print('🔄 [INIT] Step 2: Installing into flutter_gemma registry...');
      final installStopwatch = Stopwatch()..start();
      await FlutterGemma.installModel(
        modelType: ModelType.qwen,
      ).fromFile(modelPath).install();
      print('🔄 [INIT] Install time: ${installStopwatch.elapsedMilliseconds}ms');
      
      // 3. Get active model instance
      print('🔄 [INIT] Step 3: Getting active model instance...');
      final modelStopwatch = Stopwatch()..start();
      
      // Reduce context window to 512 tokens to save RAM (user reported OOM)
      // UPDATE: Qwen 0.5B is small enough to handle 2048 tokens safely
      _model = await FlutterGemma.getActiveModel(
        maxTokens: 2048, 
        preferredBackend: PreferredBackend.cpu,
      );
      print('🔄 [INIT] Model creation time: ${modelStopwatch.elapsedMilliseconds}ms');
      
      _isInitialized = true;
      _lastActivity = DateTime.now();
      
      // Start inactivity timer
      _startInactivityTimer();
      
      initStopwatch.stop();
      print('✅ QwenService initialized successfully in ${initStopwatch.elapsedMilliseconds}ms total');
    } catch (e) {
      print('❌ Error initializing Qwen model: $e');
      
      final errorString = e.toString();
      
      // Check for OOM / Memory errors
      if (errorString.contains('Cannot allocate memory') || errorString.contains('memory_mapped_file')) {
         print('⚠️ Device out of memory. Marking platform as unsupported for Qwen.');
         _platformUnsupported = true;
         throw QwenException(
          'Device does not have enough free RAM for on-device AI. Falling back to Cloud.',
          QwenErrorType.platformUnsupported,
        );
      }
      
      // Check for corruption errors (common if model file is bad)
      if (errorString.contains('Unable to open zip archive') || 
          errorString.contains('flatbuffer') || 
          errorString.contains('format')) {
        print('⚠️ Model file appears corrupted. Forcing re-download...');
        try {
          // Force reload the model
          final newPath = await _preloader.preloadModel(force: true);
          
          // Try installing one more time
          await FlutterGemma.installModel(
            modelType: ModelType.qwen,
          ).fromFile(newPath).install();
          
          _model = await FlutterGemma.getActiveModel(
            maxTokens: 2000, 
            preferredBackend: PreferredBackend.cpu,
          );
          
          _isInitialized = true;
          _lastActivity = DateTime.now();
          _startInactivityTimer();
          return; // Success on retry!
        } catch (retryError) {
          print('❌ Retry failed: $retryError');
          // Fall through to standard error handling
        }
      }

      // Check for platform channel errors (common on simulators)
      if (errorString.contains('PlatformException') || 
          errorString.contains('channel-error') ||
          errorString.contains('Unable to establish connection')) {
        _platformUnsupported = true;
        print('⚠️ On-device AI not supported on this platform (simulator?). Falling back to Claude.');
        throw QwenException(
          'On-device AI not available on this platform (try a physical device)',
          QwenErrorType.platformUnsupported,
        );
      }
      
      if (e is QwenException) rethrow;
      throw QwenException(
        'Failed to load on-device AI model: $e',
        QwenErrorType.initFailed,
      );
    } finally {
      _isInitializing = false;
    }
  }

  /// Dispose model after 60 seconds of inactivity
  void _startInactivityTimer() {
    Future.delayed(const Duration(seconds: 60), () {
      if (_lastActivity != null) {
        final inactiveDuration = DateTime.now().difference(_lastActivity!);
        if (inactiveDuration.inSeconds >= 60) {
          _disposeModel();
        } else {
          // Restart timer if there was recent activity
          _startInactivityTimer();
        }
      }
    });
  }
  /// Translates a list of sentiment scores into a Spline State ID
  /// State IDs: "Peaceful", "Jagged", "Radiant"
  Future<String> getGeometryState(List<double> scores) async {
    final average = scores.isEmpty ? 0.0 : scores.reduce((a, b) => a + b) / scores.length;
    
    final prompt = '''Map this spiritual sentiment average score ($average) to a visual state.
    Range: 1.0 (Struggling) to 3.0 (Peaceful/Radiant)
    
    Return ONLY one of these exact words:
    - Peaceful (if score is ~2.0)
    - Jagged (if score is < 1.5)
    - Radiant (if score is > 2.5)
    
    State:''';

    try {
      final response = await generate(prompt, maxTokens: 10, temperature: 0.1);
      if (response.contains('Radiant')) return 'Radiant';
      if (response.contains('Jagged')) return 'Jagged';
      return 'Peaceful';
    } catch (e) {
      return 'Peaceful';
    }
  }

  /// Summarizes weekly journey history into a 15-word "Story Ribbon"
  Future<String> getJourneySummary(List<String> entries) async {
    if (entries.isEmpty) return 'Begin your journey with a reflection.';
    
    final content = entries.take(5).join('\n---\n');
    final prompt = '''Summarize these spiritual journal entries into a 15-word poetic "Story Ribbon".
    Example: "From a valley of doubt to a hilltop of grace"
    
    Entries:
    $content
    
    Poetic Summary (max 15 words):''';

    try {
      return await generate(prompt, maxTokens: 30, temperature: 0.7);
    } catch (e) {
      return 'Walking with God through every season.';
    }
  }


  /// Generate a response for the given prompt
  /// Returns response text or throws QwenException on error
  /// 
  /// Uses a request queue to prevent concurrent calls (Qwen only supports 1 request at a time)
  /// [prompt] - The input prompt
  /// [maxTokens] - Maximum tokens to generate (default: 100)
  /// [temperature] - Creativity level 0.0-1.0 (default: 0.7)
  Future<String> generate(
    String prompt, {
    int maxTokens = 100,
    double temperature = 0.7,
  }) async {
    // Fast fail if platform is known to be unsupported
    if (_platformUnsupported) {
      throw QwenException(
        'On-device AI not available on this platform',
        QwenErrorType.platformUnsupported,
      );
    }
    
    // Create a request and add to queue
    final request = _QwenRequest(prompt, maxTokens, temperature);
    _requestQueue.add(request);
    
    // If not currently processing, start the queue
    if (!_isProcessing) {
      _processQueue();
    }
    
    // Wait for this request's result
    return await request.completer.future;
  }
  
  /// Process queued requests one at a time
  Future<void> _processQueue() async {
    if (_isProcessing || _requestQueue.isEmpty) return;
    
    _isProcessing = true;
    
    while (_requestQueue.isNotEmpty) {
      final request = _requestQueue.removeAt(0);
      
      try {
        final result = await _generateInternal(
          request.prompt,
          maxTokens: request.maxTokens,
          temperature: request.temperature,
        );
        request.completer.complete(result);
      } catch (e) {
        request.completer.completeError(e);
      }
      
      // Small delay between requests to ensure clean state
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    _isProcessing = false;
  }
  
  /// Internal generation method (called by queue processor)
  Future<String> _generateInternal(
    String prompt, {
    required int maxTokens,
    required double temperature,
  }) async {
    await _ensureInitialized();

    try {
      final startTime = DateTime.now();
      
      // Revert to Chat API but force disposal to clear state
      final chat = await _model!.createChat();
      
      await chat.addQueryChunk(Message.text(
        text: prompt,
        isUser: true,
      ));
      
      final response = await chat.generateChatResponse();
      
      // CRITICAL: Dispose model immediately to force fresh state for next request
      // This prevents the \"repetition bug\" where it remembers previous verses
      await _disposeModel();
      
      final duration = DateTime.now().difference(startTime);
      print('⚡ Qwen response generated in ${duration.inMilliseconds}ms');
      
      // Extract clean text from TextResponse wrapper
      String responseText = response.toString().trim();
      
      // Remove TextResponse wrapper if present
      if (responseText.startsWith('TextResponse(\"') && responseText.endsWith('\")')) {
        responseText = responseText.substring(14, responseText.length - 2);
      }
      
      // Remove common prefixes
      responseText = responseText
          .replaceFirst(RegExp(r'^Lesson:\s*', caseSensitive: false), '')
          .replaceFirst(RegExp(r'^Insight:\s*', caseSensitive: false), '')
          .replaceFirst(RegExp(r'^Takeaway:\s*', caseSensitive: false), '')
          .trim();
      
      print('✅ Qwen preview (cleaned): $responseText');
      
      return responseText;
    } catch (e) {
      print('❌ Error generating Qwen response: $e');
      
      // Reset the model instance to recover from session corruption
      await _disposeModel();
      
      throw QwenException(
        'On-device AI generation failed: $e',
        QwenErrorType.generationFailed,
      );
    }
  }

  /// Stream generation for progressive reveal (optional)
  /// Note: flutter_gemma doesn't support streaming, so this yields the full response at once
  Stream<String> generateStream(
    String prompt, {
    int maxTokens = 100,
  }) async* {
    // Fast fail if platform is known to be unsupported
    if (_platformUnsupported) {
      yield 'Error: On-device AI not available on this platform';
      return;
    }
    
    // Use the non-streaming generate method and yield the result
    try {
      final result = await generate(prompt, maxTokens: maxTokens);
      yield result;
    } catch (e) {
      print('❌ Error streaming Qwen response: $e');
      yield 'Error: Unable to generate response';
    }
  }

  /// Check if the model is currently loaded and ready
  bool get isLoaded => _isInitialized && _model != null;

  /// Check if initialization is safe (battery permits and platform supports)
  Future<bool> canInitialize() async {
    // Skip if platform is known to be unsupported
    if (_platformUnsupported) {
      print('⚠️ Qwen Check: Platform marked as unsupported.');
      return false;
    }
    final throttle = await _batteryGuard.shouldThrottle();
    if (throttle) {
      print('⚠️ Qwen Check: Battery Guard requested throttle.');
    }
    return !throttle;
  }
  
  /// Force reset the model instance (useful after crashes)
  Future<void> resetModel() async {
    print('🔄 Forcing Qwen model reset...');
    await _disposeModel();
  }

  /// Dispose the model to free RAM
  Future<void> _disposeModel() async {
    if (_model != null) {
      await _model!.close();
      _model = null;
      _isInitialized = false;
      _lastActivity = null;
      print('🔄 QwenService disposed after 60s inactivity');
    }
  }

  /// Manual disposal (for app lifecycle events)
  Future<void> dispose() async {
    await _disposeModel();
  }
}

/// Exception types for Qwen operations
enum QwenErrorType {
  batteryLow,
  initFailed,
  generationFailed,
  modelNotFound,
  platformUnsupported, // iOS Simulator, unsupported devices
}

/// Custom exception for Qwen-related errors
class QwenException implements Exception {
  final String message;
  final QwenErrorType type;

  QwenException(this.message, this.type);

  @override
  String toString() => 'QwenException: $message (type: $type)';
}

/// Internal request wrapper for queueing
class _QwenRequest {
  final String prompt;
  final int maxTokens;
  final double temperature;
  final Completer<String> completer = Completer<String>();

  _QwenRequest(this.prompt, this.maxTokens, this.temperature);
}
