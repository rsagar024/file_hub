class RestResources {
  static const String _baseUrl = 'https://api.telegram.org';

  static String get baseUrl => _baseUrl;
}

class TelegramRestResources {
  static final String _prefix = RestResources.baseUrl;

  static String uploadDocument(String botToken) => '$_prefix/bot$botToken/send';

  static String getFileId(String botToken, String fileId) => '$_prefix/bot$botToken/getFile?file_id=$fileId';

  static String getFileFullPath(String botToken, String filePath) => '$_prefix/file/bot$botToken/$filePath';
}
