import 'dart:io';

import 'package:vap_uploader/core/common/models/file_result_model.dart';

abstract interface class TelegramService {
  Future<String?> getBotToken();

  Future<String?> getChatId();

  Future<FileResultModel?> uploadFile(File file);

  Future<String?> getFileUrl(String fileId);
}
