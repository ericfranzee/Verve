import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// Latency state wrapper
class FidelityState {
  final int latencyMs;
  final bool isLowFidelity;
  final bool isOffline;

  FidelityState({
    required this.latencyMs,
    required this.isLowFidelity,
    required this.isOffline,
  });
}

class AdaptiveFidelityEngine extends Notifier<FidelityState> {
  Timer? _pingTimer;

  @override
  FidelityState build() {
    _startMonitoring();
    return FidelityState(latencyMs: 0, isLowFidelity: false, isOffline: false);
  }

  void _startMonitoring() {
    _pingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final stopWatch = Stopwatch()..start();
      try {
        // P2-T12: Network monitoring background logic (simplified using Timer instead of full isolate for web compat)
        final response = await http.get(Uri.parse('https://8.8.8.8')).timeout(const Duration(seconds: 3));
        stopWatch.stop();

        final latency = stopWatch.elapsedMilliseconds;

        // P2-T13: Adaptive Fidelity Engine triggers low-fi >400ms
        final isLowFi = latency > 400;

        state = FidelityState(
          latencyMs: latency,
          isLowFidelity: isLowFi,
          isOffline: response.statusCode != 200,
        );

      } catch (e) {
        state = FidelityState(latencyMs: -1, isLowFidelity: true, isOffline: true);
      }
    });
  }

  // Used for testing thresholds manually
  void simulateLatency(int ms) {
    state = FidelityState(
      latencyMs: ms,
      isLowFidelity: ms > 400,
      isOffline: ms < 0,
    );
  }

  void dispose() {
    _pingTimer?.cancel();
  }
}

final fidelityProvider = NotifierProvider<AdaptiveFidelityEngine, FidelityState>(() {
  return AdaptiveFidelityEngine();
});
