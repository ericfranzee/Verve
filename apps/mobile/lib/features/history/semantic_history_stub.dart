import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/verve_theme.dart';

// Stub provider for Semantic History
final semanticHistoryProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return [
    {
      "tag": "THE SUNDAY RESET",
      "date": "03 MAY 2026",
      "vitalityScore": 88,
      "cost": "₦42,500",
      "hub": "Wuse II Hub",
    },
    {
      "tag": "MID-WEEK TOP UP",
      "date": "29 APR 2026",
      "vitalityScore": 92,
      "cost": "₦18,200",
      "hub": "Wuse II Hub",
    },
    {
      "tag": "ENTERTAINING GUESTS",
      "date": "25 APR 2026",
      "vitalityScore": 75,
      "cost": "₦85,000",
      "hub": "Wuse II Hub",
    },
  ];
});

class SemanticHistoryScreen extends ConsumerWidget {
  const SemanticHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyEvents = ref.watch(semanticHistoryProvider);

    return Scaffold(
      backgroundColor: VerveTokens.backgroundBlack,
      appBar: AppBar(
        title: const Text("Semantic History"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24.0),
        itemCount: historyEvents.length,
        separatorBuilder: (context, index) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          final event = historyEvents[index];
          return _buildEventCard(
            context: context,
            tag: event['tag'] as String,
            date: event['date'] as String,
            vitalityScore: event['vitalityScore'] as int,
            cost: event['cost'] as String,
            hub: event['hub'] as String,
          );
        },
      ),
    );
  }

  Widget _buildEventCard({
    required BuildContext context,
    required String tag,
    required String date,
    required int vitalityScore,
    required String cost,
    required String hub,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "[ $tag ]",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: VerveTokens.listeningCyan,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      date,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white54),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatCol(context, "Vitality", "$vitalityScore/100", VerveTokens.vitalEmerald),
                    _buildStatCol(context, "Total", cost, Colors.white),
                    _buildStatCol(context, "Nexus", hub, Colors.white70),
                  ],
                ),
              ],
            ),
          ),
          _buildReProvisionButton(context, tag),
        ],
      ),
    );
  }

  Widget _buildStatCol(BuildContext context, String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 18, color: valueColor)),
      ],
    );
  }

  Widget _buildReProvisionButton(BuildContext context, String tag) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Prepared basket for $tag checkout.")),
        );
      },
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: VerveTokens.auraTeal.withValues(alpha: 0.15),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          border: Border(
            top: BorderSide(color: VerveTokens.auraTeal.withValues(alpha: 0.3)),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh, color: VerveTokens.auraTeal, size: 20),
            SizedBox(width: 8),
            Text(
              "RE-PROVISION",
              style: TextStyle(color: VerveTokens.auraTeal, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
