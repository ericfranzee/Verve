# **Verve Core: Engineering & Architecture Blueprint v1.0**

**Document Status:** Final (Engineering Ready) **Date:** May 8, 2026 **Location:** Nigeria (Abuja/Lagos Operations)

## **1\. System Overview & Philosophy**

Verve is not a traditional CRUD application; it is an **Intent-Agent Ecosystem**. The architecture is designed around "The Visual Synapse"—a tightly coupled stream of voice and metadata that drives a headless Flutter frontend.  
The system operates under the **"Local-First, Edge-Heavy"** philosophy to mitigate the infrastructure challenges (erratic power, fluctuating 3G/4G/5G networks) inherent in the Nigerian market.

## **2\. High-Level Architecture Stack**

| Layer | Technology | Primary Function |
| :---- | :---- | :---- |
| **Frontend (Mobile)** | Flutter (Dart) \+ Impeller Engine | 120fps UI rendering, Voice/PCM capture, Visual State Management. |
| **Local Intelligence** | SQLite-VEC (Edge) | On-device semantic memory and context storage. |
| **Orchestrator API** | Go (Golang) | High-concurrency middleware, session management, UI-metadata tagging. |
| **Intent Engine (RAG)** | Python \+ FastAPI \+ Cloud LLM | Intent extraction, database routing, response generation. |
| **Nexus Fulfillment** | Node.js \+ GraphQL | Micro-Fulfillment Center (MFC) inventory sync and rider dispatch. |
| **Global Memory Sync** | Pinecone / TiDB (Cloud) | Encrypted, long-term vector backup. |

## **3\. The Visual Synapse (Core Interaction Loop)**

The most critical engineering challenge is synchronizing the AI's audio output with the Flutter UI transitions without perceived latency.

### **3.1 The Lifecycle of an Intent**

1. **Capture (Flutter):** User speaks. App streams PCM audio buffer to the Orchestrator via WebSocket.  
2. **Transcription (Orchestrator):** Audio is routed through a fast Whisper model (optimized for Nigerian accents/Pidgin).  
3. **Context Retrieval (RAG):**  
   * *Local:* App queries SQLite-VEC for recent memory (e.g., "Monday's Spinach").  
   * *Global:* Orchestrator queries Nexus API for live inventory at the nearest MFC.  
4. **Inference (Intent Engine):** The LLM processes the query, memory, and inventory.  
5. **The Synapse Payload:** The Engine generates a JSON response containing both the text for the TTS engine AND the UI instructions.  
6. **Execution (Flutter):** The app receives the TTS audio stream and the JSON metadata. It parses the metadata to trigger the Morphing Viewport transitions precisely as the audio plays.

### **3.2 The Metadata Payload Structure**

`{`  
  `"session_id": "uuid-1234",`  
  `"tts_audio_url": "[https://cdn.verve.com/audio/resp_88.mp3](https://cdn.verve.com/audio/resp_88.mp3)",`  
  `"latency_ms": 420,`  
  `"ui_sequence": [`  
    `{`  
      `"timestamp_ms": 0,`  
      `"action": "SET_WAVE_STATE",`  
      `"payload": { "state": "SPEAKING", "color": "#008080" }`  
    `},`  
    `{`  
      `"timestamp_ms": 1200, // Triggered exactly 1.2s into the audio`  
      `"action": "HERO_TRANSITION",`  
      `"payload": {`   
        `"component": "ProductCard",`   
        `"item_id": "SKU_SPINACH_01",`  
        `"fallback_vector": "svg/spinach_outline.svg"`  
      `}`  
    `}`  
  `]`  
`}`

## **4\. Memory Architecture (The "Guardian" Protocol)**

Verve uses a dual-layer Vector Database system to ensure privacy, speed, and offline resilience.

### **4.1 Tier 1: Local Context (SQLite-VEC)**

* **Location:** On-device.  
* **Purpose:** Instant retrieval of intimate context (dietary restrictions, last 30 days of purchases, immediate flavor preferences).  
* **Security:** Encrypted using the device's Secure Enclave/Keystore.  
* **Schema:**  
  * id (UUID)  
  * embedding (F32\_VEC\[1536\])  
  * content\_text (String \- e.g., "User prefers zero-sugar options for breakfast")  
  * temporal\_weight (Float \- Decays over time unless reinforced)

### **4.2 Tier 2: Global Context (Cloud Vector DB)**

* **Location:** Cloud (Pinecone/TiDB).  
* **Purpose:** Long-term pattern recognition and global product "Provenance" data (e.g., origin of the current batch of tomatoes in the Abuja Hub).  
* **Security:** Zero-Knowledge architecture. Vectors are anonymized and stripped of PII before leaving the device.

## **5\. The Nexus Logistics Integration**

The backend connection to physical reality must operate with zero tolerance for "hallucination."

### **5.1 The Inventory Graph (GraphQL)**

* **Strict Polling:** The app does not query a central server for inventory; it queries the specific MFC assigned to the user's GPS coordinates.  
* **Probability of Fulfillment (PoF):** Inventory API returns a ConfidenceScore.  
  * *Score \> 0.95:* Item is verified on the shelf within the last hour. AI can promise it.  
  * *Score \< 0.80:* AI must add a verbal caveat ("Let me double check the hub...") and trigger a manual picker verification.

### **5.2 The Bio-Handshake Protocol (Last Mile)**

* **Technology:** Bluetooth Low Energy (BLE) \+ Visual TOTP.  
* **Flow:**  
  1. Rider arrives at GPS ping.  
  2. User app and Rider app enter "Handshake Mode."  
  3. Both screens pulse a matching, dynamically generated color (e.g., \#FFBF00).  
  4. Devices exchange an encrypted BLE token.  
  5. Order status updates to DELIVERED automatically.

### **5.3 Failure Mode Map (What Breaks and What Happens)**

The architecture above describes the happy path. The Nigerian operating environment guarantees the unhappy path. Every component must have a documented failure mode and recovery strategy.

| Component | Failure Mode | Detection | Recovery | User Experience |
| :---- | :---- | :---- | :---- | :---- |
| **Go Orchestrator** | Process crash mid-session | Client WebSocket close event | Client reconnects with `session_id`; Orchestrator restores state from Redis snapshot (session state persisted every 5s) | Aura pauses for 1-2s then resumes: *"Sorry, brief hiccup. Where were we — the salmon?"* |
| **Go Orchestrator** | WebSocket drop (network) | Ping/pong timeout (10s) | Client enters offline mode; buffers intents locally; reconnects with exponential backoff (1s, 2s, 4s, max 30s) | Breathing Wave shifts to slow Amber pulse; *"Connection unstable. I'm buffering — say what you need."* |
| **Intent Engine** | LLM timeout (> 5s) | Orchestrator deadline exceeded | Orchestrator returns cached suggestion based on user's most recent purchase pattern + current time-of-day heuristic | *"Aura is thinking... Based on your usual Thursday, I'd suggest the grilled chicken. Want me to stage it?"* |
| **Intent Engine** | LLM returns incoherent response | Orchestrator validates response schema; rejects if `ui_sequence` is malformed | Retry once with simplified prompt; if retry fails, trigger Human Bridge | *"I got confused on that one. Let me connect you with the Nexus Lead."* |
| **Whisper Transcription** | Transcription garbled (< 60% confidence) | Whisper confidence score below threshold | Aura asks for repeat in a natural way; if 2nd attempt also fails, switch to text input | *"The line's a bit rough — say that again for me?"* → then keyboard icon pulses |
| **Nexus API** | GraphQL endpoint unreachable | Orchestrator health check fails | Hard-block all inventory suggestions; Aura explains transparently | *"I can't reach your hub right now. I'll keep trying — want me to queue your usual order?"* |
| **Redis Cache** | Desync with PostgreSQL | PoF score drift detected (score delta > 0.15 between cache and DB) | Force re-query PostgreSQL; invalidate Redis cache for affected SKUs; temporary PoF penalty (all scores capped at 0.80) | Aura adds caveat: *"Let me double-check the hub on that one..."* |
| **SQLite-VEC (Device)** | Database corruption | SQLCipher integrity check fails on cold start | Wipe local DB; restore from encrypted cloud backup if available; reset to Day 1 if not | *"My local memory had an issue. I'm restoring from backup — give me a moment."* |
| **Payment Gateway** | All 3 cascade levels fail | Payment router exhausts all options within 16s timeout | Offer "Pay on Delivery" via Bio-Handshake terminal; order proceeds but flagged for manual review | *"All payment channels are struggling. I can dispatch and you pay at the door — the rider has a terminal."* |
| **BLE (Bio-Handshake)** | BLE unavailable on device | BLE capability check fails during Handshake Mode | Fall back to visual-only (camera reads color pulse); if visual fails, display 6-digit OTP | Color pulse only → then *"Show the rider this code: 847293"* |

### **5.4 Circuit Breaker Patterns**

* **Per-Component Breakers:** Each downstream service (Intent Engine, Nexus API, Payment Router) has an independent circuit breaker with a 5-failure threshold over 60 seconds. When tripped, the breaker opens for 30 seconds before attempting a half-open probe.
* **Cascade Prevention:** If the Intent Engine breaker is open, the Orchestrator does not attempt Nexus API calls (they depend on intent output). This prevents cascading timeouts from consuming session resources.
* **Client-Side Retry Budget:** The Flutter client is allocated a maximum of 3 retries per session for WebSocket reconnection. After exhaustion, the app enters full offline mode and surfaces the Offline Intent Buffer.

## **6\. Infrastructure & Adaptive Fidelity (Nigeria Context)**

To survive in the Nigerian market, the system must aggressively manage data and power.

### **6.1 Low-Bandwidth Mode (The Adaptive Pipeline)**

* **Trigger:** Network latency exceeds 500ms or drops to 3G.  
* **Action:**  
  * Morphing Viewport ceases fetching 4K parallax imagery.  
  * UI falls back to pre-cached, lightweight Vector Assets (SVG silhouettes).  
  * TTS switches to a lower bitrate stream.

### **6.2 Payment Routing (The Reliability Fallback)**

Due to frequent local bank API downtimes, Verve uses a **"Cascade Router."**

1. **Primary:** Paystack Card Tokenization.  
2. **Secondary (If Primary 5xx Error):** Flutterwave (or Monnify) Account Transfer integration.  
3. **Tertiary:** Verve Virtual Wallet (Pre-funded NGN balance).

### **6.3 Edge-AI Fallback (Offline Intent)**

If network connection drops entirely while the user is speaking, the app buffers the PCM audio locally. A lightweight on-device model determines if the intent is "Critical" (e.g., "Cancel Order") and queues it for immediate transmission the microsecond a ping returns.

## **7\. Multi-Hub Routing Policy**

As Verve scales beyond a single MFC per city, the system must address a fundamental logistics question: what happens when the nearest hub lacks 3 items in a user's basket but the next-nearest hub has them all?

### **7.1 V1.0 Policy: Single-Hub, No Splits**

In V1.0, Verve **never splits an order across multiple hubs.** The rationale is rooted in unit economics and the 15-minute promise:

* **Cost:** A split order requires two riders, doubling the delivery cost and breaking the margin model.  
* **Time:** Coordinating two rider arrivals to a single address within a 15-minute window is logistically untenable in Lagos/Abuja traffic.  
* **Trust:** Two separate deliveries for one order feels fragmented and erodes the "single trusted partner" brand promise.  
* **Aura's Behavior:** If 2+ items are unavailable at the user's primary hub, Aura transparently explains: *"Your hub is out of the fresh basil and the ricotta. I can swap both for alternatives, or stage the rest and you tell me when to try again for those two."* Aura never silently routes to a secondary hub.

### **7.2 V2.0 Future: Hub-to-Hub Transfer Protocol**

* A secondary hub can transfer stock to the primary hub via a dedicated "Inter-Hub Shuttle" (a scheduled hourly run between hubs in the same city).  
* This extends the fulfillment window to ~45 minutes but preserves single-rider delivery.  
* The user is informed: *"The ricotta is at the Lekki hub. I can have it shuttled to Wuse — adds about 30 minutes. Want me to wait for it?"*