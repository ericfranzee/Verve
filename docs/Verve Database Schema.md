# Verve: Database Schema Specification v1.0

**Document Status:** Engineering Ready  
**Date:** May 13, 2026  
**Databases:** PostgreSQL 16+ (transactional), Redis 7+ (cache/sessions)

## 1. PostgreSQL Schema

### 1.1 Users & Authentication

```sql
CREATE TABLE users (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone           VARCHAR(15) UNIQUE NOT NULL,
    email           VARCHAR(255) UNIQUE,
    display_name    VARCHAR(100),
    password_hash   VARCHAR(255) NOT NULL,
    bvn_hash        VARCHAR(64),          -- SHA-256 of BVN, never raw
    trust_level     SMALLINT DEFAULT 0 CHECK (trust_level BETWEEN 0 AND 3),
    completed_orders INTEGER DEFAULT 0,
    role            VARCHAR(20) DEFAULT 'customer' CHECK (role IN ('customer','rider','picker','hub_manager','admin')),
    status          VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active','suspended','purged')),
    language        VARCHAR(10) DEFAULT 'en-NG',
    currency        VARCHAR(3) DEFAULT 'NGN',
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE user_addresses (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID REFERENCES users(id) ON DELETE CASCADE,
    label       VARCHAR(50) DEFAULT 'Home',
    address     TEXT NOT NULL,
    lat         DECIMAL(10, 7) NOT NULL,
    lng         DECIMAL(10, 7) NOT NULL,
    is_default  BOOLEAN DEFAULT false,
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE user_sessions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID REFERENCES users(id) ON DELETE CASCADE,
    refresh_token   VARCHAR(512) NOT NULL,
    device_info     JSONB,
    expires_at      TIMESTAMPTZ NOT NULL,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);
```

### 1.2 Hubs (Micro-Fulfillment Centers)

```sql
CREATE TABLE hubs (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(100) NOT NULL,
    code            VARCHAR(20) UNIQUE NOT NULL,  -- e.g., 'WUSE-II', 'LEKKI-1'
    address         TEXT NOT NULL,
    lat             DECIMAL(10, 7) NOT NULL,
    lng             DECIMAL(10, 7) NOT NULL,
    radius_km       DECIMAL(4, 1) DEFAULT 5.0,
    status          VARCHAR(20) DEFAULT 'offline' CHECK (status IN ('online','offline','reduced','flooded')),
    operating_hours JSONB DEFAULT '{"open":"07:00","close":"21:00"}',
    manager_id      UUID REFERENCES users(id),
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE hub_zones (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hub_id      UUID REFERENCES hubs(id) ON DELETE CASCADE,
    zone_type   VARCHAR(20) NOT NULL CHECK (zone_type IN ('alpha','beta','gamma','omega')),
    label       VARCHAR(50),
    status      VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active','locked','flooded')),
    temp_c      DECIMAL(4, 1),       -- Current temperature (Beta zone)
    updated_at  TIMESTAMPTZ DEFAULT NOW()
);
```

### 1.3 Products & Inventory

```sql
CREATE TABLE products (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(200) NOT NULL,
    slug            VARCHAR(200) UNIQUE NOT NULL,
    description     TEXT,
    category        VARCHAR(100) NOT NULL,
    subcategory     VARCHAR(100),
    unit            VARCHAR(20) DEFAULT 'piece',  -- piece, kg, litre, pack
    image_url       TEXT,
    vector_svg_url  TEXT,           -- Low-fidelity fallback
    vitality_tags   TEXT[],         -- e.g., {'high-protein','low-carb'}
    allergens       TEXT[],         -- e.g., {'peanut','dairy','gluten'}
    is_restricted   BOOLEAN DEFAULT false,  -- Age/KYC required
    zone_type       VARCHAR(20) DEFAULT 'gamma',
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE inventory (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hub_id          UUID REFERENCES hubs(id) ON DELETE CASCADE,
    product_id      UUID REFERENCES products(id) ON DELETE CASCADE,
    quantity         INTEGER NOT NULL DEFAULT 0,
    price_ngn       DECIMAL(10, 2) NOT NULL,
    cost_ngn        DECIMAL(10, 2),
    commission_pct  DECIMAL(4, 2) DEFAULT 12.00,
    pof_score       DECIMAL(3, 2) DEFAULT 0.95,  -- Probability of Fulfillment
    last_scanned_at TIMESTAMPTZ DEFAULT NOW(),
    spoilage_rate   DECIMAL(4, 3) DEFAULT 0.01,
    status          VARCHAR(20) DEFAULT 'in_stock' CHECK (status IN ('in_stock','low_stock','out_of_stock','rejected')),
    UNIQUE(hub_id, product_id)
);
```

### 1.4 Orders & Fulfillment

```sql
CREATE TYPE order_status AS ENUM (
    'draft','confirmed','picking','picked','dispatched',
    'in_transit','arrived','delivered','cancelled','returned'
);

CREATE TABLE orders (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_number    SERIAL UNIQUE,
    user_id         UUID REFERENCES users(id),
    hub_id          UUID REFERENCES hubs(id),
    rider_id        UUID REFERENCES users(id),
    picker_id       UUID REFERENCES users(id),
    status          order_status DEFAULT 'draft',
    semantic_tag    VARCHAR(100),         -- "The Sunday Reset", "Thursday Night Keto"
    subtotal_ngn    DECIMAL(10, 2),
    delivery_fee    DECIMAL(10, 2),
    vat_ngn         DECIMAL(10, 2),
    total_ngn       DECIMAL(10, 2),
    payment_method  VARCHAR(20),
    payment_ref     VARCHAR(100),
    delivery_type   VARCHAR(20) DEFAULT 'standard' CHECK (delivery_type IN ('standard','priority')),
    eta_minutes     INTEGER,
    handshake_level SMALLINT,             -- 0=BLE, 1=Visual, 2=OTP, 3=Callback
    delivered_at    TIMESTAMPTZ,
    cancelled_at    TIMESTAMPTZ,
    cancel_reason   TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE order_items (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id        UUID REFERENCES orders(id) ON DELETE CASCADE,
    product_id      UUID REFERENCES products(id),
    quantity        INTEGER NOT NULL DEFAULT 1,
    unit_price      DECIMAL(10, 2) NOT NULL,
    subtotal        DECIMAL(10, 2) NOT NULL,
    is_substituted  BOOLEAN DEFAULT false,
    original_product_id UUID REFERENCES products(id),  -- If substituted
    substitution_reason TEXT
);
```

### 1.5 Payments

```sql
CREATE TABLE payments (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id        UUID REFERENCES orders(id),
    user_id         UUID REFERENCES users(id),
    amount_ngn      DECIMAL(10, 2) NOT NULL,
    gateway         VARCHAR(20) NOT NULL CHECK (gateway IN ('paystack','flutterwave','wallet','pod')),
    cascade_depth   SMALLINT DEFAULT 1,   -- 1=primary, 2=secondary, 3=tertiary, 4=pod
    status          VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending','processing','success','failed','refunded')),
    gateway_ref     VARCHAR(200),
    gateway_response JSONB,
    resolved_at     TIMESTAMPTZ,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE wallets (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    balance_ngn DECIMAL(12, 2) DEFAULT 0.00,
    updated_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE wallet_transactions (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wallet_id   UUID REFERENCES wallets(id),
    type        VARCHAR(20) CHECK (type IN ('credit','debit','refund','topup')),
    amount_ngn  DECIMAL(10, 2) NOT NULL,
    reference   VARCHAR(200),
    description TEXT,
    created_at  TIMESTAMPTZ DEFAULT NOW()
);
```

### 1.6 Riders

```sql
CREATE TABLE rider_profiles (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID UNIQUE REFERENCES users(id),
    hub_id          UUID REFERENCES hubs(id),
    vehicle_plate   VARCHAR(20),
    license_number  VARCHAR(50),
    status          VARCHAR(20) DEFAULT 'offline' CHECK (status IN ('online','offline','on_delivery','on_break','sos')),
    rating          DECIMAL(2, 1) DEFAULT 5.0,
    total_deliveries INTEGER DEFAULT 0,
    current_lat     DECIMAL(10, 7),
    current_lng     DECIMAL(10, 7),
    shift_start     TIMESTAMPTZ,
    shift_end       TIMESTAMPTZ,
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE rider_earnings (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    rider_id        UUID REFERENCES rider_profiles(id),
    order_id        UUID REFERENCES orders(id),
    base_ngn        DECIMAL(8, 2),
    bonus_ngn       DECIMAL(8, 2) DEFAULT 0,
    surge_mult      DECIMAL(3, 2) DEFAULT 1.00,
    total_ngn       DECIMAL(8, 2),
    paid            BOOLEAN DEFAULT false,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);
```

### 1.7 Ratings & Reviews

```sql
CREATE TABLE ratings (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id    UUID REFERENCES orders(id),
    rater_id    UUID REFERENCES users(id),
    target_type VARCHAR(20) CHECK (target_type IN ('rider','hub','product','overall')),
    target_id   UUID,
    score       SMALLINT CHECK (score BETWEEN 1 AND 5),
    comment     TEXT,
    created_at  TIMESTAMPTZ DEFAULT NOW()
);
```

## 2. Redis Key Structures

```
# Session & State
session:{userId}              → JSON (session state, last activity)
ws:session:{sessionId}        → JSON (WebSocket session state for Go Orchestrator)

# Inventory Cache (mirrors PostgreSQL, refreshed every 30s)
inventory:{hubId}:{productId} → JSON {qty, pof, price, lastScan}
hub:status:{hubId}            → STRING (online|offline|reduced)

# Real-time
rider:location:{riderId}      → GEOADD (lat, lng) with 5s TTL refresh
order:tracking:{orderId}      → JSON {status, riderLat, riderLng, eta}
handshake:{orderId}           → JSON {totp, color, expiresAt} with 60s TTL

# Rate Limiting & Fraud
fraud:velocity:{userId}       → SORTED SET (order timestamps, 30-min window)
rate:api:{ip}                 → COUNTER with 60s TTL

# Circuit Breaker State
breaker:{serviceName}         → JSON {state, failCount, lastFailure, cooldownEnd}
```

## 3. Indexes

```sql
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_inventory_hub ON inventory(hub_id);
CREATE INDEX idx_inventory_product ON inventory(product_id);
CREATE INDEX idx_inventory_hub_status ON inventory(hub_id, status);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_hub ON orders(hub_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_rider ON orders(rider_id);
CREATE INDEX idx_payments_order ON payments(order_id);
CREATE INDEX idx_rider_profiles_hub ON rider_profiles(hub_id);
CREATE INDEX idx_rider_profiles_status ON rider_profiles(status);
```

## 4. Migration Strategy

- Use **node-pg-migrate** for the Nexus API (Node.js manages the schema)
- Migrations live in `services/nexus-api/migrations/`
- Naming convention: `001_create_users.sql`, `002_create_hubs.sql`, etc.
- All migrations are idempotent and reversible
