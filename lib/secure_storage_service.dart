import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _aesKeyKey = "aesKey"; // Key to store the AES encryption key

  // Generate a random AES key (32 bytes for AES-256)
  Future<String> _generateRandomKey() async {
    final random = List<int>.generate(32, (_) => (256 * (0.5 - (0.5 - 0.5))).round());
    return base64UrlEncode(random);
  }

  // Retrieve or create AES encryption key
  Future<encrypt.Key> _getOrCreateAesKey() async {
    String? key = await _storage.read(key: _aesKeyKey);
    if (key == null) {
      key = await _generateRandomKey();
      await _storage.write(key: _aesKeyKey, value: key);
    }
    return encrypt.Key.fromBase64(key);
  }

  // Encrypt data
  Future<String> encryptData(String data) async {
    final aesKey = await _getOrCreateAesKey();
    final iv = encrypt.IV.fromLength(16); // Initialization Vector
    final encrypter = encrypt.Encrypter(encrypt.AES(aesKey));
    final encrypted = encrypter.encrypt(data, iv: iv);

    return jsonEncode({
      "iv": base64.encode(iv.bytes), // Include IV for decryption
      "data": base64.encode(encrypted.bytes),
    });
  }

  // Decrypt data
  Future<String> decryptData(String encryptedData) async {
    final aesKey = await _getOrCreateAesKey();
    final Map<String, dynamic> jsonData = jsonDecode(encryptedData);
    final iv = encrypt.IV.fromBase64(jsonData["iv"]);
    final encrypted = encrypt.Encrypted(base64.decode(jsonData["data"]));
    final encrypter = encrypt.Encrypter(encrypt.AES(aesKey));

    return encrypter.decrypt(encrypted, iv: iv);
  }

  // Save encrypted data to secure storage
  Future<void> saveData(String key, String value) async {
    final encryptedValue = await encryptData(value);
    await _storage.write(key: key, value: encryptedValue);
  }

  // Retrieve and decrypt data from secure storage
  Future<String?> getData(String key) async {
    final encryptedValue = await _storage.read(key: key);
    if (encryptedValue != null) {
      return decryptData(encryptedValue);
    }
    return null;
  }
}
