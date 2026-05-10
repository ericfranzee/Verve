import 'dart:typed_data';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

class EdgeDbService {
  Database? _db;

  Future<void> initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'verve_edge.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(EdgeDbSchema.createMemoriesTable);
      },
    );
    print("EdgeDbService: Database initialized.");
  }

  Future<void> saveMemory({
    required String id,
    required Float32List embedding,
    required String contentText,
    required String category,
    int trustLevelRequired = 0,
  }) async {
    if (_db == null) throw Exception("DB not initialized");
    await _db!.insert(
      EdgeDbSchema.memoriesTable,
      {
        'id': id,
        'embedding': embedding.buffer.asUint8List(),
        'content_text': contentText,
        'category': category,
        'trust_level_required': trustLevelRequired,
        'created_at': DateTime.now().toIso8601String(),
        'archived': 0,
        'reinforcement_count': 0,
        'temporal_weight': 1.0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("EdgeDbService: Saved memory $id");
  }

  Future<List<MemoryResult>> queryMemories({
    required Float32List queryEmbedding,
    required int currentTrustLevel,
    int topK = 5,
    double minTemporalWeight = 0.3,
  }) async {
    if (_db == null) throw Exception("DB not initialized");

    // Fallback stub for VEC similarity until sqlite-vec native is compiled in
    // This performs standard retrieval with Trust Level gating.
    final List<Map<String, dynamic>> maps = await _db!.query(
      EdgeDbSchema.memoriesTable,
      where: 'trust_level_required <= ? AND archived = 0',
      whereArgs: [currentTrustLevel],
      limit: topK,
    );

    print("EdgeDbService: Queried memories for trust level $currentTrustLevel");
    return List.generate(maps.length, (i) {
      return MemoryResult(
        id: maps[i]['id'] as String,
        contentText: maps[i]['content_text'] as String,
        score: 1.0, // Stub score
      );
    });
  }

  Future<void> deleteMemory(String id) async {
    if (_db == null) throw Exception("DB not initialized");
    await _db!.delete(
      EdgeDbSchema.memoriesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    print("EdgeDbService: Deleted memory $id");
  }

  Future<void> pruneExpiredMemories() async {
    if (_db == null) throw Exception("DB not initialized");

    // Archive memories older than 90 days with 0 reinforcement
    final ninetyDaysAgo = DateTime.now().subtract(const Duration(days: 90)).toIso8601String();
    await _db!.update(
      EdgeDbSchema.memoriesTable,
      {'archived': 1},
      where: 'created_at < ? AND reinforcement_count = 0',
      whereArgs: [ninetyDaysAgo],
    );
    print("EdgeDbService: Pruned expired memories");
  }
}
