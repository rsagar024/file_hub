import 'dart:io';

import 'package:file_hub/core/common/models/file_result_model.dart';

abstract interface class TelegramService {
  Future<FileResultModel?> uploadFile(File file);

  Future<String?> getFileUrl(String fileId, String fieldName);
}
