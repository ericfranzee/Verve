import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/verve_theme.dart';
import 'verve_plus_manager.dart';

class VervePlusCard extends ConsumerWidget {
  const VervePlusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shouldNudge = ref.watch(vervePlusNudgeProvider);

    if (!shouldNudge) return const SizedBox.shrink();

    return Card(
      color: VerveTokens.vitalEmerald.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: VerveTokens.vitalEmerald.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: VerveTokens.vitalEmerald),
                const SizedBox(width: 8),
                Text(
                  "Verve+ Natural Nudge",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: VerveTokens.vitalEmerald,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "You've ordered 5 times this month. Verve+ would have saved you ₦3,200.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: VerveTokens.vitalEmerald,
                foregroundColor: VerveTokens.backgroundBlack,
              ),
              onPressed: () {},
              child: const Text("UPGRADE TO VERVE+ (₦4,999/mo)"),
            ),
          ],
        ),
      ),
    );
  }
}
