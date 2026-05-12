import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class HapticFeedbackSystem {
  static Future<void> playWake() async {
    final canVibrate = await Vibrate.canVibrate;
    if (canVibrate) {
      Vibrate.feedback(FeedbackType.impact);
    }
  }

  static Future<void> playSynapseTransition() async {
    final canVibrate = await Vibrate.canVibrate;
    if (canVibrate) {
      Vibrate.feedback(FeedbackType.selection);
    }
  }

  static Future<void> playConfirmation() async {
    final canVibrate = await Vibrate.canVibrate;
    if (canVibrate) {
      Vibrate.feedback(FeedbackType.success);
    }
  }

  static Future<void> playError() async {
    final canVibrate = await Vibrate.canVibrate;
    if (canVibrate) {
      Vibrate.feedback(FeedbackType.error);
    }
  }
}
