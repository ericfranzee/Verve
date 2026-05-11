import 'package:flutter/material.dart';
import '../../../core/theme/verve_theme.dart';

class ProposalCard extends StatelessWidget {
  final String title;
  final List<String> items;

  const ProposalCard({
    super.key,
    required this.title,
    this.items = const ["Item 1", "Item 2", "Item 3"],
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Background Card (Z-index layering simulation)
          Positioned(
            top: -20,
            child: Container(
              width: 280,
              height: 400,
              decoration: BoxDecoration(
                color: VerveTokens.nexusAmber.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: VerveTokens.nexusAmber.withValues(alpha: 0.2)),
              ),
            ),
          ),

          // Foreground Card
          Container(
            width: 320,
            height: 420,
            decoration: BoxDecoration(
              color: VerveTokens.backgroundBlack,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: VerveTokens.nexusAmber.withValues(alpha: 0.6)),
              boxShadow: [
                BoxShadow(
                  color: VerveTokens.nexusAmber.withValues(alpha: 0.15),
                  blurRadius: 30,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: VerveTokens.nexusAmber),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 32),
                  ...items.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline, color: VerveTokens.vitalEmerald, size: 20),
                        const SizedBox(width: 12),
                        Text(item, style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  )),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: VerveTokens.nexusAmber,
                        foregroundColor: VerveTokens.backgroundBlack,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        // Dispatch/Confirm action
                      },
                      child: const Text("PROVISION NOW", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
