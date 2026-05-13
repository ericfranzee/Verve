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
      // P5-T16: Anti-tamper verification. Ensures the quantized weights haven't
      // been extracted or replaced by a malicious actor before loading.
      final bool isIntact = await _verifyModelIntegrity();
      if (!isIntact) {
         throw Exception("Model integrity check failed. Halting AI operations.");
      }

      final bool result = await _channel.invokeMethod('initializeModel');
      _isModelLoaded = result;
      print("EdgeSlmIntegrator: Initialization ${result ? 'successful' : 'failed'}.");
    } catch (e) {
      print("EdgeSlmIntegrator: Failed to initialize model: '$e'.");
      _isModelLoaded = false; // Fallback to false
    }
  }

  Future<bool> _verifyModelIntegrity() async {
    try {
       // Calls native Android Play Integrity API / iOS DeviceCheck
       final bool isSafe = await _channel.invokeMethod('performAttestation');
       return isSafe;
    } on PlatformException {
       return false; // Fail safe
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
