import 'dart:typed_data';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// P5-T02: Offline Intent Queue
///
/// A local SQLite-VEC queue to capture and store user intents (e.g., "Add milk")
/// when the device loses its cellular connection completely.
class OfflineQueue {
  Database? _db;
  static const String tableName = 'offline_intents';

  Future<void> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'verve_offline_queue.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id TEXT PRIMARY KEY,
            text TEXT NOT NULL,
            embedding BLOB,
            status TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  /// Enqueues a new user intent when offline.
  Future<void> enqueueIntent(String id, String text, {Float32List? embedding}) async {
    if (_db == null) {
      throw Exception("OfflineQueue: Database not initialized. Call initDb() first.");
    }

    await _db!.insert(
      tableName,
      {
        'id': id,
        'text': text,
        'embedding': embedding?.buffer.asUint8List(),
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("OfflineQueue: Enqueued intent $id");
  }

  /// Fetches all pending intents ordered by creation time.
  Future<List<Map<String, dynamic>>> getPendingIntents() async {
    if (_db == null) {
      throw Exception("OfflineQueue: Database not initialized.");
    }

    return await _db!.query(
      tableName,
      where: 'status = ?',
      whereArgs: ['pending'],
      orderBy: 'created_at ASC',
    );
  }

  /// Marks an intent as successfully synced with the cloud.
  Future<void> markIntentSynced(String id) async {
    if (_db == null) {
      throw Exception("OfflineQueue: Database not initialized.");
    }

    await _db!.update(
      tableName,
      {'status': 'synced'},
      where: 'id = ?',
      whereArgs: [id],
    );
    print("OfflineQueue: Marked intent $id as synced");
  }

  /// Removes synced intents to save space.
  Future<void> pruneSyncedIntents() async {
    if (_db == null) {
      throw Exception("OfflineQueue: Database not initialized.");
    }

    await _db!.delete(
      tableName,
      where: 'status = ?',
      whereArgs: ['synced'],
    );
    print("OfflineQueue: Pruned synced intents");
  }
}
