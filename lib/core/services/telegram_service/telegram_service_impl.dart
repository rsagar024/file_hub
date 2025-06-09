import 'dart:io';

import 'package:file_hub/core/common/models/file_result_model.dart';
import 'package:file_hub/core/remote/telegram_client.dart';
import 'package:file_hub/core/services/telegram_service/telegram_service.dart';

class TelegramServiceImpl implements TelegramService {
  final TelegramClient _telegramClient;

  TelegramServiceImpl(this._telegramClient);

  @override
  Future<String?> getFileUrl(String fileId, String fieldName) {
    // TODO: implement getFileUrl
    throw UnimplementedError();
  }

  @override
  Future<FileResultModel?> uploadFile(File file) {
    // TODO: implement uploadFile
    throw UnimplementedError();
  }

/*@override
  Future<FileResultModel?> uploadFile(File file) async {
    final tdlibClient = _telegramClient.tdlib;
    int clientId = tdlibClient.td_create_client_id();

    String fileName = file.uri.pathSegments.last;
    final mimeType = await FileTypeChecker.getMimeType(file.path);
    String fieldName = FileTypeChecker.checkFileType(mimeType);

    const int chunkSize = 1024 * 1024;

    Uint8List fileBytes = await file.readAsBytes();
    int totalSize = fileBytes.length;
    int offset = 0;
    int partNumber = 0;

    String? fileId;

    while (offset < totalSize) {
      int end = offset + chunkSize;
      if (end > totalSize) {
        end = totalSize;
      }

      Uint8List chunk = fileBytes.sublist(offset, end);
      final response = await tdlibClient.invoke(
        "upload${fieldName.capitalize()}",
        clientId: clientId,
        parameters: {
          fieldName: {
            "@type": "inputFileGenerated",
            "original_path": file.path,
            "conversion": "telegram_upload",
            "expected_size": totalSize,
          },
          "offset": offset,
          "limit": chunk.length,
        },
      );

      offset += chunk.length;
      partNumber++;

      // Extract file ID from response
      fileId = response["id"];
      print("Uploaded chunk $partNumber (${chunk.length} bytes)");

      // Simulate network delay (optional)
      await Future.delayed(const Duration(milliseconds: 500));
    }
    if (fileId == null) {
      return FileResultModel(
        fileName: fileName,
        fileUrl: null,
        fileType: fieldName,
        fileId: null,
        thumbnail: null,
      );
    }

    String? fileUrl = await getFileUrl(fileId, fieldName);
    return FileResultModel(
      fileName: fileName,
      fileUrl: fileUrl,
      fileType: fieldName,
      fileId: fileId,
      thumbnail: null,
    );
  }

  @override
  Future<String?> getFileUrl(String fileId, String fieldName) async {
    final tdlibClient = _telegramClient.tdlib;
    int clientId = tdlibClient.td_create_client_id();

    String? remoteUrl;
    final response = await tdlibClient.invoke(
      "get${fieldName.capitalize()}",
      clientId: clientId,
      parameters: {"file_id": fileId},
    );
    if (response.containsKey("remote")) {
      remoteUrl = response["remote"]["url"];
    }
    return remoteUrl;
  }*/
}
