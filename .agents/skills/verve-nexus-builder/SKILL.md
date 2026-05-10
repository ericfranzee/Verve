---
name: verve-nexus-builder
description: "Use when building Nexus logistics services for Verve: Node.js GraphQL API, Rider Pulse App, Chaos Protocol implementations, PoF engine, hub operations, rider safety, fraud detection, and Bio-Handshake cascade."
category: development
risk: safe
source: project
tags: "[nodejs, graphql, logistics, rider-app, chaos-protocols, inventory, fulfillment, safety]"
date_added: "2026-05-10"
---

# Verve Nexus Builder — Physical World Intelligence

## Purpose

Build the entire physical fulfillment layer of Verve — the systems that bridge digital intent with real-world delivery. This includes the Node.js GraphQL Nexus API, the Rider Pulse App, all 10 Chaos Protocol implementations, the PoF engine, fraud detection, hub operations, rider safety protocols, and the Bio-Handshake cascade.

**This is the skill that makes Verve survive contact with Lagos.**

## When to Use

- Building the Node.js/GraphQL Nexus API (inventory, orders, dispatch)
- Building the Rider Pulse App (lightweight Flutter)
- Implementing Probability of Fulfillment (PoF) engine
- Implementing any of the 10 Chaos Protocols (Nexus Manual §5)
- Building rider safety features (SOS, route safety, compensation logic)
- Building the Bio-Handshake cascade (4 degradation levels)
- Implementing fraud detection (velocity model, coordinated attacks)
- Building hub operations (zone management, IoT sensor integration)
- Enforcing the Single-Hub routing policy (Blueprint §7)

## Architecture Context

```
[ Intent Engine ] ──(GraphQL)──> [ Node.js Nexus API ]
                                       │
                          ┌────────────┼────────────────┐
                          │            │                │
                    [ PostgreSQL ]  [ Redis Cache ]  [ IoT Sensors ]
                          │            │                │
                          └────────────┼────────────────┘
                                       │
                              ┌────────┴─────────┐
                        [ Picker App ]    [ Rider Pulse App ]
                              │                  │
                         (picks items)    (delivers items)
                                                 │
                                         [ Bio-Handshake ]
                                                 │
                                          [ User Device ]
```

---

## Component 1: Node.js Nexus API

**Framework:** Node.js + GraphQL + TypeScript

### Project Structure

```
services/nexus-api/
├── src/
│   ├── index.ts
│   ├── schema/
│   │   ├── inventory.graphql       # SKU queries, zone filtering
│   │   ├── orders.graphql          # Create, track, complete, cancel
│   │   ├── riders.graphql          # Dispatch, GPS tracking, SOS
│   │   ├── hubs.graphql            # Zone status, capacity, IoT alerts
│   │   └── chaos.graphql           # Chaos protocol triggers and status
│   ├── resolvers/
│   │   ├── inventory.ts            # Query by GPS → nearest hub
│   │   ├── orders.ts               # Order lifecycle management
│   │   ├── riders.ts               # Dispatch, tracking, handshake
│   │   ├── hubs.ts                 # Hub capacity and zone status
│   │   └── chaos.ts                # Protocol activation/deactivation
│   ├── services/
│   │   ├── pof_engine.ts           # Probability of Fulfillment calculator
│   │   ├── pof_desync_detector.ts  # Redis vs. PostgreSQL drift detection
│   │   ├── spoilage_swap.ts        # Quality rejection → substitute
│   │   ├── dispatch.ts             # Optimal picker/rider assignment
│   │   ├── single_hub_policy.ts    # Enforce no-split-order rule (Blueprint §7.1)
│   │   ├── fraud_detector.ts       # Velocity model, coordinated attack detection
│   │   └── hub_operations.ts       # Zone management, IoT sensor integration
│   ├── chaos/
│   │   ├── spoilage.ts             # Protocol 5.1: Spoilage Swap
│   │   ├── gridlock.ts             # Protocol 5.2: Traffic Gridlock
│   │   ├── power_failure.ts        # Protocol 5.3: Power Grid Failure
│   │   ├── rider_device.ts         # Protocol 5.4: Rider Device Failure
│   │   ├── user_not_home.ts        # Protocol 5.5: User Not Home
│   │   ├── fleet_immobilization.ts # Protocol 5.6: Fuel Scarcity
│   │   ├── hub_flooding.ts         # Protocol 5.7: Rainy Season Flooding
│   │   ├── coordinated_fraud.ts    # Protocol 5.8: Order-and-Cancel Attacks
│   │   ├── picker_walkout.ts       # Protocol 5.9: Picker Walkout Mid-Shift
│   │   └── holiday_surge.ts        # Protocol 5.10: National Holiday Surge
│   ├── rider/
│   │   ├── sos_protocol.ts         # Emergency SOS (Nexus Manual §6.4)
│   │   ├── compensation.ts         # Base + per-delivery + surge + perfect week
│   │   ├── shift_manager.ts        # 8h max, mandatory break enforcement
│   │   └── route_safety.ts         # Motorcycle ban zones, night cutoff, weather lockout
│   ├── handshake/
│   │   ├── bio_handshake.ts        # Level 0: Full BLE + visual
│   │   ├── visual_only.ts          # Level 1: Camera reads color pulse
│   │   ├── otp_fallback.ts         # Level 2: 6-digit OTP, 30s expiry
│   │   ├── hub_callback.ts         # Level 3: Verbal confirmation via hub
│   │   └── cascade.ts              # Auto-escalation logic (Guardian §5.4)
│   └── db/
│       ├── postgres.ts             # Transactional data
│       └── redis.ts                # Live stock cache + desync detection
├── package.json
└── tsconfig.json
```

### PoF Engine (Blueprint §5.1 + Enhanced)

```typescript
function calculatePoF(item: InventoryItem): number {
  const hoursSinceVerified = diffHours(now(), item.lastPhysicalScan);
  const spoilageRate = item.historicalSpoilageRate;
  const baseScore = Math.max(0, 1.0 - (hoursSinceVerified * spoilageRate));

  // Redis desync penalty (Blueprint §5.3)
  const redisDrift = await detectDesync(item.id);
  if (redisDrift > 0.15) {
    await invalidateRedisCache(item.id);
    return Math.min(baseScore, 0.80); // Cap at 0.80 until verified
  }

  return baseScore;
  // Score > 0.95: Aura can promise
  // Score < 0.80: Aura must caveat ("Let me double check...")
}
```

### Single-Hub Policy (Blueprint §7.1)

```typescript
function validateOrder(order: Order, primaryHub: Hub): OrderValidation {
  const unavailableItems = order.items.filter(
    item => primaryHub.getPoF(item.sku) < 0.80
  );

  if (unavailableItems.length >= 2) {
    return {
      valid: false,
      reason: "MULTIPLE_UNAVAILABLE",
      message: `Your hub is out of ${unavailableItems.map(i => i.name).join(" and ")}. ` +
               `I can swap both for alternatives, or stage the rest.`,
      suggestions: unavailableItems.map(item => findSubstitute(item, primaryHub))
    };
  }
  // NEVER split across hubs in V1.0
}
```

### Fraud Detection (Nexus Manual §5.8)

```typescript
interface VelocityCheck {
  maxCancellationsPerAccount: 5;   // per 30 minutes
  maxIdenticalOrdersPerCluster: 3; // per 10 minutes, same GPS radius
  holdAction: "VERIFICATION_HOLD"; // Require Verve Wallet upfront
  falsePositiveCompensation: 1000; // ₦1,000 wallet credit
}
```

---

## Component 2: Rider Pulse App

A lightweight Flutter application for delivery riders. Domain-coupled with Nexus operations, not the consumer UI.

### Project Structure

```
apps/rider-pulse/
├── lib/
│   ├── main.dart
│   ├── features/
│   │   ├── dispatch/           # Accept/reject delivery assignments
│   │   ├── navigation/         # Turn-by-turn with ban zone enforcement
│   │   ├── handshake/          # Bio-Handshake (all 4 fallback levels)
│   │   ├── sos/                # Emergency SOS (3-second hold button)
│   │   └── shift/              # Clock in/out, break timer, earnings
│   ├── core/
│   │   ├── gps_tracker.dart    # Continuous GPS to Nexus API
│   │   ├── ble_manager.dart    # BLE for Bio-Handshake Level 0
│   │   └── safety_rules.dart   # Ban zone enforcement, night cutoff
│   └── widgets/
│       ├── sos_button.dart     # Always-visible, 3-second hold to trigger
│       └── earnings_card.dart  # Real-time shift earnings display
```

### Rider Safety Rules (Nexus Manual §6.3)

```dart
class SafetyRules {
  // Hard-coded bridge and expressway restrictions
  static const banZones = [
    BanZone(name: "Third Mainland Bridge", type: "motorcycle_ban", hours: "all"),
    // ... additional zones per city
  ];

  // No deliveries after 9:00 PM (9:30 PM for Verve+ Priority)
  static const nightCutoff = TimeOfDay(hour: 21, minute: 0);
  static const nightCutoffPriority = TimeOfDay(hour: 21, minute: 30);

  // Weather lockout: API integration
  static Future<bool> isWeatherSafe() async {
    // Check weather service for severe conditions
    // Return false if flooding or visibility < 100m
  }
}
```

### Compensation Calculator (Nexus Manual §6.2)

```dart
class CompensationCalculator {
  static const baseGuarantee = 4000;       // ₦4,000/shift floor
  static const perDeliveryBase = 300;       // ₦300-500 per delivery
  static const surgeMultiplier = 1.5;       // During peak hours
  static const perfectWeekBonus = 5000;     // ₦5,000

  // Peak hours: 11AM-2PM, 5PM-8PM
  static bool isPeakHour(DateTime time) =>
    (time.hour >= 11 && time.hour < 14) ||
    (time.hour >= 17 && time.hour < 20);
}
```

### SOS Protocol (Nexus Manual §6.4)

```dart
class SOSProtocol {
  // Rider holds SOS button for 3 seconds
  static Future<void> trigger() async {
    // 1. Broadcast live GPS to Nexus Lead dashboard
    // 2. Freeze active delivery — payment not captured
    // 3. Hub contacts rider within 60 seconds
    // 4. If unreachable, notify local emergency contacts
    // 5. User receives transparent delay notification
  }
}
```

---

## Component 3: Bio-Handshake Cascade (Guardian §5.4)

Four degradation levels with automatic escalation:

| Level | Trigger | Mechanism | Timeout |
|-------|---------|-----------|---------|
| **0 (Full)** | Both devices BLE-capable | BLE token + visual color pulse | 5 seconds |
| **1 (Visual)** | BLE unavailable | Camera reads color pulse | 10 seconds |
| **2 (OTP)** | Camera/screen failure | 6-digit code, 30s expiry | 30 seconds |
| **3 (Callback)** | Both devices non-functional | Rider → Hub → User verbal confirm | Manual |

**Auto-Escalation Logic:**
```typescript
async function executeHandshake(order: Order, rider: Rider, user: User): Promise<HandshakeResult> {
  // Try Level 0
  const bleResult = await tryBLEHandshake(rider.device, user.device, { timeout: 5000 });
  if (bleResult.success) return bleResult;

  // Auto-fall to Level 1
  const visualResult = await tryVisualHandshake(rider.camera, user.screen, { timeout: 10000 });
  if (visualResult.success) return visualResult;

  // Auto-fall to Level 2
  const otpResult = await tryOTPHandshake(user.screen, rider.input, { expiry: 30000 });
  if (otpResult.success) return otpResult;

  // Level 3 requires manual trigger by rider
  return { success: false, fallbackLevel: 3, requiresManualTrigger: true };
}
```

**Audit Rule:** Every degraded handshake is logged. If Level 3 is used 2+ times for the same user-rider pair, flag for review.

---

## Component 4: 10 Chaos Protocols (Nexus Manual §5)

Each protocol follows the pattern: **Trigger → Detection → Action → Aura Communication → Resolution**

| Protocol | Trigger | Key Action |
|----------|---------|------------|
| 5.1 Spoilage Swap | Picker quality scan fail | Auto-substitute + user notification |
| 5.2 Traffic Gridlock | Rider GPS stationary > 5 min | Re-route via secondary roads |
| 5.3 Power Grid Failure | IoT temp sensor spike | Drop PoF to 0 for cold-chain items |
| 5.4 Rider Device Failure | GPS ping lost > 3 min | Degraded handshake + backup rider dispatch |
| 5.5 User Not Home | Bio-Handshake timeout at 5 min | Cold-hold return + 2-hour hold at hub |
| 5.6 Fleet Immobilization | Fleet capacity < 40% | Extend all ETAs + Verve+ priority |
| 5.7 Hub Flooding | IoT humidity sensors | Zone lockout from PoF engine |
| 5.8 Coordinated Fraud | Velocity model triggers | Verification Hold + mandatory wallet payment |
| 5.9 Picker Walkout | Picker offline during shift | Ticket redistribution + emergency cross-training |
| 5.10 Holiday Surge | Calendar + historical demand | Pre-stage inventory 48h ahead + proactive user prompts |

---

## Key Constraints

| Metric | Target | Source |
|--------|--------|--------|
| Inventory sync | < 2 seconds | PRD §3.4 |
| PoF accuracy | > 95% | Build Strategy §8 |
| Order-to-delivery (5km) | < 15 min (P80) | Build Strategy §8 |
| Bio-Handshake Level 0 success | > 95% | Build Strategy §8 |
| Redis desync detection | < 120 seconds | PRD §4.4 |
| Fraud false positive rate | < 5% | Nexus §5.8 |
| Night delivery cutoff | 9:00 PM strict | Nexus §6.3 |
| Rider shift maximum | 8 hours | Nexus §6.2 |

## Dependencies

| This Skill Needs | From |
|-----------------|------|
| Intent Engine queries (structured intents) | verve-backend-builder |
| Synapse Payload consumer (Aura messaging) | verve-backend-builder |
| Bio-Handshake UI overlay | verve-flutter-builder |
| Guardian Vault handshake level display | verve-flutter-builder |

| This Skill Provides | To |
|---------------------|-----|
| PoF scores and inventory data | verve-backend-builder (Intent Engine) |
| Rider GPS position for GIS Canvas | verve-flutter-builder |
| Order status updates | verve-flutter-builder |
| Chaos protocol status | verve-verifier |
| Handshake completion signal | verve-flutter-builder, verve-backend-builder |
