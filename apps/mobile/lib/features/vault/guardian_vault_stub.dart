import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/verve_theme.dart';
import '../../main.dart'; // To access providers

class TrustLevelNotifier extends Notifier<int> {
  @override
  int build() => 1;
}

// Assuming Trust Level is globally available, we stub it here for UI purposes
final trustLevelProvider = NotifierProvider<TrustLevelNotifier, int>(() => TrustLevelNotifier());

class LedgerNotifier extends Notifier<List<Map<String, String>>> {
  @override
  List<Map<String, String>> build() => [
    {
      "timestamp": "08-MAY-26 14:20",
      "category": "DIETARY",
      "context": "Prefers Plantain over Yam"
    },
    {
      "timestamp": "09-MAY-26 08:15",
      "category": "ROUTINE",
      "context": "Orders Milk every 5 days"
    },
    {
      "timestamp": "10-MAY-26 19:30",
      "category": "PREFERENCE",
      "context": "Requests low-sodium options"
    }
  ];

  void removeAt(int index) {
    final newState = List<Map<String, String>>.from(state);
    newState.removeAt(index);
    state = newState;
  }

  void clear() {
    state = [];
  }
}

// Stub for intimate ledger items
final ledgerProvider = NotifierProvider<LedgerNotifier, List<Map<String, String>>>(() => LedgerNotifier());

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
          const SizedBox(height: 32),
          _buildIdentityBlock(context),
          const SizedBox(height: 32),
          _buildDataAccessBreakdown(context, trustLevel),
          const SizedBox(height: 32),
          _buildIntimateLedger(context, ref),
          const SizedBox(height: 60),
          _buildPurgeKillSwitch(context, ref),
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

  Widget _buildIdentityBlock(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("IDENTITY (KYC) STATUS", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white54)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.verified_user, color: VerveTokens.listeningCyan),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "BVN: ***-****-1234",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontSize: 16),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: VerveTokens.listeningCyan.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "VERIFIED",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VerveTokens.listeningCyan, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
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

  Widget _buildIntimateLedger(BuildContext context, WidgetRef ref) {
    final ledgerItems = ref.watch(ledgerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("INTIMATE LEDGER", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white54)),
        const SizedBox(height: 16),
        if (ledgerItems.isEmpty)
          Text("No memories recorded.", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white54))
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ledgerItems.length,
            itemBuilder: (context, index) {
              final item = ledgerItems[index];
              return Dismissible(
                key: Key(item['timestamp']! + item['context']!),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  ref.read(ledgerProvider.notifier).removeAt(index);
                },
                background: Container(
                  color: Colors.red.shade900,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                  ),
                  child: Text(
                    "[${item['timestamp']}] - [${item['category']}] - [${item['context']}]",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70, fontSize: 13),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildPurgeKillSwitch(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: const Key("purge_switch"),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: VerveTokens.backgroundBlack,
            title: const Text("Confirm Purge", style: TextStyle(color: Colors.white)),
            content: const Text(
              "This will destroy all local vectors and wipe Aura's memory. This action cannot be undone.",
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("CANCEL", style: TextStyle(color: Colors.white70)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("PURGE", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) async {
        final manager = ref.read(memoryManagerProvider);
        await manager.purgeProtocol();
        ref.read(ledgerProvider.notifier).clear();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Guardian Purge Protocol Complete.")),
          );
        }
      },
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red.shade900,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.warning, color: Colors.white),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: VerveTokens.nexusAmber),
        ),
        child: const Center(
          child: Text(
            "[ SLIDE RIGHT TO INITIATE TOTAL CONTEXT PURGE ]",
            style: TextStyle(color: VerveTokens.nexusAmber, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
        ),
      ),
    );
  }
}
