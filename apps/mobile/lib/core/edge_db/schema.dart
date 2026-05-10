class EdgeDbSchema {
  static const String memoriesTable = 'verve_memories';

  static const String createMemoriesTable = '''
    CREATE TABLE $memoriesTable (
      id TEXT PRIMARY KEY,
      embedding BLOB NOT NULL,
      content_text TEXT NOT NULL,
      temporal_weight REAL DEFAULT 1.0,
      category TEXT NOT NULL,
      trust_level_required INTEGER DEFAULT 0,
      created_at TEXT NOT NULL,
      last_accessed TEXT,
      reinforcement_count INTEGER DEFAULT 0,
      archived INTEGER DEFAULT 0
    );
  ''';
}
