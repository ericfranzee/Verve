---
name: verve-flutter-builder
description: "Use when building Flutter frontend for Verve: Bootstrap Dialogue, Trust Ladder UI, Morphing Viewport, Breathing Wave shader, Degraded Handshake UI, Emotional State feedback, Verve+ surfaces, Adaptive Fidelity, and brand system."
category: development
risk: safe
source: project
tags: "[flutter, impeller, riverpod, shaders, animations, ui, mobile, trust-ladder, onboarding]"
date_added: "2026-05-10"
date_updated: "2026-05-10"
---

# Verve Flutter Builder — Frontend & UI

## Purpose

Build the complete Flutter mobile application for Verve. Owns the visual layer, audio pipeline, state management, device integration, and all user-facing implementations of Trust Ladder, Cold Start onboarding, Ambiguity Resolution visual feedback, Degraded Bio-Handshake UI, and Verve+ subscription surfaces.

## When to Use

- Building the Bootstrap Dialogue (Day 1 onboarding — PRD §1.4)
- Building Trust Ladder UI in Guardian Vault (Brand §1.1, Guardian §5.3)
- Building Morphing Viewport states and Breathing Wave shader
- Building Degraded Bio-Handshake UI (4 fallback levels — Guardian §5.4)
- Building Emotional State visual feedback (Brand §3.2)
- Building Verve+ subscription surfaces and upgrade nudges (PRD §1.5)
- Building "Neighborhood Starter Basket" for cold start (PRD §1.4)
- Building Adaptive Fidelity Engine and connection-degraded states (Blueprint §5.3)
- Building secondary screens (Guardian, Pantry, History, Payments, Bridge)

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Framework | Flutter (Dart) + Impeller (120fps) |
| State | Riverpod (async WebSocket streams) |
| Audio | Native C++ FFI bridge (low-latency PCM/TTS) |
| Edge AI | TFLite via platform channels |
| Local DB | SQLite-VEC (via verve-edge-builder) |

## Project Structure

```
lib/
├── main.dart
├── core/
│   ├── theme/         # VerveColors, VerveTypography, VerveTheme
│   ├── audio/         # C++ FFI bridge, PCM capture, TTS player
│   ├── network/       # WebSocket client, network monitor, adaptive fidelity
│   ├── haptics/       # Light Tap(10ms), Medium Thud(20ms), Double Heavy(30ms×2)
│   └── trust/         # [NEW] Trust Ladder state manager, level-aware UI gating
├── features/
│   ├── onboarding/    # [NEW] Bootstrap Dialogue, Starter Basket (PRD §1.4)
│   │   ├── bootstrap_dialogue.dart  # 90-second voice calibration
│   │   ├── starter_basket.dart      # Neighborhood popular items
│   │   └── trust_escalation.dart    # Delayed payment request
│   ├── home/          # Main canvas: Morphing Viewport + Sentinel Zone
│   │   ├── widgets/   # breathing_wave, hero_card, proposal_cards, gis_canvas,
│   │   │              # frosted_receipt, bio_handshake
│   │   ├── providers/ # aura_state, viewport_state, synapse_provider
│   │   └── feedback/  # [NEW] Emotional state visual indicators
│   │       ├── execution_mode.dart   # Minimal UI, no decorations
│   │       ├── discovery_mode.dart   # Expanded cards, richer descriptions
│   │       └── precision_mode.dart   # Explicit confirmation overlays
│   ├── guardian/      # Guardian Vault + Trust Ladder display (Guardian §5.3)
│   │   ├── intimate_ledger.dart
│   │   ├── purge_killswitch.dart
│   │   ├── kyc_block.dart
│   │   └── trust_level_display.dart  # [NEW] Current level + data breakdown
│   ├── pantry/        # Predictive Pantry: Depletion Horizon
│   │   └── cold_start_pantry.dart    # [NEW] "Popular in Your Area" fallback
│   ├── history/       # Semantic History: Event timeline, Re-Provision
│   ├── payments/      # Cascade Manager + Verve+ subscription
│   │   ├── cascade_manager.dart
│   │   ├── wallet_topup.dart
│   │   └── verve_plus.dart           # [NEW] Subscription surfaces (PRD §1.5)
│   ├── escalation/    # Human Bridge: Nexus Lead concierge overlay
│   └── handshake/     # [NEW] Degraded Bio-Handshake UI (Guardian §5.4)
│       ├── ble_handshake.dart        # Level 0: Full BLE + visual pulse
│       ├── visual_only.dart          # Level 1: Camera reads color pulse
│       ├── otp_display.dart          # Level 2: 6-digit code, 30s countdown
│       └── callback_message.dart     # Level 3: "Show rider this code" + hub call
└── shaders/
    ├── breathing_wave.frag           # Full shader (Adreno/Apple GPU)
    └── breathing_wave_lite.frag      # [NEW] Simplified (Mali GPU — Build Strategy §7.1)
```

## New Components (from Enhanced Docs)

### 1. Bootstrap Dialogue (PRD §1.4 — Cold Start)

The Day 1 onboarding experience. A 90-second voice conversation that calibrates Aura without feeling like a form.

- **Flow:** Welcome → household size → dietary restrictions → protein preferences → Starter Basket presentation
- **No payment requested.** First interaction ends with a Draft Basket, not a checkout.
- **Trust Escalation:** Payment is only requested when the user actively says "dispatch."
- **Starter Basket:** 10 most-ordered items from the user's assigned hub, filtered by Bootstrap answers.

### 2. Trust Ladder UI (Brand §1.1, Guardian §5.3)

Displayed in Guardian Vault. The user sees their current trust level and exactly what data Aura can access.

```dart
// Trust Level Display Widget
class TrustLevelDisplay extends ConsumerWidget {
  // Shows: Level name, icon, data access list, "Tap to adjust" CTA
  // Level 0: Stranger — "Aura knows nothing personal about you"
  // Level 1: Acquaintance — "Aura can see your past orders"
  // Level 2: Confidant — "Aura tracks your pantry and dietary needs"
  // Level 3: Partner — "Aura handles everything. You just say yes."
  // Demotion: Instant. No guilt messaging. No "Are you sure?"
}
```

### 3. Degraded Bio-Handshake UI (Guardian §5.4)

Four visual states matching the 4-level cascade:
- **Level 0:** Full-screen color pulse + BLE icon + "Hold phones close"
- **Level 1:** Camera viewfinder + "Point camera at rider's screen"
- **Level 2:** Large 6-digit OTP with countdown timer + "Show rider this code: 847293"
- **Level 3:** Message: "Rider is calling the hub. Please answer your phone."
- **Auto-escalation:** UI transitions automatically as each level times out.

### 4. Emotional State Visual Feedback (Brand §3.2)

Aura's UI adapts based on detected emotional state:
- **Execution Mode:** Minimal chrome, no Hero Card decorations, just text + confirm button. Wave stays static teal.
- **Discovery Mode:** Expanded proposal cards, richer imagery, subtle animations. Wave has gentle movement.
- **Precision Mode:** Each element highlighted sequentially with explicit confirm/reject per item.

### 5. Verve+ Subscription Surfaces (PRD §1.5)

- **Natural nudge:** After 4+ deliveries in a month, Aura says: *"You've ordered 5 times. Verve+ would have saved ₦3,200."*
- **Subscription card** in Payments screen with clear value proposition.
- **During constraints:** When fleet is constrained (Chaos §5.6), non-subscribers see Verve+ trial offer.

### 6. Connection-Degraded Feedback (Blueprint §5.3)

- **Amber pulse:** Breathing Wave shifts to slow Amber when WebSocket drops.
- **"Aura is thinking..."** with cached suggestion when Intent Engine times out.
- **Offline indicator:** When fully offline, Wave goes dim with text: "Buffering — say what you need."

## Existing Components (Retained)

### Breathing Wave (GLSL Shader)
Four states: IDLE (Deep Teal), LISTENING (Bright Cyan), PROCESSING (Amber), SPEAKING (Solid Teal). Pre-compiled via Impeller. **Two variants:** full (Adreno/Apple) and lite (Mali GPU).

### Morphing Viewport
States: Void → Hero Card → Proposal → GIS Canvas → Frosted Receipt → Bio-Handshake. Transitions within 50ms of TTS word.

### Hero Card
Macro photography with gyroscope parallax tilt. Fallback: if load > 200ms → SVG silhouette.

### Adaptive Fidelity Engine (PRD §4.2)
Ping > 400ms or 3G → disable parallax, replace .webp with local .svg, TTS low bitrate, max 2MB/session.

### Brand System (Brand Manual §2)
Colors: Teal #008080, Amber #FFBF00, Emerald #50C878, Cyan #22D3EE. Typography: Inter (headers), JetBrains Mono (data). Haptics and sounds per spec.

## Secondary Screens (Enhanced)

| Screen | Key Elements |
|--------|-------------|
| Guardian Vault | Intimate Ledger, Purge Kill-Switch, KYC Block, **Trust Ladder Level Display** |
| Predictive Pantry | Depletion Horizon, SVG silhouettes, Train-the-AI, **"Popular in Area" cold start** |
| Semantic History | Event-based timeline, Vitality Score, Re-Provision button |
| Payment Cascade | Drag-drop ordering, Wallet top-up, **Verve+ subscription card** |
| Human Bridge | Nexus Amber theme, Nexus Lead portrait, hybrid text/push-to-talk |

## Performance Constraints

| Metric | Target | Source |
|--------|--------|--------|
| Frame Rate | 60fps min, 120fps target | PRD §4.1 |
| Cold Start | < 1.5s to Idle Wave | PRD §4.1 |
| Battery | < 2% per 5-min session | PRD §4.1 |
| UI Sync | < 50ms of TTS word | Blueprint §3 |
| Fallback | < 200ms then SVG | PRD §3.2 |
| Low-BW | < 2MB per session | PRD §4.2 |
| Handshake Level 0 | < 5s to resolve | Guardian §5.4 |

## Dependencies

**Needs:** Go Orchestrator WebSocket endpoint, Synapse Payload format, SQLite-VEC bindings, TFLite models, Trust Ladder level from Edge builder, PoF scores from Nexus
**Provides:** PCM audio stream, Guardian Vault trigger, UI telemetry, Trust level change signals, Handshake completion events
