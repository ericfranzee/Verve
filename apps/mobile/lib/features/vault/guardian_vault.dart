import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/verve_theme.dart';
import '../memory/memory_manager.dart';
import '../../main.dart'; // To access providers

// Assuming Trust Level is globally available, we stub it here for UI purposes
final trustLevelProvider = StateProvider<int>((ref) => 1);

class GuardianVaultScreen extends ConsumerWidget {
  const GuardianVaultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trustLevel = ref.watch(trustLevelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Guardian Vault"),
        backgroundColor: VerveTokens.backgroundBlack,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildTrustLadderHeader(context, trustLevel),
          const SizedBox(height: 40),
          _buildDataAccessBreakdown(context, trustLevel),
          const SizedBox(height: 60),
          _buildPurgeButton(context, ref),
        ],
      ),
    );
  }

  Widget _buildTrustLadderHeader(BuildContext context, int trustLevel) {
    String title = "Stranger";
    String desc = "Aura knows nothing personal.";
    if (trustLevel == 1) {
      title = "Acquaintance";
      desc = "Aura remembers recent orders and basic preferences.";
    } else if (trustLevel == 2) {
      title = "Confidant";
      desc = "Aura tracks dietary profile, household size, and depletion models.";
    } else if (trustLevel >= 3) {
      title = "Partner";
      desc = "Full context: Auto-provisioning and bio-handshake active.";
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: VerveTokens.vitalEmerald.withValues(alpha: 0.1),
        border: Border.all(color: VerveTokens.vitalEmerald.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("CURRENT TRUST LEVEL", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VerveTokens.vitalEmerald)),
          const SizedBox(height: 8),
          Text("Level $trustLevel: $title", style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24)),
          const SizedBox(height: 8),
          Text(desc, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildDataAccessBreakdown(BuildContext context, int trustLevel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("WHAT AURA KNOWS", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white54)),
        const SizedBox(height: 16),
        _buildDataRow(context, "Local Fulfillment Data", Icons.location_city, true),
        _buildDataRow(context, "Order History", Icons.receipt_long, trustLevel >= 1),
        _buildDataRow(context, "Dietary Restrictions", Icons.restaurant_menu, trustLevel >= 2),
        _buildDataRow(context, "Biometric Handshake", Icons.fingerprint, trustLevel >= 3),
      ],
    );
  }

  Widget _buildDataRow(BuildContext context, String label, IconData icon, bool hasAccess) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: hasAccess ? VerveTokens.listeningCyan : Colors.white24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: hasAccess ? Colors.white : Colors.white24,
                decoration: hasAccess ? null : TextDecoration.lineThrough,
              ),
            ),
          ),
          Icon(
            hasAccess ? Icons.check : Icons.lock_outline,
            color: hasAccess ? VerveTokens.vitalEmerald : Colors.white24,
            size: 20,
          )
        ],
      ),
    );
  }

  Widget _buildPurgeButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.delete_forever),
      label: const Text("PURGE ALL MEMORIES"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade900.withValues(alpha: 0.2),
        foregroundColor: Colors.red.shade300,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.red.shade900),
        ),
      ),
      onPressed: () async {
        final manager = ref.read(memoryManagerProvider);
        await manager.purgeProtocol();
        ref.read(trustLevelProvider.notifier).state = 0;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Guardian Purge Protocol Complete.")),
        );
      },
    );
  }
}
