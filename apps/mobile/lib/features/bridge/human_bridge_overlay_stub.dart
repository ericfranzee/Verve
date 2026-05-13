import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/verve_theme.dart';

// Notifier for overlay state (e.g., whether it's recording)
class HumanBridgeNotifier extends Notifier<bool> {
  @override
  bool build() => false; // false = not recording, true = recording

  void toggleRecording() {
    state = !state;
  }
}

final humanBridgeProvider = NotifierProvider<HumanBridgeNotifier, bool>(() => HumanBridgeNotifier());

class HumanBridgeOverlay extends ConsumerWidget {
  const HumanBridgeOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRecording = ref.watch(humanBridgeProvider);

    return Container(
      decoration: BoxDecoration(
        color: VerveTokens.backgroundBlack,
        border: Border.all(color: VerveTokens.nexusAmber, width: 2), // Glowing border shift
        boxShadow: [
          BoxShadow(
            color: VerveTokens.nexusAmber.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Keep it as an overlay/bottom sheet style
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              _buildChatArea(context),
              const SizedBox(height: 32),
              _buildInputArea(context, ref, isRecording),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
            border: Border.all(color: VerveTokens.nexusAmber, width: 2),
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 30), // Placeholder for portrait
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "CONNECTED TO NEXUS LEAD",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VerveTokens.nexusAmber, fontSize: 10, letterSpacing: 1.5),
              ),
              const SizedBox(height: 4),
              Text(
                "CHUKS (LEKKI HUB)",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white54),
          onPressed: () {
            // Close logic placeholder
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Closing Human Bridge...")),
            );
          },
        ),
      ],
    );
  }

  Widget _buildChatArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chuks: \"Hello, I noticed Aura had trouble mapping your delivery location. Can you confirm if you're near the Lekki Toll Gate?\"",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, WidgetRef ref, bool isRecording) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTapDown: (_) => ref.read(humanBridgeProvider.notifier).toggleRecording(),
          onTapUp: (_) => ref.read(humanBridgeProvider.notifier).toggleRecording(),
          onTapCancel: () => ref.read(humanBridgeProvider.notifier).toggleRecording(),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isRecording ? Colors.red : VerveTokens.nexusAmber,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isRecording ? Icons.mic : Icons.mic_none,
              color: isRecording ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
