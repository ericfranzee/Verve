# **Verve: Secondary Screens & Ancillary UI Specification v1.0**

**Document Status:** Final (Design/Engineering Ready) **Date:** May 8, 2026 **Target Architecture:** Flutter (Impeller Engine)

## **1\. UX Philosophy for Secondary Screens**

While 90% of the user journey happens on the conversational Home Screen (The Stage), users require deterministic, high-control environments for management and oversight.  
**The Rule of the Vault:** Secondary screens in Verve are not places to *shop*; they are places to *manage*. They eschew the fluid, organic animations of the Home Screen in favor of rigid, ledger-like precision. The typography shifts from conversational sans-serifs to monospaced fonts to signify "data and control."

## **2\. The Guardian Vault (Privacy & Identity)**

**Purpose:** The nerve center for the "Zero-Knowledge Intimacy" mandate. This is where the user controls what Aura knows. **Navigation:** Accessed via the subtle shield icon in the Sentinel Zone (Home Screen).

### **2.1 The Interface**

* **Background:** Absolute Black (\#000000) for maximum OLED battery savings and to signify a secure environment.  
* **Typography:** JetBrains Mono or similar high-legibility monospaced font.  
* **Layout:** A vertical, high-contrast list resembling a developer console or a financial ledger.

### **2.2 Core Functions & Views**

* **The "Intimate Ledger":** A scrolling list of all vector embeddings Aura currently holds locally.  
  * *Format:* \[TIMESTAMP\] \- \[CATEGORY\] \- \[EXTRACTED CONTEXT\]  
  * *Example:* \[08-MAY-26 14:20\] \- \[DIETARY\] \- \[Prefers Plantain over Yam\]  
  * *Action:* Users can swipe left on any individual line item to instantly delete that specific memory vector.  
* **The "Purge" Kill-Switch:**  
  * *UI:* A prominent, unmissable button at the bottom of the ledger, outlined in Nexus Amber (\#FFBF00).  
  * *Text:* \[ INITIATE TOTAL CONTEXT PURGE \]  
  * *UX:* Requires a "Slide to Confirm" action (to prevent accidental taps), followed by biometric verification (FaceID/Fingerprint). Wipes the SQLite-VEC database instantly.  
* **Identity (KYC) Block:**  
  * A secured section displaying the status of the user's hashed BVN (Bank Verification Number) required for high-value orders or restricted items. Displays as BVN: \*\*\*-\*\*\*\*-1234 \[VERIFIED\].

## **3\. The Verve Pulse (Predictive Pantry)**

**Purpose:** A visual representation of Aura's decay-modeling algorithms. It shows the user what they likely need before they have to ask for it. **Navigation:** Accessed via the timeline/pulse icon in the Sentinel Zone.

### **3.1 The Interface**

* **Background:** Deep Charcoal.  
* **Layout:** A horizontal timeline or a vertically scrolling "Forecast."

### **3.2 Core Functions & Views**

* **The "Depletion Horizon":** Items are grouped by when Aura predicts they will run out.  
  * *Section:* \[ DEPLETING: NEXT 48 HOURS \]  
  * *Items:* Displayed as minimalistic vector silhouettes (not high-res photos, to keep the screen data-light). e.g., Silhouette of a milk carton with a status bar showing 10% remaining.  
* **Interaction (The "Train the AI" Loop):**  
  * *Tap:* Adds the item to the "Draft Basket."  
  * *Long Press:* Opens a context menu: \[ I have plenty \] or \[ I don't buy this anymore \].  
  * *Internal Function:* These actions immediately write new negative vectors to the local memory, adjusting Aura's future PoF (Probability of Fulfillment) models.

## **4\. Semantic History (Order Archive)**

**Purpose:** A contextual record of past provisioning events, moving away from date-based receipts to event-based memories.

### **4.1 The Interface**

* **Layout:** A timeline feed, similar to a minimalist social network feed, but for personal logistics.

### **4.2 Core Functions & Views**

* **Context Grouping:** Instead of "Order \#1042 on May 1st," the UI displays the semantic tag Aura applied to the event.  
  * *Example Header:* \[ THE SUNDAY RESET \] \- 03 MAY 2026  
  * *Details:* Shows the Vitality Score of the basket, the total cost, and the hub used (e.g., Wuse II Hub).  
* **The "Re-Provision" Button:** A one-tap button (Teal) that takes the exact contents of that historical basket, runs a live inventory check against the current Nexus, and prepares it for immediate checkout via Aura.

## **5\. The Payment & Routing Configuration**

**Purpose:** Managing the complex reality of Nigerian fintech reliability.

### **5.1 The Interface**

* **Style:** High-contrast, strictly utilitarian.

### **5.2 Core Functions & Views**

* **The Cascade Manager:** A drag-and-drop ordered list where users define their payment fallbacks.  
  * *Slot 1 (Primary):* Paystack \- GTBank Card ending in 4432  
  * *Slot 2 (Secondary):* Flutterwave \- Zenith Account Transfer  
  * *Slot 3 (Tertiary):* Verve Wallet Balance: ₦45,000  
* **Wallet Top-Up:** A simple interface to pre-fund the Verve Wallet, ensuring zero-friction checkouts even if the national NIP (bank transfer) switches are experiencing downtime.

## **6\. The "Human Bridge" (Nexus Escalation View)**

**Purpose:** The UI state when the AI fails and a human Hub Manager (Nexus Lead) takes over. This is technically an overlay on the Home Screen but functions as a distinct UX environment.

### **6.1 The Interface**

* **Visual Shift:** The entire UI theme shifts subtly. The Aura Teal wave disappears. The borders of the viewport glow faintly in Nexus Amber (\#FFBF00).  
* **The Human Element:** The top of the screen displays a high-resolution, professional portrait of the specific Nexus Lead handling the order.  
  * *Text:* CONNECTED TO NEXUS LEAD: CHUKS (LEKKI HUB)  
* **Interaction Mode:** The interface switches to a hybrid Text/Push-to-Talk format. The AI "Breathing Wave" is replaced by a standard microphone icon and a text input field, mimicking a high-end concierge messaging service.

## **7\. Branding Consistency Check (The "Verve" Feel)**

Across all secondary screens, the branding must hold true to the "Cognitive Relief" manifesto:

* **No Marketing Banners:** There are zero ads, cross-sells, or "Recommended for You" carousels on any secondary screen.  
* **Deterministic Interaction:** Buttons do exactly what they say. There are no hidden menus or "hamburger" icons.  
* **Haptic Anchoring:** Every toggle, swipe to delete, or configuration change is accompanied by a sharp, highly specific haptic "click," grounding the digital data in physical reality.