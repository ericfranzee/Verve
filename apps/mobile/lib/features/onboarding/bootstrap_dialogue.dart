import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/verve_theme.dart';
import '../aura/breathing_wave_widget.dart';

class BootstrapDialogue extends ConsumerStatefulWidget {
  const BootstrapDialogue({super.key});

  @override
  ConsumerState<BootstrapDialogue> createState() => _BootstrapDialogueState();
}

class _BootstrapDialogueState extends ConsumerState<BootstrapDialogue> {
  int _stepIndex = 0;

  final List<String> _dialogueSteps = [
    "Welcome to Verve. I'm Aura. Before I can provision your life, I need to understand it.",
    "Quick question — how many people eat in your household?",
    "Got it. Any specific dietary restrictions or allergies I should know about?",
    "Perfect. I'm generating your Neighborhood Starter Basket based on your local MFC now.",
  ];

  void _nextStep() {
    setState(() {
      if (_stepIndex < _dialogueSteps.length - 1) {
        _stepIndex++;
      } else {
        // Transition to main UI (P2-T16 Starter Basket representation)
        // Usually dispatched through ViewportNotifier
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VerveTokens.backgroundBlack,
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: Padding(
                  key: ValueKey(_stepIndex),
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    _dialogueSteps[_stepIndex],
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 26, height: 1.4),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: GestureDetector(
              onTap: _nextStep,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const BreathingWaveWidget(
                    waveColor: VerveTokens.listeningCyan,
                    intensity: 0.8,
                  ),
                  Positioned(
                    bottom: 40,
                    child: Text(
                      "[ Tap to simulate user speaking ]",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white54),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
