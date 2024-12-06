abstract interface class SecureStorageService {
  Future<String> encryptData(String data);

  Future<String> decryptData(String encryptedData);

  Future<void> saveData(String key, String value);

  Future<String?> getData(String key);
}
