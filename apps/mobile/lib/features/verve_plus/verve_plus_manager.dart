import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simulates the number of completed orders
class OrderCountManager extends Notifier<int> {
  @override
  int build() => 0; // Starts at 0

  void increment() {
    state++;
  }
}

final orderCountProvider = NotifierProvider<OrderCountManager, int>(() {
  return OrderCountManager();
});

// P2-T21: Nudge logic (true when > 4 orders)
final vervePlusNudgeProvider = Provider<bool>((ref) {
  final count = ref.watch(orderCountProvider);
  return count >= 4;
});
