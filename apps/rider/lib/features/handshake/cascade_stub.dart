import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

enum HandshakeLevel {
  level0Ble,     // Both devices BLE-capable, online (Full crypto verification)
  level1Visual,  // BLE unavailable. CV color pulse match.
  level2Otp,     // Screen/Camera failure. 6-digit OTP displayed on user screen, entered by rider.
  level3Callback // Rider calls hub, Nexus Lead verbally confirms order.
}

class HandshakeState {
  final HandshakeLevel currentLevel;
  final bool isComplete;
  final String? failureReason;

  const HandshakeState({
    required this.currentLevel,
    this.isComplete = false,
    this.failureReason,
  });

  HandshakeState copyWith({
    HandshakeLevel? currentLevel,
    bool? isComplete,
    String? failureReason,
  }) {
    return HandshakeState(
      currentLevel: currentLevel ?? this.currentLevel,
      isComplete: isComplete ?? this.isComplete,
      failureReason: failureReason ?? this.failureReason,
    );
  }
}

class BioHandshakeEngine extends StateNotifier<HandshakeState> {
  BioHandshakeEngine() : super(const HandshakeState(currentLevel: HandshakeLevel.level0Ble));

  Timer? _degradationTimer;

  void initiateHandshake() {
    state = const HandshakeState(currentLevel: HandshakeLevel.level0Ble);

    // Automatic fallback (P3-T16) - if Level 0 fails within 5s, downgrade to Level 1
    _degradationTimer = Timer(const Duration(seconds: 5), () {
      if (!state.isComplete && state.currentLevel == HandshakeLevel.level0Ble) {
         _degradeTo(HandshakeLevel.level1Visual, "BLE timeout after 5 seconds");

         // If Level 1 fails within 10s, downgrade to Level 2
         _degradationTimer = Timer(const Duration(seconds: 10), () {
           if (!state.isComplete && state.currentLevel == HandshakeLevel.level1Visual) {
             _degradeTo(HandshakeLevel.level2Otp, "Visual pulse match timeout after 10 seconds");
           }
         });
      }
    });
  }

  void _degradeTo(HandshakeLevel newLevel, String reason) {
    // Log the degraded handshake attempt here for audit trail
    print("Degraded Handshake: \$newLevel due to: \$reason");
    state = state.copyWith(currentLevel: newLevel, failureReason: reason);
  }

  void manualTriggerLevel3() {
    // Level 3 must be manually triggered by the rider
    _degradationTimer?.cancel();
    _degradeTo(HandshakeLevel.level3Callback, "Manually triggered hub callback fallback");
  }

  void completeHandshake() {
    _degradationTimer?.cancel();
    state = state.copyWith(isComplete: true);
    print("Handshake Completed at level: \${state.currentLevel}");
  }

  @override
  void dispose() {
    _degradationTimer?.cancel();
    super.dispose();
  }
}

final bioHandshakeProvider = StateNotifierProvider<BioHandshakeEngine, HandshakeState>((ref) {
  return BioHandshakeEngine();
});
