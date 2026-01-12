import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final modelPreloaderServiceProvider = Provider<ModelPreloaderService>((ref) {
  return ModelPreloaderService();
});

class ModelPreloaderService {
  static const String _assetPath = 'assets/models/qwen_intent.task';
  static const String _targetFileName = 'qwen_intent.task';

  /// Copies the model from assets to the application documents directory
  /// Returns the absolute path to the copied file
  Future<String> preloadModel({bool force = false}) async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final targetFile = File('${docsDir.path}/$_targetFileName');

      // Check if model already exists to avoid redundant copying
      // For very large files (3GB+), we MUST NOT re-copy if it exists
      if (await targetFile.exists()) {
        final size = await targetFile.length();
        if (!force && size > 100 * 1024 * 1024) { // If > 100MB, assume it is the model
          print('✅ Large model file already exists (${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB). Skipping copy to prevent OOM.');
          return targetFile.path;
        }
      }

      print('Preloading model from assets (Warning: Files > 1GB may cause OOM)...');
      
      // Read from assets
      // NOTE: rootBundle.load() reads entire file into memory. 
      // For 3GB files, this WILL CRASH on some devices.
      final byteData = await rootBundle.load(_assetPath);
      
      // Write to file
      await targetFile.writeAsBytes(
        byteData.buffer.asUint8List(
          byteData.offsetInBytes, 
          byteData.lengthInBytes
        ),
        mode: FileMode.writeOnly,
        flush: true,
      );

      print('✅ Model successfully preloaded to: ${targetFile.path}');
      return targetFile.path;
    } catch (e) {
      print('❌ Error preloading model: $e');
      if (e.toString().contains('Out of memory') || e.toString().contains('allocation')) {
        print('💡 TIP: The model file is too large (3GB+). Please use a quantized model (int4) to reduce size to < 1.5GB.');
      }
      throw Exception('Failed to preload Qwen model (Likely OOM): $e');
    }
  }

  /// Get the path where the model should be/is stored
  Future<String> getModelPath() async {
    final docsDir = await getApplicationDocumentsDirectory();
    return '${docsDir.path}/$_targetFileName';
  }
  
  /// Check if the model is ready
  Future<bool> isModelReady() async {
    final path = await getModelPath();
    return File(path).exists();
  }
}
