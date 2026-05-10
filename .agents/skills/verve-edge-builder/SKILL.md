---
name: verve-edge-builder
description: "Use when building on-device intelligence for Verve: SQLite-VEC, TFLite models, Trust Ladder data enforcement, temporal decay pruning, DB corruption recovery, offline intent capture, and Secure Enclave key management."
category: development
risk: safe
source: project
tags: "[edge-ai, sqlite-vec, tflite, offline-first, encryption, local-rag, trust-ladder, decay-pruning]"
date_added: "2026-05-10"
date_updated: "2026-05-10"
---

# Verve Edge Builder — On-Device Intelligence

## Purpose

Build all on-device AI and local storage components. This skill handles the "Local-First, Edge-Heavy" philosophy — ensuring the app remains functional, private, and intelligent without a network connection. Includes Trust Ladder data access enforcement, temporal decay pruning, and DB corruption recovery.

## When to Use

- Building SQLite-VEC schema, CRUD operations, or encryption
- Implementing Trust Ladder data access enforcement (Guardian §5.3)
- Implementing temporal decay pruning (90-day archive — Build Strategy §7.1)
- Implementing DB corruption recovery (Blueprint §5.3)
- Integrating TFLite models (wake-word, velocity state, offline intent)
- Building the offline intent buffer
- Building local RAG (vector similarity search on-device)
- Setting up Secure Enclave / Android Keystore integration

## Architecture Context

```
┌─────────────────────────────────────────┐
│            Flutter Application          │
│  ┌──────────────┐  ┌────────────────┐   │
│  │ SQLite-VEC   │  │ TFLite Runtime │   │
│  │ (SQLCipher)  │  │ (Wake-word,    │   │
│  │              │  │  Velocity,     │   │
│  │ Embeddings   │  │  Intent Class) │   │
│  │ Context      │  └────────────────┘   │
│  │ Trust Level  │ ← [NEW] Enforced      │
│  │ Temporal Wt  │                       │
│  └──────┬───────┘                       │
│         │ Encrypted by                  │
│  ┌──────┴───────┐                       │
│  │ Secure       │                       │
│  │ Enclave /    │                       │
│  │ Keystore     │                       │
│  └──────────────┘                       │
└─────────────────────────────────────────┘
```

---

## Component Specifications

### 1. SQLite-VEC Local Database

**Schema (Enhanced):**

```sql
CREATE TABLE verve_memories (
  id TEXT PRIMARY KEY,
  embedding BLOB NOT NULL,
  content_text TEXT NOT NULL,
  temporal_weight REAL DEFAULT 1.0,
  category TEXT NOT NULL,        -- DIETARY, PURCHASE, PREFERENCE, ROUTINE
  trust_level_required INTEGER DEFAULT 0, -- [NEW] Min trust level to access
  created_at TEXT NOT NULL,
  last_accessed TEXT,
  reinforcement_count INTEGER DEFAULT 0,
  archived INTEGER DEFAULT 0     -- [NEW] 1 = archived to cloud (90-day pruning)
);
```

### 2. Trust Ladder Data Enforcement (Guardian §5.3)

```dart
Future<List<MemoryResult>> queryMemories({
  required List<double> queryEmbedding,
  required int currentTrustLevel, // [NEW] From user's Trust Ladder state
  int topK = 5,
  double minTemporalWeight = 0.3,
}) async {
  // Only return memories where trust_level_required <= currentTrustLevel
  // Level 0: no personal memories returned (hub popularity only)
  // Level 1: PURCHASE category only
  // Level 2: PURCHASE + DIETARY + ROUTINE
  // Level 3: ALL categories
}
```

### 3. Temporal Decay with 90-Day Pruning (Build Strategy §7.1)

```dart
// Standard decay: temporal_weight = initial * e^(-0.05 * days_since_access)
// Half-life ≈ 14 days

// [NEW] 90-Day Archive Pruning:
Future<void> pruneExpiredMemories() async {
  // Memories older than 90 days with zero reinforcement → archive to cloud
  // Mark archived = 1 in local DB
  // Upload to encrypted cloud backup before local deletion
  // Prevents SQLite-VEC degradation past 10,000 vectors
}
```

### 4. DB Corruption Recovery (Blueprint §5.3)

```dart
Future<void> initializeDatabase() async {
  final db = await openEncryptedDatabase();
  final integrityOk = await db.execute("PRAGMA integrity_check");

  if (!integrityOk) {
    // 1. Wipe corrupted local DB
    // 2. Attempt restore from encrypted cloud backup
    // 3. If no backup: reset to Day 1 (Trust Level 0)
    // Aura message: "My local memory had an issue. Restoring from backup."
  }
}
```

### 5. SQLCipher Encryption (Guardian §2.1)

256-bit AES via SQLCipher. Key in Secure Enclave/Keystore. Key NEVER leaves secure hardware.

### 6. TFLite Models

- **Wake-Word:** ~2MB quantized, uses device DSP
- **Velocity State:** Classifies IDLE/ACTIVE/CHECKOUT/TRACKING
- **Offline Intent Classifier:** CRITICAL vs. DEFERRABLE

### 7. Offline Intent Buffer

Captures PCM when offline. Classifies as CRITICAL (e.g., "Cancel Order") or DEFERRABLE. Flushes CRITICAL first on reconnect.

### 8. Purge Protocol (Guardian §3.2, PRD §4.4)

Execute within **< 2 seconds** (updated tolerance from PRD §4.4):
1. Destroy SQLCipher key in Secure Enclave/Keystore
2. Delete SQLite database file
3. Send signed webhook: `DELETE /api/v1/user/{id}/vectors`
4. Reset Aura to Trust Level 0 (bootstrap state)
5. Log success/failure; alert user if cloud deletion unconfirmed

## Acceptance Criteria

| Criterion | Source | Threshold |
|-----------|--------|-----------|
| Embedding storage/retrieval | Blueprint §4.1 | Correct 1536-dim F32 vectors |
| Temporal reference resolution | PRD §3.3 | "Monday" / "Last week" → correct SKUs |
| Allergen interception | PRD §3.3 | Blocklist match → swap suggestion |
| Purge latency | PRD §4.4 | < 2 seconds (local + cloud) |
| Encryption | Guardian §2.1 | SQLCipher 256-bit AES, hardware key |
| Offline buffer | Architecture §6.3 | Audio captured, classified, flushed |
| Battery impact | PRD §4.1 | Edge AI < 0.5% per 5-min session |
| Trust Level enforcement | Guardian §5.3 | Level N queries return only level ≤ N data |
| 90-day pruning | Build Strategy §7.1 | Vectors > 90 days archived to cloud |
| Corruption recovery | Blueprint §5.3 | Integrity check → cloud restore → Day 1 reset |

## Dependencies

| Needs | From |
|-------|------|
| Flutter project scaffold | verve-flutter-builder |
| Embedding generation endpoint | verve-backend-builder |
| Cloud vector deletion API | verve-backend-builder |
| Trust Level state | verve-flutter-builder (Guardian Vault) |

| Provides | To |
|----------|-----|
| Local embeddings for RAG | verve-backend-builder |
| Offline intent buffer | verve-backend-builder |
| Memory data for Guardian Vault | verve-flutter-builder |
| Purge execution | verve-flutter-builder |
| Trust-gated query results | verve-backend-builder (Intent Engine) |
