import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewport/morphing_viewport.dart';

class SynapsePayload {
  final ViewportState uiState;
  final Map<String, dynamic> metadata;
  final int triggerMs;

  SynapsePayload({
    required this.uiState,
    required this.metadata,
    required this.triggerMs,
  });

  factory SynapsePayload.fromJson(Map<String, dynamic> json) {
    ViewportState parsedState = ViewportState.voidState;
    if (json['ui_state'] == 'heroCard') {
      parsedState = ViewportState.heroCard;
    } else if (json['ui_state'] == 'proposal') {
      parsedState = ViewportState.proposal;
    }

    return SynapsePayload(
      uiState: parsedState,
      metadata: json['metadata'] ?? {},
      triggerMs: json['trigger_ms'] ?? 0,
    );
  }
}

class AudioMetadataSyncListener {
  final Ref ref;
  Timer? _syncTimer;

  AudioMetadataSyncListener(this.ref);

  void handleSynapseResponse(SynapsePayload payload, {required int audioDurationMs}) {
    _syncTimer?.cancel();

    // Simulate playing audio and waiting for the exact timestamp to trigger the UI switch
    // A real implementation would link to the AudioPlayer's current position stream
    _syncTimer = Timer(Duration(milliseconds: payload.triggerMs), () {
      ref.read(viewportStateProvider.notifier).setViewportState(payload.uiState);
    });
  }

  void dispose() {
    _syncTimer?.cancel();
  }
}

final synapseListenerProvider = Provider<AudioMetadataSyncListener>((ref) {
  return AudioMetadataSyncListener(ref);
});
