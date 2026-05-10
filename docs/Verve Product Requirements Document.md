# **Verve: Product Requirements Document (PRD) v1.0**

**Document Status:** Final (Engineering Ready) **Date:** May 8, 2026 **Target Market:** Nigeria (Abuja/Lagos Initial Launch)

## **1\. Product Vision & Market Context**

### **1.1 The Problem Space**

In the current Nigerian digital commerce landscape, shopping applications are high-friction utilities. Users must navigate cluttered grids, manage unreliable search functions, and endure significant cognitive load. Furthermore, the physical reality—traffic gridlocks, erratic power, and supply chain inconsistencies—creates an "Anxiety Gap" between the digital promise and the physical delivery.

### **1.2 The Verve Thesis**

Verve shifts the paradigm from "Shopping as a Task" to "Provisioning as a Service." It replaces the digital storefront with **Aura**, an Intent-Agent. Users do not browse; they converse. Verve acts as a Cognitive Commerce Layer, abstracting the chaos of retail into a single, high-trust digital relationship powered by localized Micro-Fulfillment Centers (MFCs).

### **1.3 Target Personas**

* **Persona A: The Exhausted Executive (Alex):** High disposable income, severe time poverty. Values speed and reliability over discounts. Frustrated by scrolling through 50 types of milk.  
* **Persona B: The Context-Heavy Household Manager (Sarah):** Manages complex family dietary needs. Cooks based on what is already in the fridge. Needs an agent that remembers past purchases to avoid waste.

### **1.4 The Cold Start Problem (Day 1 Reality)**

The "Zero-Click Priority" is a promise that can only be fulfilled *after* Aura has accumulated context. On Day 1, a new user has zero memory vectors, no purchase history, no dietary profile, and no reason to trust an AI agent with intimate domestic data. The first five interactions determine whether the user stays or churns.

* **The Bootstrap Dialogue:** During first launch, Aura initiates a guided 90-second voice conversation — not an interrogation, but a conversational calibration. *"Welcome to Verve. I'm Aura. Before I can provision your life, I need to understand it. Quick question — how many people eat in your household?"* This extracts: household size, primary dietary restrictions, preferred protein categories, and one "test order" to prove the system works.  
* **The First Provisioning Event:** Rather than presenting an empty Void, Aura curates a "Neighborhood Starter Basket" — the 10 most-ordered items from the user's assigned MFC, filtered by any dietary restrictions captured in the Bootstrap. This demonstrates immediate value with zero prior data.  
* **The Predictive Pantry on Day 1:** Instead of showing an empty forecast, the Pantry displays "Popular in Your Area" items with a subtle label: *"Based on your hub. Aura will personalize this within 3 orders."*  
* **The Trust Escalation:** Aura does not ask for delivery address or payment until *after* demonstrating competence. The first interaction ends with a completed Draft Basket — not a checkout. Payment is requested only when the user actively says "dispatch."

### **1.5 Revenue Architecture (Proposed)**

Verve's commercial viability depends on multiple revenue streams that align incentives with user value:

* **Delivery Fee (Per Event):**  
  * *Standard (30 min):* ₦500-800 (distance-tiered within the 5km radius)  
  * *Priority (15 min):* ₦1,200-1,500 (guaranteed velocity ring routing)  
* **Verve+ Subscription (Monthly):**  
  * ₦9,500/month — Unlimited standard deliveries, priority picking during peak hours, extended hub operating hours (6AM-11PM vs. 7AM-9PM), and dedicated Nexus Lead access.  
  * Conversion thesis: After 4+ deliveries/month, the subscription becomes cheaper than per-event fees. Aura surfaces this naturally: *"You've ordered 5 times this month. Verve+ would have saved you ₦3,200."*  
* **MFC Commission Model:**  
  * Fresh produce: 15-20% margin (high spoilage risk = higher margin)  
  * Dry goods / household: 8-12% margin  
  * Premium / imported: 25-30% margin (Zone Omega items)  
* **Verve Wallet Float:** Pre-funded wallet balances earn overnight interest on aggregate float, creating a micro-treasury revenue stream.  
* **B2B Data (Anonymized):** Aggregated, anonymized demand signals sold to FMCG brands — *"Demand for oat milk in Lekki Phase 1 increased 340% this quarter."* No PII. Ever.

## **2\. Core Product Principles (Engineering Guardrails)**

1. **Zero-Click Priority:** The UI must optimize for voice-first resolution. If a recurring or simple order requires more than two screen taps, the UX has failed.  
2. **Graceful Degradation:** The application must remain functional (intent capture and fulfillment) under 3G network conditions and sub-15% battery levels.  
3. **Total Transparency (Zero Hallucination):** The Aura AI must never suggest an item that is not physically confirmed in the local MFC. "Probability of Fulfillment" must dictate all agent responses.  
4. **Local-First Privacy:** Intimate context (diet, habits, voice patterns) is processed and stored on-device first (SQLite-VEC).

## **3\. Detailed Feature Specifications**

### **3.1 The Aura VUI (Voice User Interface)**

The core interaction layer replacing traditional search.

* **Trigger:** User taps the "Breathing Wave" or uses the wake-word (optional).  
* **Action:** \* Captures PCM audio, streams to intent engine.  
  * Translates natural language (including Nigerian English/Pidgin nuances) into structured JSON queries.  
  * Generates a text-to-speech (TTS) response using the "Aura" persona (calm, partner-speak, dry wit).  
* **State Machine (UI Indicator):**  
  * *Idle:* Slow teal pulse.  
  * *Listening:* Expanded, reactive waveform.  
  * *Processing:* Rapid, shallow amber ripple.  
  * *Speaking:* Synchronized waveform matching TTS output.  
* **Acceptance Criteria:** Voice-to-intent latency must be \< 800ms.  
* **Edge Cases:**  
  * *Network Drop:* App switches to "Offline Intent Capture," buffers audio locally, and resumes instantly upon reconnection.  
  * *Unintelligible Input:* Aura responds: "I lost the connection there, did you say you needed the spinach?" (Never a generic error beep).

### **3.2 The Morphing Viewport (Dynamic Visuals)**

The upper 60% of the screen acts as a fluid canvas, eliminating page loads.

* **Trigger:** UI-Metadata payload received from the backend synchronized with the TTS stream.  
* **Action:** Transitions the UI state using Flutter Impeller (120fps target).  
* **States:**  
  * *Hero Product View:* High-res 2D image with parallax gyroscope tilt.  
  * *Proposal Card:* A structured list (e.g., "15-Min Dinner Kit") with Vitality Scores.  
  * *GIS Map Layer:* Real-time vector map tracking the rider.  
  * *Frosted Receipt:* Semi-transparent financial breakdown.  
* **Acceptance Criteria:** UI transitions must occur within 50ms of the corresponding word spoken by Aura.  
* **Edge Cases:** If a high-res image fails to load within 200ms, the UI must gracefully fallback to a pre-cached Vector Silhouette without stuttering.

### **3.3 Verve Insight & Memory (Agentic Logic)**

The RAG (Retrieval-Augmented Generation) brain of the application.

* **Trigger:** User makes a contextual request (e.g., "Use the spinach from Monday").  
* **Action:**  
  * Queries local SQLite-VEC for the "Spinach" purchase vector.  
  * Applies the user's global dietary constraints (e.g., "No Dairy").  
  * Cross-references with live MFC inventory.  
* **Acceptance Criteria:** Must successfully link temporal references ("Monday," "Last week") to specific SKUs in the user's order history.  
* **Edge Cases:** If a user requests a recipe requiring an item they are allergic to (based on profile), Aura must intercept: "That recipe calls for peanuts, which are on your blocklist. Should I swap for almonds?"

#### **3.3.1 Ambiguity Resolution (The Aura Hypothesis Pattern)**

Humans are not rational query engines. They are tired, contradictory, and emotionally variable. Aura must handle vagueness without resorting to open-ended interrogation.

* **Vague Intent:** User says *"I dunno, something nice for tonight."* → Aura does not ask "What do you mean?" Instead, Aura synthesizes: day-of-week purchase patterns + current weather + time of day + fridge depletion model → *"It's Thursday evening, you usually do something light mid-week. I've staged a grilled chicken salad with the avocados from Monday. Want me to dispatch?"*  
* **Contradictory Signals:** User says *"Something healthy"* but purchase history shows frequent snack orders. → Aura does not judge or reference the contradiction. It proposes a plausible middle ground: *"I've got a protein bowl with the brown rice you liked. Also staged some dark chocolate — 70% cacao, so it counts."*  
* **Emotional Brevity:** User responds with terse, monosyllabic commands ("Yes." "Fine." "Whatever.") → Aura detects low-engagement state, becomes *more* decisive and *less* chatty. Reduces verbal output by 50%. No humor. Pure execution.  
* **The Anti-Interrogation Rule:** Aura may ask a maximum of **one** clarifying question per intent. If the answer is still ambiguous, Aura must commit to a hypothesis and act — the user can always reject. Propose, don't interrogate.

### **3.4 Verve Nexus & Logistics Integration**

The physical fulfillment tether.

* **Trigger:** Order confirmation by user.  
* **Action:**  
  * Locks inventory in the MFC via API.  
  * Dispatches order to Picker app.  
  * Initiates ETA tracking based on local traffic heatmaps.  
* **Bio-Handshake Feature:** Upon rider arrival, the app generates a synchronized color-pulse and encrypted Bluetooth LE token exchange with the rider's device.  
* **Acceptance Criteria:** Inventory sync latency between MFC database and App must be \< 2 seconds.  
* **Edge Cases:** \* *Damaged Item Found:* Picker flags item in MFC. Aura immediately interrupts the user: "The last batch of tomatoes doesn't look great. I'm swapping them for cherry tomatoes, no extra charge. Okay?" (The Human Bridge).

### **3.5 The Personal Guardian (Privacy Dashboard)**

* **Trigger:** User navigates to Settings \-\> Guardian.  
* **Action:** Displays all semantic memories extracted by Aura.  
* **Features:** Single-tap "Purge Context" button to wipe the local SQLite-VEC database.  
* **Acceptance Criteria:** Purge action must permanently delete local vectors and send a deletion cascade command to the encrypted cloud backup within 500ms.

## **4\. System Constraints & Requirements (Non-Functional)**

### **4.1 Performance & Hardware**

* **Cold Start:** App launch to "Idle Wave" state \< 1.5 seconds.  
* **UI Frame Rate:** Strictly 60fps minimum; target 120fps on capable devices.  
* **Battery Drain:** Active "Provisioning Event" (5 mins of voice \+ UI morphing) must consume \< 2% of total device battery.

### **4.2 Data & Connectivity (Adaptive Fidelity)**

* **Standard Mode (4G/5G/WiFi):** Full High-Res Parallax images, complex Wave rendering.  
* **Low-Bandwidth Mode (3G/Edge):** Max payload \< 2MB per session. UI limits to Vector Silhouettes and basic state cards.

### **4.3 Payments & Compliance**

* **Gateways:** Multi-gateway fallback required (Paystack primary, Flutterwave secondary, Verve Wallet tertiary).  
* **Compliance:** Full adherence to NDPA (Nigeria Data Protection Act). Zero raw audio stored on cloud servers post-transcription.

### **4.4 Failure Tolerance Thresholds**

The system must not merely function under ideal conditions — it must define acceptable degradation boundaries for real-world chaos.

| Metric | Target | Tolerance | Consequence of Breach |
| :---- | :---- | :---- | :---- |
| LLM Hallucination Rate | 0% | < 0.1% (1 in 1,000 suggestions) | Forced PoF re-verification before display |
| Inventory Desync Window | Real-time | < 120 seconds | Hard-block checkout; trigger manual Picker verification |
| Payment Cascade Total Timeout | 8 seconds | < 16 seconds (across all 3 gateways) | Offer "Pay on Delivery via Bio-Handshake" as final fallback |
| Voice-to-Intent Round Trip | < 800ms | < 1,500ms | Display "Aura is thinking..." with cached contextual suggestion |
| Bio-Handshake Resolution | < 3 seconds | < 10 seconds | Fall back to visual-only verification (no BLE) |
| Purge Protocol Execution | < 500ms | < 2 seconds | Log failure and retry; alert user if cloud deletion unconfirmed |
| Rider ETA Accuracy | ±2 minutes | ±5 minutes | Proactive user notification + ₦500 wallet credit for delays > 5 min |

## **5\. Telemetry & Analytics**

* **Primary Metric:** Cognitive Load Index (CLI) \= Total Time to Cart / Number of Voice Turns.  
* **System Health Tracking:**  
  * LLM Intent Failure Rate (Fallback to manual input).  
  * MFC Inventory Desync Rate (Order placed but item physically missing).  
  * Bio-Handshake success/failure rate at the door.  
* **Privacy Rule:** Analytic payloads must be anonymized and stripped of all specific user prompts or item names.

## **6\. Release Phasing**

* **Phase 1 (Alpha \- Lab Environment):** \* Scope: SQLite-VEC local memory, Aura text-to-speech loop, mocked inventory API.  
* **Phase 2 (Beta \- Single Hub, Lagos/Abuja):** \* Scope: Live MFC connection, Flutter Impeller Morphing Viewport, Paystack integration, Human-Bridge protocol active.  
* **Phase 3 (V1.0 \- Public Launch):** \* Scope: Full Adaptive Fidelity algorithms, Bio-Handshake delivery protocol, Multi-hub routing.