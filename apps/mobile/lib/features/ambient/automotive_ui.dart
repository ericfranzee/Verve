import 'package:flutter/services.dart';

/// P5-T05: Automotive UI
///
/// Interfaces with Apple CarPlay and Android Auto via platform channels.
/// Manages continuous voice listener state and safely captures commands while driving.
class AutomotiveUI {
  static const MethodChannel _channel = MethodChannel('com.verve.ambient/automotive');

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  /// Initializes the automotive interface and checks connection status.
  Future<void> initialize() async {
    try {
      final bool result = await _channel.invokeMethod('checkConnection');
      _isConnected = result;
      print("AutomotiveUI: Connection status: $_isConnected");
    } on PlatformException catch (e) {
      print("AutomotiveUI: Failed to initialize: ${e.message}");
      _isConnected = false;
    }
  }

  /// Activates continuous ambient listening mode for the cabin.
  Future<void> activateCabinListening() async {
    if (!_isConnected) {
      print("AutomotiveUI: Cannot activate listening, not connected to car.");
      return;
    }

    try {
      await _channel.invokeMethod('activateCabinListening');
      print("AutomotiveUI: Cabin listening activated.");
    } on PlatformException catch (e) {
      print("AutomotiveUI: Failed to activate cabin listening: ${e.message}");
    }
  }

  /// Deactivates continuous ambient listening mode.
  Future<void> deactivateCabinListening() async {
    try {
      await _channel.invokeMethod('deactivateCabinListening');
      print("AutomotiveUI: Cabin listening deactivated.");
    } on PlatformException catch (e) {
      print("AutomotiveUI: Failed to deactivate cabin listening: ${e.message}");
    }
  }

  /// Sets up a handler to receive voice intents from the automotive interface.
  void setVoiceIntentHandler(void Function(String intentText, double confidence) onIntent) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onVoiceIntent') {
        final args = call.arguments as Map<dynamic, dynamic>;
        final intentText = args['text'] as String;
        final confidence = args['confidence'] as double;
        onIntent(intentText, confidence);
      }
    });
  }
}
