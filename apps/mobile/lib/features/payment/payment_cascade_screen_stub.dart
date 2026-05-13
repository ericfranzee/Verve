import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/verve_theme.dart';

// Notifier for Payment Methods
class PaymentCascadeNotifier extends Notifier<List<Map<String, dynamic>>> {
  @override
  List<Map<String, dynamic>> build() {
    return [
      {
        "id": "1",
        "title": "Paystack",
        "subtitle": "GTBank Card ending in 4432",
        "icon": Icons.credit_card,
      },
      {
        "id": "2",
        "title": "Flutterwave",
        "subtitle": "Zenith Account Transfer",
        "icon": Icons.account_balance,
      },
      {
        "id": "3",
        "title": "Verve Wallet",
        "subtitle": "Balance: ₦45,000",
        "icon": Icons.account_balance_wallet,
      },
    ];
  }

  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final items = List<Map<String, dynamic>>.from(state);
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    state = items;
  }
}

final paymentCascadeProvider =
    NotifierProvider<PaymentCascadeNotifier, List<Map<String, dynamic>>>(
        () => PaymentCascadeNotifier());

class PaymentCascadeScreen extends ConsumerWidget {
  const PaymentCascadeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentMethods = ref.watch(paymentCascadeProvider);

    return Scaffold(
      backgroundColor: VerveTokens.backgroundBlack,
      appBar: AppBar(
        title: const Text("Payment & Routing Configuration"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildVervePlusCard(context),
            const SizedBox(height: 32),
            _buildWalletTopUp(context),
            const SizedBox(height: 32),
            Text(
              "CASCADE MANAGER (DRAG TO REORDER)",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white54, letterSpacing: 1.2),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ReorderableListView.builder(
                itemCount: paymentMethods.length,
                onReorder: (oldIndex, newIndex) {
                  ref.read(paymentCascadeProvider.notifier).reorder(oldIndex, newIndex);
                },
                itemBuilder: (context, index) {
                  final method = paymentMethods[index];
                  String slotLabel = "";
                  if (index == 0) {
                    slotLabel = "Primary";
                  } else if (index == 1) {
                    slotLabel = "Secondary";
                  } else if (index == 2) {
                    slotLabel = "Tertiary";
                  } else {
                    slotLabel = "Slot ${index + 1}";
                  }

                  return Container(
                    key: Key(method['id'] as String),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(method['icon'] as IconData, color: Colors.white70),
                      title: Text(
                        "Slot ${index + 1} ($slotLabel): ${method['title']}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        method['subtitle'] as String,
                        style: const TextStyle(color: Colors.white54),
                      ),
                      trailing: const Icon(Icons.drag_handle, color: Colors.white38),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVervePlusCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [VerveTokens.auraTeal.withValues(alpha: 0.8), VerveTokens.listeningCyan.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "VERVE+",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24, fontStyle: FontStyle.italic),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text("ACTIVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Priority routing, zero delivery fees, and automated pantry forecasting.",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.9)),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletTopUp(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: VerveTokens.nexusAmber.withValues(alpha: 0.1),
        border: Border.all(color: VerveTokens.nexusAmber.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Verve Wallet",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VerveTokens.nexusAmber),
              ),
              const SizedBox(height: 4),
              Text(
                "₦45,000",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24, color: Colors.white),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Top-up interface coming soon.")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: VerveTokens.nexusAmber,
              foregroundColor: Colors.black,
            ),
            child: const Text("TOP UP", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
