# **Verve Nexus: Operations & Fulfillment Manual v1.0**

**Document Status:** Final (Operations Ready) **Date:** May 8, 2026 **Location:** Nigeria (Abuja/Lagos Operations)

## **1\. The Nexus Philosophy**

The Verve Nexus is the physical manifestation of the Aura AI. It is not merely a warehouse; it is the "Sensory Cortex" of the system. If Aura promises "crisp spinach," the Nexus is responsible for ensuring that promise is an absolute truth. We operate on a **Zero-Hallucination** mandate: if an item is not physically verified in the Hub, the AI cannot suggest it.

## **2\. Hub Topology & Layout (The Micro-Fulfillment Center)**

Verve MFCs (Dark Stores) are designed for speed, not human browsing. They are hyper-localized to serve a specific 3-5 kilometer radius.

### **2.1 Zone Architecture**

* **Zone Alpha (The Velocity Ring):** Located immediately adjacent to the Dispatch Bay. Stocks the top 50 highest-frequency items (e.g., Bottled Water, Milk, Bread, basic proteins). Designed for sub-60-second picking.  
* **Zone Beta (The Cold Chain):** Temperature-controlled environments (Chilled and Frozen). Mandatory IoT temperature logging every 5 minutes.  
* **Zone Gamma (The Pantry):** Ambient shelving for dry goods, canned items, and household supplies.  
* **Zone Omega (The Vault):** Secured area for high-value items (Premium spirits, electronics, specialized imported goods).

### **2.2 Operational Hardware**

* **Picker Wrist-Mounts:** Wearable Android devices running the "Verve Picker" app. Leaves both hands free.  
* **IoT Bag Sensors:** Reusable BLE temperature/humidity sensors clipped to insulated delivery bags.

## **3\. Human-Ops: Roles & Responsibilities**

### **3.1 The Nexus Lead (Hub Manager)**

The Nexus Lead is the ultimate authority in the hub and the "Human Bridge" for the user.

* **Morning Audit (6:00 AM):** Conducts a visual and tactile inspection of all highly perishable goods (Zone Beta). Adjusts the "Probability of Fulfillment" (PoF) base scores for the day.  
* **Exception Handling:** If Aura encounters an intent it cannot resolve, the Lead takes over the voice/chat interface.  
* **Inventory Override:** Manually updates the database if physical shrinkage (damage/theft) is discovered, preventing Aura from hallucinating stock.

### **3.2 The Sensory Picker**

Pickers are not just laborers; they are the physical validation layer of the AI.

* **The "Scan-to-Verify" Protocol:** Every item must be barcode-scanned before entering the tote.  
* **Quality Veto Power:** A Picker has the authority (and mandate) to reject an item if it looks damaged or substandard, instantly triggering a "Spoilage Swap" protocol for the user.

### **3.3 The Dispatch Rider**

* **Compliance:** Must maintain the integrity of the Cold Chain delivery bags.  
* **Execution:** Responsible for executing the "Bio-Handshake" at the delivery point to finalize the transaction.

## **4\. The 15-Minute Fulfillment Loop (SOP)**

Time is the primary metric of the Nexus. The target is 15 minutes from order confirmation to delivery within the geofenced zone.

* **T+0:00 (Order Lock):** Aura confirms the order. Inventory is hard-allocated in the GraphQL database.  
* **T+0:05 (Dispatch Ping):** The Picking Ticket is routed to the optimal Picker based on their current Zone location.  
* **T+3:00 (Picking Complete):** Picker scans the final item into the staging tote.  
* **T+4:00 (Bagging & Sensor Link):** Tote contents are transferred to the delivery bag. The IoT sensor is activated and linked to the specific Order ID.  
* **T+5:00 (Rider Handover):** Rider scans the bag tag, accepting custody.  
* **T+5:00 to T+14:00 (Transit):** Rider navigates via the optimal route determined by the GIS engine (accounting for current Lagos/Abuja traffic heatmaps).  
* **T+15:00 (The Handshake):** Rider arrives. Bio-Handshake protocol is executed.

## **5\. Contingency & Chaos Protocols**

In the Nigerian operating environment, chaos is guaranteed. The Nexus must handle it gracefully.

### **5.1 Protocol: The "Spoilage Swap"**

* **Trigger:** A Picker discovers the last unit of requested tomatoes is bruised.  
* **Action:**  
  1. Picker scans the item and taps "REJECT: QUALITY" on the wrist-mount.  
  2. The API instantly alerts the Go Orchestrator.  
  3. Aura interrupts the user (if still on the app) or sends a high-priority push: *"The Wuse hub's tomatoes didn't pass my freshness check. I've swapped them for premium cherry tomatoes at no extra cost. Okay?"*

### **5.2 Protocol: Gridlock / "Go-Slow" Alert**

* **Trigger:** The GIS routing engine detects severe traffic (e.g., unexpected checkpoint or accident) that will push delivery past T+25:00.  
* **Action:**  
  1. System calculates the revised ETA.  
  2. Aura proactively notifies the user: *"Tunde is caught in sudden traffic near the Secretariat. I've revised the ETA to 28 minutes. I've credited your Verve Wallet with N1,000 for the delay."*

### **5.3 Protocol: Power Grid Failure**

* **Trigger:** Loss of municipal power and primary backup generator failure at the MFC.  
* **Action:**  
  1. IoT sensors detect temperature rise in Zone Beta.  
  2. If Zone Beta temp exceeds safety thresholds for \> 15 minutes, the Nexus API automatically drops the "Probability of Fulfillment" (PoF) for all dairy/meat to zero.  
  3. Aura immediately stops suggesting these items to users in that hub's radius.

### **5.4 Protocol: Rider Device Failure**

* **Trigger:** Rider's phone dies, crashes, or loses BLE capability mid-delivery.  
* **Action:**  
  1. Orchestrator detects loss of rider GPS ping for > 3 minutes during active delivery.  
  2. Hub receives alert: "RIDER OFFLINE — Order #[ID]."  
  3. Bio-Handshake degrades: Visual-only color pulse (rider borrows any phone to load a web URL) → then 6-digit OTP displayed on user's screen with 60-second expiry → then verbal confirmation via hub callback as final resort.  
  4. If rider is unreachable for > 10 minutes, Nexus Lead dispatches a backup rider with a fresh bag.

### **5.5 Protocol: User Not Home**

* **Trigger:** Rider arrives at delivery coordinates; Bio-Handshake not initiated within 5 minutes.  
* **Action:**  
  1. Rider taps "RECIPIENT UNAVAILABLE" on the app.  
  2. Aura sends the user a high-priority push: *"Your rider Tunde is at your door. He'll wait 5 more minutes."*  
  3. If still no response at T+10 minutes: rider returns order to hub. Cold chain items re-enter Zone Beta. Dry goods held for 2 hours.  
  4. User receives: *"I've returned your order to the hub. It's on hold for 2 hours — just say 'resend' whenever you're ready. No extra charge."*

### **5.6 Protocol: Fleet Immobilization (Fuel Scarcity)**

* **Trigger:** Fuel scarcity events (periodic in Nigerian market) reduce available rider fleet below 40% capacity.  
* **Action:**  
  1. Nexus Lead manually triggers "FLEET CONSTRAINED" mode.  
  2. Aura adjusts all delivery promises: Priority 15-min becomes 30-min; Standard 30-min becomes 60-min.  
  3. Aura transparently communicates: *"Fuel is tight across Lagos today. Deliveries are running longer than usual — I've adjusted your ETA."*  
  4. Verve+ subscribers retain priority dispatch. Non-subscribers receive Verve+ trial offer during constraint.

### **5.7 Protocol: Hub Flooding (Rainy Season)**

* **Trigger:** Physical water ingress detected in any MFC zone (IoT humidity sensors or manual report from Nexus Lead).  
* **Action:**  
  1. Affected zones are instantly locked out of the PoF engine (all items in flooded zones score 0.0).  
  2. If Zone Alpha (Velocity Ring) is affected, the entire hub enters "REDUCED CAPACITY" mode.  
  3. Users in the hub radius receive: *"Your hub is operating at reduced capacity due to weather. Some items may be temporarily unavailable."*  
  4. Orders are not cancelled — they are held and fulfilled when the zone is cleared (typically 2-6 hours).

### **5.8 Protocol: Coordinated Fraud (Order-and-Cancel Attacks)**

* **Trigger:** Edge-ML Velocity model detects abnormal patterns: > 5 orders placed and cancelled within 30 minutes from a single account, or > 3 accounts ordering identical high-value items to the same GPS cluster within 10 minutes.  
* **Action:**  
  1. Flagged accounts enter "VERIFICATION HOLD" — all new orders require upfront Verve Wallet deduction (not card tokenization).  
  2. Bio-Handshake becomes mandatory for all flagged deliveries (no fallback to OTP).  
  3. Nexus Lead receives alert with full pattern context. Manual review within 1 hour.  
  4. Legitimate users affected by false positives receive a proactive apology and Verve Wallet credit: *"I had to verify that order — security protocol. Here's ₦1,000 for the inconvenience."*

### **5.9 Protocol: Picker Walkout Mid-Shift**

* **Trigger:** Active Picker goes offline during scheduled shift with pending picking tickets in queue.  
* **Action:**  
  1. Pending tickets are automatically redistributed to remaining Pickers based on current zone proximity.  
  2. If remaining Picker count falls below minimum threshold (2 per hub), Nexus Lead is paged and "REDUCED SPEED" mode activates — all new ETAs extended by 5 minutes.  
  3. Hub triggers emergency cross-training protocol: available Riders or Nexus Lead personnel can accept Picker tickets via a simplified "Emergency Pick" interface on their devices.

### **5.10 Protocol: National Holiday Surge**

* **Trigger:** Calendar-based (Eid, Christmas, Easter, Independence Day) + historical demand curve analysis.  
* **Action:**  
  1. 48 hours before the event, Nexus API auto-increases base inventory targets for Zone Alpha by 200% using historical demand data.  
  2. Aura proactively prompts frequent users 24 hours ahead: *"Eid is tomorrow — your usual order tends to spike. Want me to pre-stage and lock your items now?"*  
  3. During surge, PoF thresholds tighten (items below 0.90 confidence are not suggested) to prevent over-promising.  
  4. Additional Riders are pre-scheduled using a standby roster.

## **6\. The Rider's Reality**

The rider is not an API endpoint. The rider is a human navigating flooded roads, aggressive traffic enforcement, bridge closures, and the physical danger of carrying valuable goods through dense urban environments. The system must respect and protect them.

### **6.1 Device Requirements**

* Minimum: Android 10+, BLE 5.0, 4000mAh battery, GPS, rear camera.  
* Recommended: Rugged case with screen protector, handlebar phone mount rated for vibration.  
* Verve provides: Backup power bank (10,000mAh), docked at the hub between shifts. Rider swaps depleted bank for a charged one at shift start.

### **6.2 Shift Structure & Compensation**

* **Shift Duration:** Maximum 8 hours. Mandatory 30-minute break at the 4-hour mark (enforced by app — no new dispatches for 30 minutes).  
* **Compensation Model:**  
  * *Base guarantee:* ₦4,000/shift floor (regardless of delivery count).  
  * *Per-delivery bonus:* ₦300-500 per successful Bio-Handshake (distance-tiered).  
  * *Surge bonus:* 1.5x per-delivery rate during peak hours (11AM-2PM, 5PM-8PM) and holidays.  
  * *Perfect Week bonus:* ₦5,000 for zero rejected deliveries, zero complaints, and 100% on-time rate across 5+ shifts.

### **6.3 Route Safety Protocols**

* **Motorcycle Ban Zones:** The GIS engine hard-codes bridge and expressway restrictions (e.g., Third Mainland Bridge motorcycle ban in Lagos). Routes that require prohibited crossings are automatically rejected — even if the alternative is 10 minutes longer.  
* **Night Delivery Cutoff:** No deliveries dispatched after 9:00 PM (9:30 PM for Verve+ Priority). Rider safety supersedes user convenience.  
* **Weather Lockout:** If weather services report severe conditions (heavy flooding, visibility < 100m), all active deliveries are paused. Riders return to nearest hub. Users receive: *"Deliveries paused for rider safety. I'll resume the moment conditions clear."*

### **6.4 Emergency SOS Protocol**

* **Trigger:** Rider presses and holds the SOS button on their app (accessible from any screen) for 3 seconds.  
* **Action:**  
  1. Rider's live GPS is broadcast to the Nexus Lead dashboard.  
  2. Active delivery is frozen — payment not captured.  
  3. Hub contacts rider within 60 seconds. If unreachable, local emergency contacts are notified.  
  4. Affected user receives: *"Your delivery has been paused due to an unforeseen situation. Your order is safe at the hub — I'll re-dispatch as soon as possible."*