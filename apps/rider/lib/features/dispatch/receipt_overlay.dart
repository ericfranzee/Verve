import 'package:flutter/material.dart';
import 'dart:ui';

class FrostedReceiptOverlay extends StatelessWidget {
  final String orderId;
  final String customerName;
  final List<String> items;
  final VoidCallback onAcknowledge;

  const FrostedReceiptOverlay({
    super.key,
    required this.orderId,
    required this.customerName,
    required this.items,
    required this.onAcknowledge,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Card(
                color: const Color(0xFF1E1E1E).withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                margin: const EdgeInsets.all(32.0),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.receipt_long, size: 48, color: Colors.tealAccent),
                      const SizedBox(height: 16),
                      Text(
                        "Order #\$orderId",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Deliver to: \$customerName",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      const Divider(height: 32, color: Colors.white24),
                      ...items.map((item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, size: 16, color: Colors.teal),
                                const SizedBox(width: 8),
                                Expanded(child: Text(item, style: const TextStyle(color: Colors.white))),
                              ],
                            ),
                          )),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: onAcknowledge,
                        child: const Text("Initialize Handshake"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
