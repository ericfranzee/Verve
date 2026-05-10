# **Verve: Build Strategy & Roadmap v1.0**

**Document Status:** Final (Execution Ready) **Date:** May 8, 2026 **Location:** Nigeria (Abuja/Lagos Operations)

## **1\. Executive Strategy**

The Verve build strategy is organized around a philosophy of **"Progressive Complexity."** We do not build the entire ecosystem at once. We validate the hardest technical risks first (Voice-to-UI latency and Local Memory) before investing in heavy physical infrastructure (Dark Stores).  
The roadmap is divided into Four Phases, moving from a Lab Prototype to a Public Launch in Lagos/Abuja.

## **2\. Phase 1: The "Invisible Intelligence" (Weeks 1-4)**

**Goal:** Prove the core AI hypothesis. Can we build a fast, voice-first agent that remembers context locally? **Focus:** RAG Architecture, SQLite-VEC, and Basic Intent Extraction.

### **Key Milestones:**

* **Week 1 (Infrastructure Setup):**  
  * Deploy Go Orchestrator (WebSocket handling).  
  * Initialize Python FastAPI Intent Engine with basic Whisper (TTS) and LLM endpoints.  
* **Week 2 (The Memory Vault):**  
  * Integrate SQLite-VEC into the basic Flutter client.  
  * Build the CRUD operations for local embeddings (saving/retrieving "Intimate Context").  
* **Week 3 (The Brain):**  
  * Develop the RAG prompt pipeline. Ensure the LLM can accurately answer: *"What did I order last Monday?"* based solely on the local vector database.  
* **Week 4 (The Voice Loop):**  
  * Establish the full round-trip: Voice Capture (App) \-\> Transcription (Orchestrator) \-\> Inference (Engine) \-\> TTS Playback (App).  
  * *Metric:* Achieve round-trip latency of \< 1.2 seconds.

## **3\. Phase 2: The "Visual Stage" (Weeks 5-8)**

**Goal:** Prove the UX hypothesis. Can we build a UI that feels like magic (Zero-Click, High-Fidelity) without draining the battery? **Focus:** Flutter Impeller, Morphing Viewport, UI-Metadata Sync.

### **Key Milestones:**

* **Week 5 (The Stage & State):**  
  * Implement Flutter Riverpod for complex state management.  
  * Build the base "Morphing Viewport" widget stack (Hero Cards, Maps, Receipts).  
* **Week 6 (The Visual Synapse):**  
  * Modify the Intent Engine to output JSON UI-Metadata alongside the TTS text.  
  * Build the Flutter parser to trigger UI transitions based on audio timestamps.  
* **Week 7 (The Aura Identity):**  
  * Implement the "Breathing Wave" animations (Idle, Listening, Processing) using low-overhead shaders.  
  * Integrate Haptic feedback (Light Tap, Medium Thud) tied to UI events.  
* **Week 8 (Adaptive Fidelity):**  
  * Build the network monitoring isolate.  
  * Implement the fallback logic (High-Res Parallax vs. Vector Silhouettes) based on ping/bandwidth.

## **4\. Phase 3: The "Nexus Pilot" (Weeks 9-14)**

**Goal:** Prove the physical hypothesis. Can we connect the AI to a real-world inventory and fulfill an order? **Focus:** Partner Integration, Inventory Polling, and the Rider App.

### **Key Milestones:**

* **Week 9 (The Hub API):**  
  * Build the Node.js/GraphQL Nexus API.  
  * Establish a mock (or partner) database representing a single Micro-Fulfillment Center (MFC) in Lagos or Abuja.  
* **Week 10 (Probability of Fulfillment \- PoF):**  
  * Implement the PoF algorithm. The Intent Engine must now query the Nexus API before making a suggestion.  
* **Week 11 (The Payment Cascade):**  
  * Integrate Paystack (Primary) and Flutterwave (Secondary).  
  * Build the fallback router to handle NIP (bank transfer) downtimes gracefully.  
* **Week 12 (The Rider Pulse App):**  
  * Build a lightweight Flutter app for dispatch riders (GPS pinging, basic order details).  
* **Week 13 & 14 (The Bio-Handshake):**  
  * Develop the Bluetooth LE / Visual Color-Pulse protocol between the User App and Rider App.  
  * *Metric:* Successfully execute 50 closed-beta "Provisioning Events" from voice command to physical delivery.

## **5\. Phase 4: "Guardian & Scale" (Weeks 15-20)**

**Goal:** Harden the system for public launch, ensuring legal compliance and operational resilience. **Focus:** Privacy Dashboard, Human-Ops, and Public Release.

### **Key Milestones:**

* **Week 15 (The Guardian Vault):**  
  * Build the user-facing privacy dashboard.  
  * Implement the "Purge Memory" kill-switch (wiping local SQLite-VEC and sending cloud-delete webhooks).  
* **Week 16 (The Human Bridge):**  
  * Build the "Nexus Lead" dashboard for hub managers.  
  * Implement the handover protocol allowing a human to take over the Aura chat/voice stream.  
* **Week 17 (Security & NDPA Compliance):**  
  * Full penetration testing of the Go Orchestrator.  
  * Audit data localization rules to ensure Nigerian PII compliance.  
* **Week 18-20 (Soft Launch & Tuning):**  
  * Release to a geo-fenced waitlist in one specific high-density neighborhood (e.g., Wuse II, Abuja or Lekki Phase 1, Lagos).  
  * Tune the LLM prompts based on real-world "Nigerian Nuance" and edge-case behaviors.

## **6\. Resource Allocation & Team Structure**

To execute this roadmap, the following "Pods" are required:

* **Pod 1: Core Intelligence (AI/Backend):** 1x Lead Python/AI Engineer, 1x Go Orchestrator Engineer.  
* **Pod 2: The Stage (Frontend):** 2x Senior Flutter Developers (focus on animations/FFI).  
* **Pod 3: The Nexus (Physical Ops):** 1x Full-Stack Node.js Engineer, 1x Logistics/Operations Manager.  
* **Shared Resources:** 1x UI/UX Brand Designer, 1x Product Owner.

## **7\. Risk Register**

The "Progressive Complexity" strategy is designed to surface risks early. But risks must be explicitly named, not discovered by accident.

### **7.1 Technical Risks**

| Risk | Probability | Impact | Mitigation |
| :---- | :---- | :---- | :---- |
| LLM latency exceeds 1.2s round-trip under load | High | Critical — breaks the "instant partner" illusion | MoE routing: fast small model for simple intents (< 200ms), large model only for complex reasoning |
| Whisper accuracy for Nigerian Pidgin < 85% | Medium | High — users abandon if misunderstood repeatedly | Pre-fine-tune on 50+ hours of labeled Nigerian English/Pidgin corpus before Phase 1 Week 4 |
| Flutter Impeller stability on Samsung mid-tier devices | Medium | High — Samsung dominates Nigerian market share | Maintain Canvas fallback renderer; test on Galaxy A14/A25 (most common devices in target market) |
| SQLite-VEC performance degrades past 10,000 vectors per user | Low | Medium — affects power users after ~6 months | Implement temporal decay pruning: vectors older than 90 days with zero reinforcement are archived to cloud |
| GLSL shader jank on devices with Mali GPU | Medium | Medium — Breathing Wave is the primary UI element | Ship two shader variants: full (Adreno/Apple) and simplified (Mali). Auto-detect on cold start. |

### **7.2 Operational Risks**

| Risk | Probability | Impact | Mitigation |
| :---- | :---- | :---- | :---- |
| Hub lease negotiations in Lagos exceed budget | High | Critical — no hub = no physical fulfillment | Negotiate 3 backup locations per target zone before committing to Phase 3 |
| Rider recruitment insufficient for 15-min SLA | Medium | High — broken delivery promises destroy trust | Partner with existing logistics platforms (Gokada, MAX.ng) as rider supply backup |
| NEPA power reliability at MFC < 95% uptime | High | Medium — Zone Beta cold chain depends on stable power | Mandatory dual-generator backup + IoT auto-failover. Budget for diesel reserves. |
| Picker quality inconsistency | Medium | High — spoiled items reaching users destroys the "Zero Hallucination" brand | Gamified quality scoring: Pickers with > 98% quality rate get priority shifts and bonuses |

### **7.3 Market Risks**

| Risk | Probability | Impact | Mitigation |
| :---- | :---- | :---- | :---- |
| Competitor launches similar service during build | Medium | Medium — first-mover advantage is marginal | Verve's moat is the edge-AI + local memory architecture, not the delivery itself. Competitors cannot replicate the Trust Ladder and Zero-Knowledge Intimacy easily. |
| Regulatory change (NDPA tightening) | Low | High — could require re-architecture of data flows | Guardian Protocol already exceeds current NDPA requirements. Architecture is designed for GDPR-level compliance. |
| Consumer trust deficit too deep for voice-AI adoption | Medium | Critical — users refuse to speak to an AI | Text-first fallback is always available. Phase 4 soft launch will measure voice vs. text adoption ratio. If text > 80%, re-weight the UI toward hybrid. |

## **8\. Success Metrics by Phase**

Each phase has explicit, measurable gates. A phase is not "complete" until its metrics are validated.

### **Phase 1: Invisible Intelligence**

| Metric | Target | Measurement Method |
| :---- | :---- | :---- |
| Voice-to-TTS round trip | < 1.2 seconds (P95) | End-to-end trace timing in staging environment |
| RAG recall accuracy | > 90% for temporal queries ("last Monday") | Test suite of 100 synthetic user histories with known answers |
| SQLite-VEC query latency | < 50ms for top-5 similarity search on 1,000 vectors | On-device benchmark on Galaxy A14 (baseline target device) |
| Whisper transcription accuracy (Nigerian English) | > 90% word-level accuracy | Evaluation against 500-sentence labeled test set |

### **Phase 2: The Visual Stage**

| Metric | Target | Measurement Method |
| :---- | :---- | :---- |
| UI frame rate during Morphing Viewport | > 60fps sustained (120fps target) | Flutter DevTools performance overlay on 5 target devices |
| Cold start to Idle Wave | < 1.5 seconds | Automated test on clean install |
| Battery consumption per 5-min Provisioning Event | < 2% total battery | Battery profiling on Galaxy A25 |
| Visual Synapse sync accuracy | UI transition within 50ms of corresponding audio word | Manual QA with slow-motion screen recording |
| Adaptive Fidelity activation | Correctly triggers on simulated 3G (400ms+ latency) | Network throttling test suite |

### **Phase 3: The Nexus Pilot**

| Metric | Target | Measurement Method |
| :---- | :---- | :---- |
| Successful closed-beta deliveries | 50 minimum | Manual tracking with full trace logs |
| PoF accuracy (predicted vs. actual availability) | > 95% | Compare Aura suggestions against physical Picker verification |
| Payment cascade success rate | > 99% (across all gateway fallbacks) | Transaction logs across 200+ test payments |
| Bio-Handshake success rate | > 95% at Level 0 (full BLE) | Field testing across 10 device model combinations |
| Order-to-delivery time (within 5km radius) | < 15 minutes (P80) | GPS timestamping from order lock to handshake |

### **Phase 4: Guardian & Scale**

| Metric | Target | Measurement Method |
| :---- | :---- | :---- |
| NPS (Net Promoter Score) | > 70 | In-app survey after 5th delivery |
| DAU retention at 30 days | > 40% | Analytics dashboard |
| NDPA compliance audit | Zero violations | Third-party compliance audit |
| Trust Ladder progression | > 60% of users reach Level 2 within 30 days | Guardian Vault analytics |
| Human Bridge escalation rate | < 5% of sessions | Intent Engine failure tracking |
| Purge Protocol execution success | 100% within 2 seconds | Automated QA suite |