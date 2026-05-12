import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/verve_theme.dart';

// Stub provider for Depleting Items
final depletingItemsProvider = Provider<Map<String, List<Map<String, dynamic>>>>((ref) {
  return {
    "DEPLETING: NEXT 48 HOURS": [
      {"name": "Fresh Plantains", "subtitle": "Aura estimate: 10% remaining", "icon": Icons.eco_outlined},
      {"name": "Evaporated Milk", "subtitle": "Aura estimate: 15% remaining", "icon": Icons.local_drink_outlined},
    ],
    "DEPLETING: THIS WEEK": [
      {"name": "Eggs (Dozen)", "subtitle": "Aura estimate: 30% remaining", "icon": Icons.egg_outlined},
      {"name": "Brown Beans", "subtitle": "Aura estimate: 40% remaining", "icon": Icons.grain_outlined},
    ],
    "POPULAR IN YOUR AREA": [
      {"name": "Detergent", "subtitle": "Frequently ordered in your hub", "icon": Icons.clean_hands_outlined},
    ]
  };
});

class PredictivePantryScreen extends ConsumerWidget {
  const PredictivePantryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final depletingData = ref.watch(depletingItemsProvider);

    return Scaffold(
      backgroundColor: VerveTokens.backgroundBlack,
      appBar: AppBar(
        title: const Text("Predictive Pantry"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildInfoBanner(context),
          const SizedBox(height: 32),
          ...depletingData.entries.map((entry) => Column(
            children: [
              _buildDepletionHorizon(context, entry.key, entry.value),
              const SizedBox(height: 32),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VerveTokens.listeningCyan.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VerveTokens.listeningCyan.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: VerveTokens.listeningCyan),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Based on your consumption vectors. Long press any item to train Aura.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VerveTokens.listeningCyan),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepletionHorizon(BuildContext context, String header, List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white54, letterSpacing: 1.2),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => _buildPantryItem(context, item['name'], item['subtitle'], item['icon'])),
      ],
    );
  }

  Widget _buildPantryItem(BuildContext context, String name, String subtitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        tileColor: Colors.white.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon, color: Colors.white70),
        title: Text(name, style: const TextStyle(color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54)),
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart, color: VerveTokens.auraTeal),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Added $name to draft basket.")),
            );
          },
        ),
        onLongPress: () {
          _showTrainContextMenu(context, name);
        },
      ),
    );
  }

  void _showTrainContextMenu(BuildContext context, String itemName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: VerveTokens.backgroundBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Train Aura on $itemName",
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 18),
                ),
              ),
              const Divider(color: Colors.white24),
              ListTile(
                leading: const Icon(Icons.check_circle_outline, color: VerveTokens.vitalEmerald),
                title: const Text("I have plenty", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Aura learned you have enough $itemName.")),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel_outlined, color: Colors.redAccent),
                title: const Text("I don't buy this anymore", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Aura will stop predicting $itemName.")),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
