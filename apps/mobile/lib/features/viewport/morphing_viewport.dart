import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/verve_theme.dart';

enum ViewportState { voidState, heroCard, proposal }

class ViewportNotifier extends Notifier<ViewportState> {
  @override
  ViewportState build() {
    return ViewportState.voidState;
  }

  void setViewportState(ViewportState newState) {
    state = newState;
  }
}

final viewportStateProvider = NotifierProvider<ViewportNotifier, ViewportState>(() {
  return ViewportNotifier();
});

class MorphingViewport extends ConsumerWidget {
  const MorphingViewport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(viewportStateProvider);

    return Column(
      children: [
        // Top 60%: Morphing Viewport
        Expanded(
          flex: 6,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildViewportContent(state),
          ),
        ),

        // Bottom 40%: Sentinel Zone (Breathing Wave placeholder)
        Expanded(
          flex: 4,
          child: Container(
            color: VerveTokens.backgroundBlack,
            child: const Center(
              child: Text(
                "[ Sentinel Zone / Breathing Wave Shader ]",
                style: TextStyle(color: VerveTokens.listeningCyan),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildViewportContent(ViewportState state) {
    switch (state) {
      case ViewportState.voidState:
        return Container(
          key: const ValueKey('void'),
          color: VerveTokens.backgroundBlack,
          child: const Center(
            child: Text(
              "Verve — The Void",
              style: TextStyle(color: VerveTokens.auraTeal, fontSize: 24),
            ),
          ),
        );
      case ViewportState.heroCard:
        return Container(
          key: const ValueKey('hero'),
          color: VerveTokens.backgroundBlack,
          child: Center(
            child: Card(
              color: VerveTokens.auraTeal.withValues(alpha: 0.2),
              child: const Padding(
                padding: EdgeInsets.all(32.0),
                child: Text("Hero Card (Product)", style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
            ),
          ),
        );
      case ViewportState.proposal:
        return Container(
          key: const ValueKey('proposal'),
          color: VerveTokens.backgroundBlack,
          child: Center(
            child: Card(
              color: VerveTokens.nexusAmber.withValues(alpha: 0.2),
              child: const Padding(
                padding: EdgeInsets.all(32.0),
                child: Text("Proposal (Bundle)", style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
            ),
          ),
        );
    }
  }
}
