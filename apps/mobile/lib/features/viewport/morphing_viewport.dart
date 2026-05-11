import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/verve_theme.dart';
import 'widgets/hero_card.dart';
import 'widgets/proposal_card.dart';
import '../fidelity/adaptive_fidelity_engine.dart';

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
    final fidelityState = ref.watch(fidelityProvider);

    return Stack(
      children: [
        Column(
          children: [
            // Top 60%: Morphing Viewport
            Expanded(
              flex: 6,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _buildViewportContent(state, fidelityState.isLowFidelity),
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
        ),

        // P2-T19: Connection-degraded UI states Overlay
        if (fidelityState.isOffline)
          Container(
            color: Colors.black54,
            child: const Center(
              child: Text(
                "Aura is offline.",
                style: TextStyle(color: VerveTokens.nexusAmber, fontSize: 18),
              ),
            ),
          )
        else if (fidelityState.isLowFidelity)
          Positioned(
            top: 40,
            right: 20,
            child: Row(
              children: [
                const Icon(Icons.wifi_tethering_error_rounded, color: VerveTokens.nexusAmber, size: 16),
                const SizedBox(width: 8),
                Text("Aura is thinking...", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VerveTokens.nexusAmber)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildViewportContent(ViewportState state, bool isLowFidelity) {
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
        return HeroCard(
          key: const ValueKey('hero'),
          title: "Provisioning Initialized",
          isLowFidelity: isLowFidelity, // Pass down to disable parallax
        );
      case ViewportState.proposal:
        return ProposalCard(
          key: const ValueKey('proposal'),
          title: "Neighborhood Starter Bundle",
          isLowFidelity: isLowFidelity, // Pass down to flatten stack
        );
    }
  }
}
