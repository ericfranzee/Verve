# apps/mobile/lib/core/edge_db/ — Structure Map

## Purpose
Manages the on-device Edge DB for semantic context and offline capabilities using SQLite-VEC (currently falling back to standard `sqflite` operations).

## Files

| File | Responsibility |
|------|---------------|
| db_service.dart | Primary EdgeDbService for opening DB, querying, and updating |
| schema.dart | Constants defining the `verve_memories` table schema |

## Data Flow
Flutter App -> [MemoryManager] -> [EdgeDbService] -> SQLite File -> MemoryResult
