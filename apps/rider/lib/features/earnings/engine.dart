import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShiftEarnings {
  final double basePay;
  final double deliveryBonuses;
  final double surgeMultiplier;
  final bool qualifiesForPerfectWeek;
  final double perfectWeekBonus;

  const ShiftEarnings({
    this.basePay = 4000.0, // NGN 4000 minimum base
    this.deliveryBonuses = 0.0,
    this.surgeMultiplier = 1.0,
    this.qualifiesForPerfectWeek = false,
    this.perfectWeekBonus = 5000.0,
  });

  double get totalEarnings {
    double total = basePay + (deliveryBonuses * surgeMultiplier);
    if (qualifiesForPerfectWeek) {
      total += perfectWeekBonus;
    }
    return total;
  }

  ShiftEarnings copyWith({
    double? basePay,
    double? deliveryBonuses,
    double? surgeMultiplier,
    bool? qualifiesForPerfectWeek,
    double? perfectWeekBonus,
  }) {
    return ShiftEarnings(
      basePay: basePay ?? this.basePay,
      deliveryBonuses: deliveryBonuses ?? this.deliveryBonuses,
      surgeMultiplier: surgeMultiplier ?? this.surgeMultiplier,
      qualifiesForPerfectWeek: qualifiesForPerfectWeek ?? this.qualifiesForPerfectWeek,
      perfectWeekBonus: perfectWeekBonus ?? this.perfectWeekBonus,
    );
  }
}

class EarningsEngine extends StateNotifier<ShiftEarnings> {
  EarningsEngine() : super(const ShiftEarnings());

  void addDelivery(double distanceKm, {bool isSurgeHour = false}) {
    // ₦300-500 per successful Bio-Handshake (distance-tiered)
    double bonus = 300.0;
    if (distanceKm > 5.0) {
      bonus = 400.0;
    } else if (distanceKm > 10.0) {
      bonus = 500.0;
    }

    state = state.copyWith(
      deliveryBonuses: state.deliveryBonuses + bonus,
      surgeMultiplier: isSurgeHour ? 1.5 : 1.0,
    );
  }

  void evaluatePerfectWeek(bool zeroRejected, bool zeroComplaints, bool perfectOnTimeRate, int shiftsWorked) {
    if (zeroRejected && zeroComplaints && perfectOnTimeRate && shiftsWorked >= 5) {
      state = state.copyWith(qualifiesForPerfectWeek: true);
    } else {
      state = state.copyWith(qualifiesForPerfectWeek: false);
    }
  }
}

final earningsProvider = StateNotifierProvider<EarningsEngine, ShiftEarnings>((ref) {
  return EarningsEngine();
});
