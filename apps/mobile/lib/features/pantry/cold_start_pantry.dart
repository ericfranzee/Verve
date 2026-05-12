import 'package:flutter/material.dart';
import '../../core/theme/verve_theme.dart';

class ColdStartPantryScreen extends StatelessWidget {
  const ColdStartPantryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // P2-T22: Cold Start Pantry ("Popular in Your Area" with personalization label).
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
          Container(
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
                    "Based on your hub. Aura will personalize this within 3 orders.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VerveTokens.listeningCyan),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildPantryItem(context, "Fresh Plantains", "Popular in area"),
          _buildPantryItem(context, "Evaporated Milk", "Popular in area"),
          _buildPantryItem(context, "Eggs (Dozen)", "Popular in area"),
        ],
      ),
    );
  }

  Widget _buildPantryItem(BuildContext context, String name, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        tileColor: Colors.white.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: const Icon(Icons.inventory_2_outlined, color: Colors.white70),
        title: Text(name, style: const TextStyle(color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54)),
        trailing: const Icon(Icons.add_shopping_cart, color: VerveTokens.auraTeal),
      ),
    );
  }
}
