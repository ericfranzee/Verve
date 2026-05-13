# Verve: API Contracts Specification v1.0

**Document Status:** Engineering Ready  
**Date:** May 13, 2026

## 1. Go Orchestrator (WebSocket + REST)

### 1.1 WebSocket Protocol (`ws://host:8080/ws`)

**Connection:** Client sends `Authorization: Bearer <JWT>` as first message after connection.

#### Client → Server Messages

```json
// Voice Audio Chunk
{
  "type": "audio_chunk",
  "session_id": "uuid",
  "chunk_index": 0,
  "audio_base64": "<PCM 16kHz mono base64>",
  "is_final": false
}

// Text Intent (keyboard fallback)
{
  "type": "text_intent",
  "session_id": "uuid",
  "text": "I need milk and eggs",
  "trust_level": 1
}

// User Action
{
  "type": "user_action",
  "session_id": "uuid",
  "action": "confirm_order" | "reject_item" | "substitute_accept" | "cancel_order",
  "payload": {}
}

// Handshake Initiate
{
  "type": "handshake_ready",
  "session_id": "uuid",
  "order_id": "uuid"
}
```

#### Server → Client Messages

```json
// Synapse Payload (Visual Synapse)
{
  "type": "synapse",
  "session_id": "uuid",
  "tts_audio_url": "https://cdn.verve.ng/audio/resp_88.opus",
  "latency_ms": 420,
  "ui_sequence": [
    {"timestamp_ms": 0, "action": "SET_WAVE_STATE", "payload": {"state": "SPEAKING", "color": "#008080"}},
    {"timestamp_ms": 1200, "action": "HERO_TRANSITION", "payload": {"component": "ProductCard", "item_id": "uuid", "fallback_vector": "svg/spinach.svg"}}
  ]
}

// Order Update
{
  "type": "order_update",
  "order_id": "uuid",
  "status": "picking",
  "eta_minutes": 12,
  "rider": {"name": "Tunde", "lat": 9.0579, "lng": 7.4951}
}

// Handshake Trigger
{
  "type": "handshake_trigger",
  "order_id": "uuid",
  "totp_color": "#FFBF00",
  "ble_token": "<encrypted>",
  "fallback_otp": "847293",
  "level": 0
}

// Error / Fallback
{
  "type": "error",
  "code": "INTENT_TIMEOUT",
  "message": "Aura is thinking...",
  "cached_suggestion": {"text": "Based on your usual Thursday...", "items": []}
}

// Connection State
{
  "type": "connection_state",
  "state": "connected" | "degraded" | "offline",
  "ping_ms": 120
}
```

### 1.2 REST Endpoints

| Method | Path | Auth | Purpose |
|--------|------|------|---------|
| GET | `/health` | None | Health check |
| POST | `/api/v1/purge` | Bearer JWT | Purge Protocol — cascade delete |
| GET | `/api/v1/session/:id` | Bearer JWT | Retrieve session state |

## 2. Python Intent Engine (REST)

**Base URL:** `http://host:8000`

### 2.1 Endpoints

| Method | Path | Auth | Purpose |
|--------|------|------|---------|
| GET | `/health` | None | Health check |
| POST | `/api/v1/transcribe` | Internal | Raw audio → text |
| POST | `/api/v1/infer` | Internal | Text intent → structured action |
| POST | `/api/v1/voice_loop` | Internal | Full audio → TTS+UI pipeline |
| POST | `/internal/purge` | Bearer | Delete user vectors |
| POST | `/copilot/alert` | Internal | Rider AI Copilot alerts |

### 2.2 Key Request/Response Schemas

```json
// POST /api/v1/voice_loop
// Request
{
  "audio_data_base64": "<hex-encoded PCM>",
  "user_trust_level": 2,
  "hub_id": "hub-wuse-ii",
  "user_context": {
    "dietary_restrictions": ["dairy"],
    "recent_orders": ["uuid1", "uuid2"],
    "emotional_state": "neutral"
  }
}

// Response
{
  "tts_audio_base64": "<hex-encoded audio>",
  "transcription": "I need something for dinner tonight",
  "latency_ms": 820,
  "synapse_payload": {
    "ui_state": "proposal",
    "metadata": {"title": "Thursday Night Dinner", "pof": 0.95},
    "trigger_ms": 300,
    "items": [
      {"product_id": "uuid", "name": "Chicken Breast", "price": 4500, "pof": 0.98},
      {"product_id": "uuid", "name": "Brown Rice", "price": 1200, "pof": 0.92}
    ]
  },
  "is_fulfillable": true
}
```

## 3. Node.js Nexus API (GraphQL)

**Base URL:** `http://host:4000/graphql`

### 3.1 GraphQL Schema

```graphql
type Query {
  # Products & Inventory
  products(hubId: ID!, category: String, search: String, limit: Int): [Product!]!
  product(id: ID!): Product
  inventory(hubId: ID!, productIds: [ID!]): [InventoryItem!]!
  verifyInventory(hubId: ID!, skus: [ID!]!): FulfillmentCheck!

  # Orders
  orders(userId: ID!, status: OrderStatus, limit: Int): [Order!]!
  order(id: ID!): Order
  activeOrder(userId: ID!): Order

  # Hubs
  hub(id: ID!): Hub
  nearestHub(lat: Float!, lng: Float!): Hub

  # Users (Admin)
  users(role: UserRole, limit: Int, offset: Int): [User!]!
  user(id: ID!): User

  # Riders
  riders(hubId: ID!, status: RiderStatus): [Rider!]!
  riderEarnings(riderId: ID!, from: DateTime, to: DateTime): EarningsSummary!

  # Analytics (Admin)
  hubAnalytics(hubId: ID!, period: AnalyticsPeriod!): HubAnalytics!
  orderAnalytics(period: AnalyticsPeriod!): OrderAnalytics!
  revenueReport(period: AnalyticsPeriod!): RevenueReport!
}

type Mutation {
  # Auth
  register(input: RegisterInput!): AuthPayload!
  login(input: LoginInput!): AuthPayload!
  refreshToken(token: String!): AuthPayload!

  # Orders
  createOrder(input: CreateOrderInput!): Order!
  confirmOrder(orderId: ID!): Order!
  cancelOrder(orderId: ID!, reason: String): Order!
  reOrder(orderId: ID!): Order!

  # Fulfillment
  assignPicker(orderId: ID!, pickerId: ID!): Order!
  completePicking(orderId: ID!, items: [PickedItemInput!]!): Order!
  dispatchRider(orderId: ID!, riderId: ID!): Order!
  completeHandshake(orderId: ID!, level: Int!, verificationData: String): Order!

  # Payments
  processPayment(input: PaymentInput!): Payment!
  topUpWallet(amount: Float!, gateway: String!): WalletTransaction!
  refundOrder(orderId: ID!, amount: Float, reason: String!): Payment!

  # Hub Management (Admin)
  updateHubStatus(hubId: ID!, status: HubStatus!): Hub!
  updateInventory(hubId: ID!, productId: ID!, quantity: Int!, price: Float): InventoryItem!
  addProduct(input: ProductInput!): Product!
  updateProduct(id: ID!, input: ProductInput!): Product!
  removeProduct(id: ID!): Boolean!

  # Rider Management
  updateRiderStatus(riderId: ID!, status: RiderStatus!): Rider!
  triggerSOS(riderId: ID!, lat: Float!, lng: Float!): SOSResponse!

  # Chaos Protocols
  triggerChaosProtocol(protocol: ChaosProtocol!, hubId: ID!, params: JSON): ChaosResult!

  # User Management (Admin)
  suspendUser(userId: ID!, reason: String!): User!
  updateTrustLevel(userId: ID!, level: Int!): User!
  purgeUserData(userId: ID!): Boolean!
}

type Subscription {
  orderUpdated(orderId: ID!): Order!
  riderLocation(riderId: ID!): LocationUpdate!
  hubStatusChanged(hubId: ID!): Hub!
  inventoryAlert(hubId: ID!): InventoryAlert!
}
```

### 3.2 REST Endpoints (Non-GraphQL)

| Method | Path | Auth | Purpose |
|--------|------|------|---------|
| GET | `/health` | None | Health check |
| GET | `/dashboard` | Session | Nexus Lead Dashboard (HTML) |
| POST | `/webhooks/paystack` | Signature | Paystack webhook |
| POST | `/webhooks/flutterwave` | Signature | Flutterwave webhook |

## 4. Authentication Flow

```
1. User registers with phone + password → POST register mutation
2. OTP sent to phone → User verifies → JWT issued
3. JWT contains: {userId, role, trustLevel, hubId}
4. Access token: 15-min expiry
5. Refresh token: 30-day expiry, stored in user_sessions table
6. All WebSocket connections require valid JWT as first message
7. Internal service-to-service calls use shared HMAC signature
```

## 5. Error Codes

| Code | HTTP | Meaning |
|------|------|---------|
| `AUTH_REQUIRED` | 401 | Missing or expired token |
| `AUTH_FORBIDDEN` | 403 | Insufficient role/trust level |
| `HUB_OFFLINE` | 503 | Hub not accepting orders |
| `INVENTORY_DESYNC` | 409 | PoF score too low, re-verify |
| `PAYMENT_FAILED` | 402 | All cascade levels exhausted |
| `INTENT_TIMEOUT` | 504 | LLM exceeded deadline |
| `RATE_LIMITED` | 429 | Too many requests |
| `FRAUD_DETECTED` | 423 | Account flagged for review |
