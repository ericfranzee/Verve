import 'package:flutter_riverpod/flutter_riverpod.dart';

enum EmotionalState {
  neutral,
  execution, // Fast, decisive routing
  discovery, // Browsing, conversational
  precision  // Corrective logic, pinpointing specifics
}

class EmotionalStateManager extends Notifier<EmotionalState> {
  @override
  EmotionalState build() => EmotionalState.neutral;

  void setState(EmotionalState newState) {
    state = newState;
  }
}

final emotionalStateProvider = NotifierProvider<EmotionalStateManager, EmotionalState>(() {
  return EmotionalStateManager();
});
