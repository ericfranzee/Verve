# **Verve: System Architecture Specification v1.0**

**Document Status:** Final (Engineering Ready) **Date:** May 8, 2026 **Location:** Nigeria (Abuja/Lagos Operations)

## **1\. Architectural Philosophy**

Verve is engineered around three core constraints inherent to the operating environment:

1. **Network Volatility:** High latency and frequent drops require Edge-first processing and aggressive caching.  
2. **Trust Deficit:** Payment failure rates and supply chain opacity demand multi-gateway fallbacks and "Zero Hallucination" inventory tracking.  
3. **Device Constraints:** Heavy UI and AI workloads must be optimized to prevent extreme battery drain on mid-tier mobile hardware prevalent in the market.

To solve this, Verve utilizes a **"Thin Client, Thick Edge, Orchestrated Cloud"** model.

## **2\. Global Architecture Diagram (Conceptual)**

`[ Mobile App (Flutter/Edge AI) ] <== WebSocket / HTTP/2 ==> [ Orchestrator (Go) ]`  
        `|       |                                               |       |`  
`[SQLite-VEC] [Secure Enclave]                                   |       |`  
                                                                `v       v`  
                                               `[ Intent Engine (Python/RAG) ] <-> [ Cloud LLM ]`  
                                                                `|`  
                                                                `v`  
                                               `[ Nexus API (Node.js/GraphQL) ]`  
                                                                `|`  
                                             `-----------------------------------`  
                                             `|                                 |`  
                                    `[ Micro-Hub 1 (Abuja) ]           [ Payment Cascade ]`  
                                    `- Inventory DB                    - Paystack (Primary)`  
                                    `- Picker App (IoT)                - Flutterwave (Secondary)`

## **3\. Component Deep-Dive**

### **3.1 The Client (Flutter Mobile Application)**

* **Framework:** Flutter (Dart).  
* **Rendering Engine:** Impeller (Mandatory for 120fps UI state morphing without jank).  
* **State Management:** Riverpod (handles complex asynchronous streams from the Orchestrator).  
* **Audio Pipeline:** Native C++ audio bridge via FFI (Foreign Function Interface) to handle low-latency PCM capture and TTS playback, bypassing standard Flutter plugin latency.  
* **Edge Intelligence:** TFLite (TensorFlow Lite) models running quantized on-device for basic wake-word detection, "Velocity" state detection, and network-drop buffering.

### **3.2 The Orchestrator (Middleware Gateway)**

The traffic cop of the Verve ecosystem.

* **Language:** Go (Golang) for maximum concurrency and low memory footprint.  
* **Protocol:** Bi-directional WebSockets (or HTTP/2 gRPC streams) maintaining persistent connections with the client.  
* **Function:**  
  * Receives raw audio and routes it to the Transcription service.  
  * Maintains the "Session State" (is the user browsing, paying, or waiting?).  
  * Packages the final LLM response with the **UI-Metadata Tags** (The Visual Synapse payload) and sends it back to the client.

### **3.3 The Intent Engine (Agentic RAG)**

The "Brain" that powers the Aura persona.

* **Language:** Python (FastAPI).  
* **Transcription:** Custom fine-tuned Whisper model capable of parsing Nigerian English, local slang, and Pidgin.  
* **LLM Pipeline:** A Mixture of Experts (MoE) approach. Uses a fast, smaller model for simple routing (e.g., "Where is my order?") and a larger model for complex reasoning (e.g., "Create a 15-min keto meal using my fridge leftovers").  
* **Vector Search:** Performs semantic similarity searches against the user's localized SQLite-VEC data (synced via cloud) to inject "Intimate Context" into the LLM prompt.

### **3.4 The Nexus API (Logistics & Inventory)**

* **Framework:** Node.js \+ GraphQL.  
* **Database:** PostgreSQL (Transactional) \+ Redis (In-memory caching for live stock).  
* **Function:** Exposes the "Dark Store" inventory to the Intent Engine.  
* **The PoF Engine:** Calculates the "Probability of Fulfillment" score based on the last physical scan of an item vs. historical spoilage rates.

## **4\. Data Flow & Event Sequences**

### **4.1 The "Provisioning Event" (Core Loop)**

1. **User Input:** Voice captured \-\> chunked \-\> streamed via WebSocket.  
2. **Transcription:** Orchestrator converts audio to text string.  
3. **Context Assembly:** Intent Engine queries User Profile (Allergies) \+ Local Hub Inventory (What's available in Abuja Wuse Hub).  
4. **Prompt Construction:** The prompt is formed: *"User wants high protein dinner. User hates fish. Wuse Hub has Chicken and Beef in stock. Formulate response and UI tags."*  
5. **LLM Inference:** Generates TTS string and JSON UI Payload.  
6. **Client Render:** App plays audio and simultaneously triggers the HeroTransition widget to display the Chicken on screen.

### **4.2 The "Bio-Handshake" (Delivery Verification)**

1. **Proximity:** Rider enters the 50-meter geofence of the user's location.  
2. **Trigger:** Orchestrator pushes a "Handshake Ready" payload via WebSocket to both User and Rider apps.  
3. **Visual Sync:** Apps generate a synchronized color code (e.g., \#008080) based on a shared Time-based One-Time Password (TOTP) seed.  
4. **Hardware Sync:** Apps exchange a cryptographic payload via Bluetooth Low Energy (BLE).  
5. **Resolution:** Payload validated by Orchestrator; order marked complete; payment finalized.

## **5\. Resilience & Fallback Architectures**

### **5.1 Payment Routing (The Cascade)**

To counter the high failure rate of local bank APIs (NIP downtime):

* **Service:** A dedicated microservice (verve-pay-router).  
* **Logic:**  
  1. Attempt tokenized charge via Primary Gateway (e.g., Paystack).  
  2. If 5xx Error or timeout (\>4s), automatically fall back to Secondary Gateway (e.g., Flutterwave) using the same tokenized schema if supported, or prompt user for seamless "Pay via Transfer" modal.  
  3. If both fail, offer Verve Wallet deduction or "Pay on Delivery via Bio-Handshake Terminal."

### **5.2 Adaptive Fidelity (The Data Saver)**

* **Network Monitor:** A background isolate in Flutter constantly measures ping to the Orchestrator.  
* **Threshold:** If ping \> 400ms or connection drops to 3G.  
* **Action:** App sends low\_bandwidth\_flag: true to Orchestrator.  
* **Result:** Orchestrator strips high-res image URLs from the UI-Metadata payload, replacing them with local asset paths to Vector SVG files.

## **6\. Security & Compliance Architecture**

* **Data at Rest (Device):** SQLite-VEC database is encrypted using SQLCipher, with keys managed by the Android Keystore / iOS Secure Enclave.  
* **Data in Transit:** TLS 1.3 mandated for all WebSocket and REST communication.  
* **PII Separation:** The Orchestrator strips Personally Identifiable Information (Names, exact GPS) before sending transcripts to the Cloud LLM.  
* **Compliance:** Full compliance with NDPA (Nigeria Data Protection Act). Data localization rules are met by hosting primary transactional databases on AWS af-south-1 or localized Azure instances.

## **7\. Observability & Operational Health**

An architecture this distributed — spanning on-device SQLite, Go middleware, Python AI, and Node.js logistics — is only as reliable as its visibility. Without observability, failure is silent and diagnosis is guesswork.

### **7.1 Metrics Pipeline**

* **Infrastructure:** Prometheus (metrics collection) + Grafana (dashboards) + Loki (log aggregation).  
* **Per-Component Metrics:**
  * *Go Orchestrator:* Active WebSocket connections, session duration P95, audio buffer queue depth, PII stripping latency.
  * *Intent Engine:* LLM inference latency (P50/P95/P99), Whisper transcription confidence distribution, RAG retrieval hit rate, cache hit rate.
  * *Nexus API:* PoF query latency, inventory desync count (Redis vs. PostgreSQL drift), order lock-to-dispatch time.
  * *Payment Router:* Per-gateway success rate, cascade depth (how often secondary/tertiary is needed), total payment resolution time.
  * *Client (via telemetry):* Cold start time, frame rate during Morphing Viewport transitions, battery consumption per session, crash-free session rate.

### **7.2 Alerting Thresholds**

| Metric | Warning | Critical | Action |
| :---- | :---- | :---- | :---- |
| LLM P95 Latency | > 3s | > 5s | Page on-call; enable cached-suggestion fallback |
| WebSocket Error Rate | > 2% | > 5% | Page on-call; check Orchestrator health |
| Payment Cascade Depth | > 1.5 avg (secondary used often) | All-gateway failure > 1% | Alert finance team; check NIP status |
| PoF Desync Rate | > 3% of queries | > 8% of queries | Force Redis invalidation; alert Nexus Lead |
| Client Crash Rate | > 0.5% sessions | > 2% sessions | Halt rollout; investigate device-specific failures |

### **7.3 Distributed Tracing**

* **Protocol:** OpenTelemetry (OTLP) with Jaeger backend.  
* **Trace Propagation:** Every user intent generates a trace ID at the Flutter client, propagated through WebSocket headers to the Orchestrator, Intent Engine, and Nexus API. The full lifecycle of a "Provisioning Event" — from voice capture to payment finalization — is traceable as a single distributed transaction.  
* **Sampling:** 100% of error traces retained; 10% of successful traces sampled for performance baseline.