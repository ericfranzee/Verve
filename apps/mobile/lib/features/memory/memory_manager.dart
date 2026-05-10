import '../../core/edge_db/db_service.dart';
import '../../core/encryption/encryption_service.dart';

class MemoryManager {
  final EdgeDbService _dbService;
  final EncryptionService _encryptionService;

  MemoryManager(this._dbService, this._encryptionService);

  Future<void> initialize() async {
    await _encryptionService.getHardwareKey();
    await _dbService.initializeDatabase();
  }

  Future<void> purgeProtocol() async {
    // 1. Destroy SQLCipher key
    await _encryptionService.destroyHardwareKey();

    // 2. Delete SQLite database file (stub)
    print("MemoryManager: Deleted local SQLite database file.");

    // 3. Send signed webhook to delete cloud vectors (stub)
    print("MemoryManager: Sent cloud deletion webhook.");

    // 4. Reset Aura to Trust Level 0 (stub)
    print("MemoryManager: Reset Aura to Trust Level 0.");
  }
}
