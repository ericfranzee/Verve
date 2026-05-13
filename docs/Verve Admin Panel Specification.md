# Verve: Admin Panel Specification v1.0

**Document Status:** Engineering Ready  
**Date:** May 13, 2026  
**Technology:** React (Vite) + TanStack Query + Verve Design System  
**Location:** `apps/admin/` (New)

## 1. Overview

The Verve Admin Panel is a web-based management interface for operating the Verve Cognitive Commerce ecosystem. It serves three operator tiers: **Super Admin** (Verve HQ), **Hub Manager** (Nexus Lead), and **Operations Analyst**.

The admin panel does NOT replace the Aura voice interface for consumers — it manages the backend systems that Aura relies on.

## 2. Role Hierarchy

| Role | Access Scope | Key Actions |
|------|-------------|-------------|
| **Super Admin** | All hubs, all users, all finances | Full CRUD, white-label config, payment gateway config, system health |
| **Hub Manager** | Assigned hub only | Inventory, pickers, riders, chaos protocols, local orders |
| **Operations Analyst** | Read-only dashboards | Analytics, reports, performance metrics |

## 3. Screen Specifications

### 3.1 Dashboard (Home)

**Route:** `/admin/`

- Real-time KPIs: Active Orders, Total Revenue (Today), Avg Fulfillment Time, Active Riders
- Order volume chart (last 7 days, line chart)
- Hub status grid (all hubs with color-coded status: green=online, amber=reduced, red=offline)
- Recent alerts feed (chaos protocol triggers, SOS events, payment failures)
- Quick actions: Emergency hub lockdown, broadcast rider alert

### 3.2 Hub Management

**Route:** `/admin/hubs` → `/admin/hubs/:hubId`

- Hub list: Name, code, status, zone count, active pickers, active riders
- Hub detail:
  - Status toggle (Online/Offline/Reduced/Flooded)
  - Operating hours editor
  - Zone status panel (Alpha/Beta/Gamma/Omega) with temp readings
  - Assigned Hub Manager selector
  - Geo-fence radius slider (3-8 km)
  - Map with delivery radius overlay

### 3.3 Product Catalog

**Route:** `/admin/products` → `/admin/products/:id`

- Product list: Name, category, active hubs, average price, image
- Product editor:
  - Name, slug, description, category/subcategory
  - Unit type (piece, kg, litre, pack)
  - Image upload + vector SVG upload
  - Vitality tags (multi-select: high-protein, low-carb, etc.)
  - Allergen tags (peanut, dairy, gluten, shellfish, etc.)
  - Age restriction toggle
  - Zone assignment (alpha/beta/gamma/omega)
- Bulk import: CSV upload for product catalog

### 3.4 Inventory Management

**Route:** `/admin/inventory/:hubId`

- Inventory grid: Product, quantity, price, PoF score, last scan, status
- Inline edit: Quantity, price per hub
- Batch actions: Mark as rejected, adjust PoF, restock alert
- Spoilage log: Historical spoilage events and swap triggers
- Low-stock alerts (configurable threshold per product)

### 3.5 Order Management

**Route:** `/admin/orders` → `/admin/orders/:id`

- Order list: #, customer, hub, status, total, payment, time ago
- Filters: Status, hub, date range, payment method, rider
- Order detail:
  - Timeline: draft → confirmed → picking → dispatched → delivered
  - Item list with substitution history
  - Payment details (gateway, cascade depth, gateway response)
  - Rider tracking (last known location, ETA)
  - Handshake details (level used, verification status)
  - Cancel/refund actions
  - Rating (if submitted)

### 3.6 User Management

**Route:** `/admin/users` → `/admin/users/:id`

- User list: Name, phone, role, trust level, orders count, status
- Filters: Role, trust level, status, registration date
- User detail:
  - Profile info (non-PII — no viewing of raw BVN or payment tokens)
  - Trust level editor (with override reason)
  - Order history
  - Wallet balance + transaction history
  - Suspend/reactivate actions
  - Purge Protocol trigger (with confirmation)

### 3.7 Rider Management

**Route:** `/admin/riders` → `/admin/riders/:id`

- Rider list: Name, hub, status, current delivery, rating, today's deliveries
- Live map: All rider GPS positions (refreshed every 5s)
- Rider detail:
  - Profile, vehicle info, license
  - Shift history (start/end times, breaks taken)
  - Earnings breakdown (base, bonus, surge, per-delivery)
  - Rating history
  - Delivery history
  - SOS event log

### 3.8 Picker Management

**Route:** `/admin/pickers/:hubId`

- Picker list: Name, current zone, active tickets, items picked today
- Ticket queue: Pending picking tickets with assignment controls
- Emergency pick: Override mode for when Pickers < threshold

### 3.9 Payment & Finance

**Route:** `/admin/finance`

- Revenue summary: Total, by hub, by payment method
- Payment logs: All transactions with gateway, cascade depth, status
- Refund queue: Pending refunds with approve/reject
- Wallet operations: User wallet balances, top-up history
- Commission report: Platform commission by hub, by period
- Rider payout: Weekly payout calculation, export to CSV

### 3.10 Chaos Protocol Control

**Route:** `/admin/chaos/:hubId`

- Active protocols: Currently triggered protocols per hub
- Manual triggers:
  - Fleet Constrained mode
  - Hub Flooding lockout
  - Power Grid Failure
  - Holiday Surge pre-staging
- Protocol history: All triggers with timestamps, auto vs manual, resolution time

### 3.11 Analytics & Reports

**Route:** `/admin/analytics`

- Fulfillment metrics: Avg time, on-time %, substitution rate
- Customer metrics: New registrations, trust level progression, churn
- Revenue metrics: GMV, take rate, avg order value
- Hub performance: Hub-by-hub comparison
- Rider performance: Delivery speed, rating, SOS frequency
- Export: PDF and CSV download for all reports

### 3.12 White Label / Branding

**Route:** `/admin/settings/branding`

- Logo upload (light + dark variants)
- Primary color picker (replaces Aura Teal system-wide)
- Secondary color picker (replaces Nexus Amber)
- Font family selector
- App name override
- Splash screen config
- Live preview panel showing changes in real-time

### 3.13 System Settings

**Route:** `/admin/settings`

- Payment gateways: Paystack/Flutterwave API key configuration
- Notification settings: Push notification templates
- Cascade timeout: Configurable per-gateway timeout (default 4s)
- PoF thresholds: Global confidence score limits
- Delivery cutoff time: Configurable per-hub
- Ban zones: GeoJSON editor for motorcycle-prohibited areas
- NDPA compliance: Data retention policies, audit log viewer

## 4. Admin API Mapping

All admin operations use the GraphQL Nexus API with `role: admin` or `role: hub_manager` JWT claims. No separate admin backend is needed.

## 5. Technical Implementation

```
apps/admin/
├── src/
│   ├── components/       # Shared UI components
│   ├── layouts/          # Admin shell, sidebar, header
│   ├── pages/            # Route-based pages
│   ├── hooks/            # TanStack Query hooks
│   ├── lib/              # GraphQL client, auth helpers
│   └── styles/           # Verve admin theme
├── index.html
├── vite.config.ts
└── package.json
```
