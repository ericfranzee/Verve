import 'dart:typed_data';

import 'schema.dart';

class MemoryResult {
  final String id;
  final String contentText;
  final double score;

  MemoryResult({
    required this.id,
    required this.contentText,
    required this.score,
  });
}

/// Interface for the local database to support both real and mock implementations.
abstract class LocalDatabase {
  Future<void> execute(String sql, [List<Object?>? arguments]);
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    int? limit,
  });
  Future<int> delete(String table, {String? where, List<Object?>? whereArgs});
}

/// A mock implementation of the database for development and testing.
class MockDatabase implements LocalDatabase {
  final Map<String, List<Map<String, dynamic>>> _tables = {};

  @override
  Future<void> execute(String sql, [List<Object?>? arguments]) async {
    // Basic mock: only handles specific INSERT statements for the memories table.
    if (sql.contains('INSERT INTO ${EdgeDbSchema.memoriesTable}')) {
      final tableName = EdgeDbSchema.memoriesTable;
      _tables.putIfAbsent(tableName, () => []);

      if (arguments != null && arguments.length >= 6) {
        _tables[tableName]!.add({
          'id': arguments[0],
          'embedding': arguments[1],
          'content_text': arguments[2],
          'category': arguments[3],
          'trust_level_required': arguments[4],
          'created_at': arguments[5],
        });
      }
      print("MockDatabase: Executed INSERT on $tableName. Total rows: ${_tables[tableName]!.length}");
    }
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    int? limit,
  }) async {
    print("MockDatabase: Querying $table with where: $where");
    var results = _tables[table] ?? [];

    // Simple mock filtering for trust_level_required
    if (where != null && where.contains('trust_level_required <= ?') && whereArgs != null) {
      final trustLevel = whereArgs[0] as int;
      results = results.where((row) => (row['trust_level_required'] as int) <= trustLevel).toList();
    }

    if (limit != null) {
      results = results.take(limit).toList();
    }

    return results;
  }

  @override
  Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) async {
    print("MockDatabase: Deleting from $table");
    if (where != null && where.contains('id = ?') && whereArgs != null) {
      final id = whereArgs[0] as String;
      final initialCount = _tables[table]?.length ?? 0;
      _tables[table]?.removeWhere((row) => row['id'] == id);
      return initialCount - (_tables[table]?.length ?? 0);
    }
    return 0;
  }
}

class EdgeDbService {
  // Stub for the actual SQLite-VEC instance
  bool _isInitialized = false;
  LocalDatabase? _db;

  Future<void> initializeDatabase() async {
    // 1. Open encrypted database (stub)
    _db = MockDatabase();
    // 2. Execute PRAGMA integrity_check
    // 3. Create tables if not exists
    _isInitialized = true;
    print("EdgeDbService: Database initialized.");
  }

  Future<void> saveMemory({
    required String id,
    required Float32List embedding,
    required String contentText,
    required String category,
    int trustLevelRequired = 0,
  }) async {
    if (!_isInitialized) throw Exception("DB not initialized");

    final createdAt = DateTime.now().toIso8601String();
    // Convert Float32List to Uint8List for BLOB storage
    final embeddingBytes = embedding.buffer.asUint8List(
      embedding.offsetInBytes,
      embedding.lengthInBytes,
    );

    await _db?.execute(
      'INSERT INTO ${EdgeDbSchema.memoriesTable} ('
      'id, embedding, content_text, category, trust_level_required, created_at'
      ') VALUES (?, ?, ?, ?, ?, ?)',
      [
        id,
        embeddingBytes,
        contentText,
        category,
        trustLevelRequired,
        createdAt,
      ],
    );

    print("EdgeDbService: Saved memory $id");
  }

  Future<List<MemoryResult>> queryMemories({
    required Float32List queryEmbedding,
    required int currentTrustLevel,
    int topK = 5,
    double minTemporalWeight = 0.3,
  }) async {
    if (!_isInitialized) throw Exception("DB not initialized");

    // Note: In a real implementation, we would use the vss_search or similar
    // for vector similarity. This stub demonstrates the trust level filtering.
    final List<Map<String, dynamic>> results = await _db?.query(
          EdgeDbSchema.memoriesTable,
          where: 'trust_level_required <= ?',
          whereArgs: [currentTrustLevel],
          limit: topK,
        ) ??
        [];

    print("EdgeDbService: Queried memories for trust level $currentTrustLevel");
    return results
        .map((r) => MemoryResult(
              id: r['id'] as String,
              contentText: r['content_text'] as String,
              score: 1.0, // Placeholder score
            ))
        .toList();
  }

  Future<void> deleteMemory(String id) async {
    if (!_isInitialized) throw Exception("DB not initialized");

    await _db?.delete(
      EdgeDbSchema.memoriesTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    print("EdgeDbService: Deleted memory $id");
  }

  Future<void> pruneExpiredMemories() async {
    if (!_isInitialized) throw Exception("DB not initialized");
    // Stub: Archive memories > 90 days old with 0 reinforcement to cloud
    print("EdgeDbService: Pruned expired memories");
  }
}
