import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class ShiftState {
  final bool isShiftActive;
  final Duration timeWorked;
  final bool isOnBreak;
  final Duration breakTimeRemaining;

  const ShiftState({
    required this.isShiftActive,
    required this.timeWorked,
    required this.isOnBreak,
    required this.breakTimeRemaining,
  });

  ShiftState copyWith({
    bool? isShiftActive,
    Duration? timeWorked,
    bool? isOnBreak,
    Duration? breakTimeRemaining,
  }) {
    return ShiftState(
      isShiftActive: isShiftActive ?? this.isShiftActive,
      timeWorked: timeWorked ?? this.timeWorked,
      isOnBreak: isOnBreak ?? this.isOnBreak,
      breakTimeRemaining: breakTimeRemaining ?? this.breakTimeRemaining,
    );
  }
}

class ShiftManagerEngine extends StateNotifier<ShiftState> {
  ShiftManagerEngine()
      : super(const ShiftState(
          isShiftActive: false,
          timeWorked: Duration.zero,
          isOnBreak: false,
          breakTimeRemaining: Duration.zero,
        ));

  Timer? _shiftTimer;
  Timer? _breakTimer;

  static const Duration maxShiftDuration = Duration(hours: 8);
  static const Duration breakRequirementThreshold = Duration(hours: 4);
  static const Duration mandatoryBreakDuration = Duration(minutes: 30);

  void startShift() {
    if (state.isShiftActive) return;

    state = state.copyWith(isShiftActive: true, timeWorked: Duration.zero);

    _shiftTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.isOnBreak) return;

      final newTimeWorked = state.timeWorked + const Duration(seconds: 1);

      // Enforce 8 hour max shift
      if (newTimeWorked >= maxShiftDuration) {
        endShift();
        return;
      }

      // Enforce 4 hour mandatory 30m break
      if (newTimeWorked >= breakRequirementThreshold && !state.isOnBreak) {
        _triggerMandatoryBreak();
        return;
      }

      state = state.copyWith(timeWorked: newTimeWorked);
    });
  }

  void _triggerMandatoryBreak() {
    state = state.copyWith(
      isOnBreak: true,
      breakTimeRemaining: mandatoryBreakDuration,
    );

    _breakTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final newBreakTime = state.breakTimeRemaining - const Duration(seconds: 1);

      if (newBreakTime.inSeconds <= 0) {
        _endBreak();
      } else {
        state = state.copyWith(breakTimeRemaining: newBreakTime);
      }
    });
  }

  void _endBreak() {
    _breakTimer?.cancel();
    state = state.copyWith(
      isOnBreak: false,
      breakTimeRemaining: Duration.zero,
    );
  }

  void endShift() {
    _shiftTimer?.cancel();
    _breakTimer?.cancel();
    state = const ShiftState(
      isShiftActive: false,
      timeWorked: Duration.zero,
      isOnBreak: false,
      breakTimeRemaining: Duration.zero,
    );
  }

  @override
  void dispose() {
    _shiftTimer?.cancel();
    _breakTimer?.cancel();
    super.dispose();
  }
}

final shiftManagerProvider = StateNotifierProvider<ShiftManagerEngine, ShiftState>((ref) {
  return ShiftManagerEngine();
});
