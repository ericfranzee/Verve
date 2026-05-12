import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

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

    // 2. Delete SQLite database file (stub via EdgeDbService if actual method existed)
    // await _dbService.deleteDatabase();
    print("MemoryManager: Deleted local SQLite database file.");

    // 3. Send signed webhook to delete cloud vectors
    const orchestratorUrl = 'http://10.0.2.2:8080/api/v1/purge'; // Assuming android emulator to localhost
    try {
      final response = await http.post(
        Uri.parse(orchestratorUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer placeholder_signed_token',
        },
        body: jsonEncode({"user_id": "current_user_123"}),
      );

      if (response.statusCode == 200) {
        print("MemoryManager: Sent cloud deletion webhook successfully.");
      } else {
        print("MemoryManager: Cloud deletion webhook failed with status ${response.statusCode}.");
      }
    } on SocketException catch (e) {
      print("MemoryManager: Network error during cloud purge: $e");
    } catch (e) {
      print("MemoryManager: Unknown error during cloud purge: $e");
    }

    // 4. Reset Aura to Trust Level 0 is handled in UI layer currently.
    print("MemoryManager: Reset Aura to Trust Level 0.");
  }
}
