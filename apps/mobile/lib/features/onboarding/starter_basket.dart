import 'package:flutter/material.dart';
import '../../core/theme/verve_theme.dart';
import '../viewport/widgets/proposal_card.dart';

class StarterBasketScreen extends StatelessWidget {
  const StarterBasketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // P2-T16: Neighborhood Starter Basket screen (cold start fallback).
    return Scaffold(
      backgroundColor: VerveTokens.backgroundBlack,
      appBar: AppBar(
        title: const Text("Your Local Starter Basket"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: ProposalCard(
          title: "Neighborhood Starter Basket",
          items: [
            "Local Fresh Produce Box",
            "Artisan Bread Loaf",
            "Farm Eggs (Dozen)",
            "Premium Coffee Roast",
          ],
        ),
      ),
    );
  }
}
