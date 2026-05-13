import 'package:flutter/services.dart';

/// P5-T04: Wearable UI Companion
///
/// Interfaces with watchOS and WearOS extensions via platform channels.
/// Provides a basic intent interface allowing quick voice intents via smartwatches.
class WearableCompanion {
  static const MethodChannel _channel = MethodChannel('com.verve.ambient/wearable');

  /// Starts listening for voice intents from the wearable device.
  Future<void> startListening() async {
    try {
      await _channel.invokeMethod('startListening');
      print("WearableCompanion: Started listening for intents.");
    } on PlatformException catch (e) {
      print("WearableCompanion: Failed to start listening: ${e.message}");
    }
  }

  /// Stops listening for voice intents.
  Future<void> stopListening() async {
    try {
      await _channel.invokeMethod('stopListening');
      print("WearableCompanion: Stopped listening for intents.");
    } on PlatformException catch (e) {
      print("WearableCompanion: Failed to stop listening: ${e.message}");
    }
  }

  /// Registers a callback to receive resolved intents from the wearable.
  void setIntentCallback(void Function(String intent) onIntentReceived) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onIntentReceived') {
        final intent = call.arguments as String;
        onIntentReceived(intent);
      }
    });
  }
}
