import 'package:flutter_riverpod/flutter_riverpod.dart';

enum WeatherCondition { clear, lightRain, heavyRain, flooded, severeStorm }

class Location {
  final double lat;
  final double lng;
  const Location(this.lat, this.lng);
}

class BanZone {
  final String name;
  final List<Location> bounds;

  const BanZone({required this.name, required this.bounds});

  bool contains(Location location) {
    // Simplified stub: actual GIS would do point-in-polygon
    return false;
  }
}

// Third Mainland Bridge motorcycle ban in Lagos mock
const List<BanZone> mockBanZones = [
  BanZone(
    name: 'Third Mainland Bridge',
    bounds: [
      Location(6.49, 3.39),
      Location(6.50, 3.40),
    ],
  )
];

class RouteSafetyStatus {
  final bool isSafe;
  final String? reason;

  const RouteSafetyStatus({required this.isSafe, this.reason});
}

class RouteEnforcementEngine {
  final List<BanZone> banZones;

  RouteEnforcementEngine({this.banZones = mockBanZones});

  RouteSafetyStatus evaluateRoute(List<Location> routePath, WeatherCondition weather, DateTime currentTime) {
    // 1. Weather Lockout (P3-T19)
    if (weather == WeatherCondition.flooded || weather == WeatherCondition.severeStorm) {
       return const RouteSafetyStatus(isSafe: false, reason: "Deliveries paused for rider safety. I'll resume the moment conditions clear.");
    }

    // 2. Night Cutoff (P3-T19)
    // No deliveries dispatched after 9:00 PM (21:00)
    if (currentTime.hour >= 21) {
      return const RouteSafetyStatus(isSafe: false, reason: "Night delivery cutoff enforced.");
    }

    // 3. Ban Zones (P3-T19)
    for (var point in routePath) {
      for (var zone in banZones) {
        if (zone.contains(point)) {
          return RouteSafetyStatus(isSafe: false, reason: "Route intersects restricted motorcycle ban zone: \${zone.name}.");
        }
      }
    }

    return const RouteSafetyStatus(isSafe: true);
  }
}

final routeEnforcementProvider = Provider((ref) => RouteEnforcementEngine());
