import 'package:flutter/services.dart';

/// P5-T01: Edge SLM Integrator
///
/// Interfaces with a local quantized ONNX/TFLite model (e.g., Llama 3 8B or Mistral 7B)
/// running directly on the mobile device via platform channels.
///
/// Provides fallback resolution for standard intents when network drops.
class EdgeSlmIntegrator {
  static const MethodChannel _channel = MethodChannel('com.verve.edge_ai/slm');

  bool _isModelLoaded = false;

  /// Initializes the local SLM. In a real scenario, this would load the TFLite/ONNX
  /// model files from assets into memory using native APIs.
  Future<void> initializeModel() async {
    try {
      final bool result = await _channel.invokeMethod('initializeModel');
      _isModelLoaded = result;
      print("EdgeSlmIntegrator: Initialization ${result ? 'successful' : 'failed'}.");
    } on PlatformException catch (e) {
      print("EdgeSlmIntegrator: Failed to initialize model: '${e.message}'.");
      _isModelLoaded = false; // Fallback to false
    }
  }

  /// Resolves an intent using the local SLM when network drops.
  /// Bypasses the cloud round-trip, offering zero-latency basic resolution.
  Future<Map<String, dynamic>> resolveIntent(String text) async {
    if (!_isModelLoaded) {
      throw Exception("Edge SLM not loaded. Ensure initializeModel() is called first.");
    }

    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('resolveIntent', {
        'text': text,
      });

      if (result == null) {
        return {
          'status': 'error',
          'message': 'Failed to resolve intent locally',
        };
      }

      // Cast Map<dynamic, dynamic> to Map<String, dynamic>
      return result.map((key, value) => MapEntry(key.toString(), value));
    } on PlatformException catch (e) {
      print("EdgeSlmIntegrator: Exception resolving intent: ${e.message}");
      return {
        'status': 'error',
        'message': e.message,
      };
    }
  }

  bool get isModelLoaded => _isModelLoaded;
}
