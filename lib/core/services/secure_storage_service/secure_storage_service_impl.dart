import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:file_hub/core/common/models/user_model.dart';
import 'package:file_hub/core/services/secure_storage_service/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _aesKeyKey = "hacker4Key";

  Future<String> _generateRandomKey() async {
    final random = List<int>.generate(32, (_) => (256 * (0.5 - (0.5 - 0.5))).round());
    return base64UrlEncode(random);
  }

  Future<encrypt.Key> _getOrCreateAesKey() async {
    String? key = await _storage.read(key: _aesKeyKey);
    if (key == null) {
      key = await _generateRandomKey();
      await _storage.write(key: _aesKeyKey, value: key);
    }
    return encrypt.Key.fromBase64(key);
  }

  @override
  Future<String> encryptData(String data) async {
    final aesKey = await _getOrCreateAesKey();
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(aesKey));
    final encrypted = encrypter.encrypt(data, iv: iv);

    return jsonEncode({
      "iv": base64.encode(iv.bytes),
      "data": base64.encode(encrypted.bytes),
    });
  }

  @override
  Future<String> decryptData(String encryptedData) async {
    final aesKey = await _getOrCreateAesKey();
    final Map<String, dynamic> jsonData = jsonDecode(encryptedData);
    final iv = encrypt.IV.fromBase64(jsonData["iv"]);
    final encrypted = encrypt.Encrypted(base64.decode(jsonData["data"]));
    final encrypter = encrypt.Encrypter(encrypt.AES(aesKey));

    return encrypter.decrypt(encrypted, iv: iv);
  }

  @override
  Future<String?> getData(String key) async {
    final encryptedValue = await _storage.read(key: key);
    if (encryptedValue != null) {
      return decryptData(encryptedValue);
    }
    return null;
  }

  @override
  Future<void> saveData(String key, String value) async {
    final encryptedValue = await encryptData(value);
    await _storage.write(key: key, value: encryptedValue);
  }

  @override
  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> saveUserModel(UserModel userModel) async {
    String userJson = jsonEncode(userModel.toJson());
    final encryptedUser = await encryptData(userJson);
    await _storage.write(key: 'user', value: encryptedUser);
  }

  @override
  Future<UserModel?> getUserModel() async {
    final encryptedUser = await _storage.read(key: 'user');
    if (encryptedUser != null) {
      final decryptedUser = await decryptData(encryptedUser);
      return UserModel.fromJson(jsonDecode(decryptedUser));
    }
    return null;
  }
}
