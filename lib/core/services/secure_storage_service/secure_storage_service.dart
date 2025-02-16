import 'package:vap_uploader/core/common/models/user_model.dart';

abstract interface class SecureStorageService {
  Future<String> encryptData(String data);

  Future<String> decryptData(String encryptedData);

  Future<void> saveData(String key, String value);

  Future<String?> getData(String key);

  Future<void> saveUserModel(UserModel userModel);

  Future<UserModel?> getUserModel();
}
