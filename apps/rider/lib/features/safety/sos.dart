import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class SosState {
  final bool isSosActive;
  final bool isDeliveryFrozen;

  const SosState({
    this.isSosActive = false,
    this.isDeliveryFrozen = false,
  });
}

class SosEngine extends StateNotifier<SosState> {
  SosEngine() : super(const SosState());

  void triggerSos() {
    print("SOS TRIGGERED! Broadcasting GPS. Freezing delivery.");
    // In a real implementation, this would:
    // 1. Send live GPS to Nexus Lead dashboard.
    // 2. Halt any active payment processing.
    // 3. Notify the user.
    state = const SosState(isSosActive: true, isDeliveryFrozen: true);
  }

  void resolveSos() {
    state = const SosState(isSosActive: false, isDeliveryFrozen: false);
  }
}

final sosProvider = StateNotifierProvider<SosEngine, SosState>((ref) {
  return SosEngine();
});

class SosButton extends ConsumerStatefulWidget {
  const SosButton({super.key});

  @override
  ConsumerState<SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends ConsumerState<SosButton> {
  Timer? _holdTimer;
  bool _isHolding = false;
  double _progress = 0.0;

  void _startHold() {
    setState(() {
      _isHolding = true;
      _progress = 0.0;
    });

    const tick = Duration(milliseconds: 30);
    int ticks = 0;
    _holdTimer = Timer.periodic(tick, (timer) {
      ticks++;
      setState(() {
        _progress = (ticks * 30) / 3000; // 3 seconds hold
      });

      if (_progress >= 1.0) {
        timer.cancel();
        ref.read(sosProvider.notifier).triggerSos();
        setState(() {
          _isHolding = false;
          _progress = 0.0;
        });
      }
    });
  }

  void _cancelHold() {
    _holdTimer?.cancel();
    setState(() {
      _isHolding = false;
      _progress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sosState = ref.watch(sosProvider);

    return GestureDetector(
      onTapDown: (_) => _startHold(),
      onTapUp: (_) => _cancelHold(),
      onTapCancel: () => _cancelHold(),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: sosState.isSosActive ? Colors.red : Colors.red[900],
          shape: BoxShape.circle,
          boxShadow: [
            if (sosState.isSosActive)
               const BoxShadow(color: Colors.redAccent, blurRadius: 20, spreadRadius: 5)
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_isHolding)
              CircularProgressIndicator(
                value: _progress,
                color: Colors.white,
                strokeWidth: 4,
              ),
            const Text(
              "SOS",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
