import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart';
import 'dart:convert';

class EncryptionService {
  final _storage = const FlutterSecureStorage();
  final String _keyName = 'VERVE_SQLCIPHER_KEY';

  Future<String> getHardwareKey() async {
    // P1-T06: True Keystore / Secure Enclave integration via flutter_secure_storage
    String? existingKey = await _storage.read(key: _keyName);

    if (existingKey != null) {
      return existingKey;
    }

    // Generate a new 256-bit AES key if one doesn't exist
    final key = Key.fromSecureRandom(32);
    final keyBase64 = base64Url.encode(key.bytes);

    await _storage.write(key: _keyName, value: keyBase64);
    return keyBase64;
  }

  Future<void> destroyHardwareKey() async {
    // P1-T06: Purge protocol
    await _storage.delete(key: _keyName);
  }
}
