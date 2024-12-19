import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:vap_uploader/core/common/models/file_result_model.dart';
import 'package:vap_uploader/core/extensions/string_extension.dart';
import 'package:vap_uploader/core/resources/common/rest_resources.dart';
import 'package:vap_uploader/core/services/secure_storage_service/secure_storage_service.dart';
import 'package:vap_uploader/core/services/telegram_service/telegram_service.dart';
import 'package:vap_uploader/core/utilities/file_type_checker.dart';

class TelegramServiceImpl implements TelegramService {
  final SecureStorageService _storageService;

  TelegramServiceImpl(this._storageService);

  @override
  Future<String> getBotToken() async {
    return utf8.decode(base64Decode(await _storageService.getData("botToken") ?? ''));
  }

  @override
  Future<String> getChatId() async {
    return utf8.decode(base64Decode(await _storageService.getData("chatId") ?? ''));
  }

  @override
  Future<String?> getFileUrl(String fileId) async {
    final botToken = await getBotToken();
    final url = Uri.parse(TelegramRestResources.getFileId(botToken, fileId));

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      String filePath = responseBody['result']['file_path'];
      return TelegramRestResources.getFileFullPath(botToken, filePath);
    } else {
      return null;
    }
  }

  @override
  Future<FileResultModel?> uploadFile(File file) async {
    final botToken = await getBotToken();
    final chatId = await getChatId();

    if (botToken.isEmpty || chatId.isEmpty) {
      return null;
    }
    String fileName = file.uri.pathSegments.last;
    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

    String fieldName = FileTypeChecker.checkFileType(mimeType);

    // final url = Uri.parse("${TelegramRestResources.uploadDocument(botToken)}${capitalize(fieldName)}");
    final url = Uri.parse("${TelegramRestResources.uploadDocument(botToken)}${fieldName.capitalize()}");

    var request = http.MultipartRequest('POST', url)
      ..fields['chat_id'] = chatId
      ..files.add(await http.MultipartFile.fromPath(
        fieldName,
        file.path,
        contentType: MediaType.parse(mimeType),
      ));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();

      String? fileId = extractFileId(responseBody, fieldName);
      if (fileId == null) {
        return FileResultModel(
          fileName: fileName,
          fileUrl: null,
          fileType: fieldName,
          fileId: null,
          thumbnail: null,
        );
      }

      String? fileUrl = await getFileUrl(fileId);
      String? thumbnail = fieldName == 'video'
          ? await getFileUrl(
              jsonDecode(responseBody)['result']['video']['thumbnail']['file_id'],
            )
          : null;

      debugPrint('Thumbnail check : $thumbnail');

      return FileResultModel(
        fileName: fileName,
        fileUrl: fileUrl,
        fileType: fieldName,
        fileId: fileId,
        thumbnail: thumbnail,
      );
    } else {
      return FileResultModel(
        fileName: fileName,
        fileUrl: null,
        fileType: fieldName,
        fileId: null,
        thumbnail: null,
      );
    }
  }

  String? extractFileId(String responseBody, String type) {
    var data = jsonDecode(responseBody)['result'][type];
    if (type == 'image') {
      var highestQualityPhoto = data.reduce((a, b) {
        int areaA = a['width'] * a['height'];
        int areaB = b['width'] * b['height'];
        return areaA > areaB ? a : b;
      });
      return highestQualityPhoto['file_id'];
    }
    return data['file_id'];
  }
}
