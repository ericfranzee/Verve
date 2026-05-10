# **Verve Guardian: Privacy & Security Protocol v1.0**

**Document Status:** Final (Compliance Ready) **Date:** May 8, 2026 **Location:** Nigeria (Abuja/Lagos Operations)

## **1\. The Guardian Philosophy: "Privacy as a Premium"**

In 2026, data anxiety is a primary friction point for high-net-worth consumers. The **Verve Guardian** protocol positions privacy not as a legal afterthought, but as a core competitive advantage.  
The mandate is **Zero-Knowledge Intimacy.** Aura must know the user deeply enough to manage their life, but the system architecture must guarantee that Verve (the corporation) cannot exploit, sell, or independently access that intimate data.

## **2\. Architectural Security (Data at Rest & In Transit)**

### **2.1 The "Local-First" Memory Vault**

* **Implementation:** SQLite-VEC combined with SQLCipher.  
* **Mechanism:** All "Intimate Context" (dietary restrictions, recent voice transcripts, daily routines) is processed into vector embeddings and stored *on the user's physical device.*  
* **Encryption:** The SQLite database is encrypted using a unique 256-bit AES key generated and stored inside the device’s hardware-backed Secure Enclave (iOS) or Android Keystore.  
* **Cloud Sync (Opt-In):** If the user opts for multi-device sync, the local vectors are encrypted *before* being sent to the Verve Cloud. Verve servers hold the encrypted blobs but do not hold the decryption keys.

### **2.2 Network Security**

* **Protocol:** All communication between the Flutter client and the Go Orchestrator occurs over **TLS 1.3** via WebSockets or HTTP/2.  
* **Audio Ephemerality:** PCM audio streamed for transcription is held in volatile memory (RAM) only. It is transcribed, passed to the Intent Engine, and immediately purged. **No raw audio is ever written to disk on Verve servers.**

## **3\. The Privacy Dashboard (User Control)**

Transparency is operationalized through the "Guardian Dashboard" located in the app settings.

### **3.1 "Algorithmic Transparency" (The "Why This?" Feature)**

* Every time Aura makes a suggestion (e.g., proposing Salmon instead of Beef), the user can tap the "Verve Guardian" icon next to the suggestion.  
* The app will display a human-readable ledger of the vectors used to make the decision (e.g., *"Suggested because: 1\. You requested High Protein. 2\. You ordered Salmon last Tuesday. 3\. Local Beef inventory confidence is low."*).

### **3.2 The "Purge Protocol" (The Kill-Switch)**

* Users have the absolute right to "forget."  
* **Action:** Tapping "Purge Aura Memory" initiates a localized destruction sequence.  
* **Execution:** 1\. The SQLCipher key in the Secure Enclave is destroyed, rendering the local database permanently unreadable. 2\. A signed webhook is dispatched to the Verve Cloud to delete the encrypted backup blob. 3\. Aura is reset to "Day 1" bootstrap state.

## **4\. Compliance Framework: NDPA & Beyond**

Verve strictly adheres to the **Nigeria Data Protection Act (NDPA)** and uses GDPR as its baseline for global scalability.

### **4.1 Data Localization**

* All Personally Identifiable Information (PII) necessary for logistics (Name, Delivery Address, Phone Number) is stored on servers physically located within Nigerian territory (e.g., local AWS Local Zones or Azure nodes) to comply with data sovereignty regulations.

### **4.2 KYC & Identity (The "Invisible" Vault)**

* High-value orders or restricted items may require KYC (Know Your Customer) verification.  
* **BVN Hashing:** If a Bank Verification Number (BVN) is required for identity confirmation, it is hashed locally on the device using a salt provided by the server. Only the hash is transmitted for verification against the NIBSS (Nigeria Inter-Bank Settlement System) API. Verve never stores the raw 11-digit BVN.

## **5\. Transactional & Physical Security**

### **5.1 The Payment Router Security**

* **Tokenization Only:** Verve never touches raw Primary Account Numbers (PAN) or CVVs. All card inputs are iframe-embedded directly from PCI-DSS Level 1 processors (Paystack/Flutterwave).  
* **Fraud Anomaly Detection:** An Edge-ML model monitors for "Velocity Attacks" (rapid, repeated orders) or drastic shifts in ordering patterns (e.g., a user who buys vegetables suddenly orders 10 bottles of premium cognac). Such anomalies trigger an automatic "Bio-Handshake" requirement or a manual review by a Nexus Lead before dispatch.

### **5.2 The Bio-Handshake (Physical Delivery Security)**

To protect both the user and the rider in urban environments:

* **The Problem:** Delivery fraud or misdelivery in complex apartment blocks.  
* **The Guardian Solution:** \* When the rider arrives, the Verve backend generates a Time-based One-Time Password (TOTP).  
  * This TOTP translates into a specific, rapidly pulsing Hex Color on the user's screen.  
  * The rider’s app uses the phone camera to read the color pulse (or uses BLE proximity).  
  * Only a successful cryptographic match unlocks the "Delivered" state and finalizes the payment capture. No verbal exchange of names or codes is required, ensuring discrete, secure handovers.

### **5.3 The Trust Ladder (Technical Data Escalation)**

The Trust Ladder (defined in the Brand & Persona Manual) has direct technical implications on what data Aura can access. Privacy permissions escalate with demonstrated trust, and each level requires explicit user opt-in with a clear value proposition.

| Trust Level | Data Access Granted | Opt-In Trigger | Value Proposition Displayed |
| :---- | :---- | :---- | :---- |
| **Level 0 (Stranger)** | Zero personal data. Anonymous session. Hub-wide popularity data only. | Automatic on first install | *"I work for you, not the other way around. I'll earn your trust first."* |
| **Level 1 (Acquaintance)** | Purchase history (last 30 days). Basic taste preferences. | After 3rd completed order, Aura asks: *"Can I remember your orders to speed things up next time?"* | *"This lets me skip the questions and stage what you usually need."* |
| **Level 2 (Confidant)** | Dietary restrictions. Household size. Depletion modeling. Temporal patterns. | After 8th order, Aura surfaces value: *"I noticed you run out of milk every 5 days. Want me to start tracking your pantry?"* | *"I'll predict what you need before you ask. You can always override."* |
| **Level 3 (Partner)** | Voice pattern recognition. Delivery address book. Payment cascade configuration. Full anticipatory provisioning. | After 15th order, Aura demonstrates accumulated value: *"I've saved you approximately 4 hours of shopping this month. Want to unlock full auto-provisioning?"* | *"I handle everything. You just say yes."* |

* **Demotion is instant and silent.** If a user revokes any data access via the Guardian Vault, Aura immediately adjusts behavior to the appropriate lower level. No confirmation popups. No guilt messaging. No "Are you sure?" patterns.  
* **Level display:** The Guardian Vault shows the current level prominently with a breakdown of exactly what data is held and what it enables.

### **5.4 Degraded Bio-Handshake Cascade**

The Bio-Handshake is engineered for the ideal case: two BLE-capable devices in close proximity with functioning hardware. The Nigerian delivery environment is not ideal. Phones die. BLE is disabled. Network drops. The handshake must degrade gracefully without compromising security.

| Fallback Level | Trigger | Mechanism | Security Trade-off |
| :---- | :---- | :---- | :---- |
| **Level 0 (Full)** | Both devices BLE-capable, online | BLE cryptographic token + visual color pulse | Maximum — cryptographic verification |
| **Level 1 (Visual Only)** | BLE unavailable on either device | Rider's camera reads the color pulse from user's screen (computer vision match) | High — visual forgery is difficult with rapidly cycling colors |
| **Level 2 (OTP)** | Camera or screen failure | 6-digit numeric code displayed on user's screen. Rider enters on their device. 30-second expiry. | Medium — vulnerable to shoulder-surfing but time-limited |
| **Level 3 (Hub Callback)** | Both devices non-functional or offline | Rider calls hub. Nexus Lead calls user on their registered phone number. Verbal confirmation with order details as verification. | Lower — social engineering risk, but last resort only |

* **Automatic Escalation:** The system does not ask the user which fallback to use. It tries Level 0, and if BLE handshake fails within 5 seconds, automatically falls to Level 1, then Level 2 after 10 seconds. Level 3 requires the rider to manually trigger via the app.  
* **Audit Trail:** Every degraded handshake is logged with the failure reason, fallback level used, and GPS coordinates. If Level 3 (verbal) is used more than twice for the same user-rider pair, the account is flagged for review.