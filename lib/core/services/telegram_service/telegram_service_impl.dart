import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:vap_uploader/core/common/models/file_result_model.dart';
import 'package:vap_uploader/core/extensions/string_extension.dart';
import 'package:vap_uploader/core/resources/common/rest_resources.dart';
import 'package:vap_uploader/core/services/secure_storage_service/secure_storage_service.dart';
import 'package:vap_uploader/core/services/telegram_service/telegram_service.dart';
import 'package:vap_uploader/core/utilities/file_type_checker.dart';

class TelegramServiceImpl implements TelegramService {
  final SecureStorageService _storageService;
  final Dio _dio;

  TelegramServiceImpl(this._storageService, this._dio);

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
    final url = TelegramRestResources.getFileId(botToken, fileId);

    try {
      Response response = await _dio.get(url);
      if (response.statusCode == 200) {
        var responseBody = response.data;
        String filePath = responseBody['result']['file_path'];
        return TelegramRestResources.getFileFullPath(botToken, filePath);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching file URL: $e');
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
    final mimeType = await FileTypeChecker.getMimeType(file.path);

    String fieldName = FileTypeChecker.checkFileType(mimeType);
    final url = "${TelegramRestResources.uploadDocument(botToken)}${fieldName.capitalize()}";

    try {
      FormData formData = FormData.fromMap({
        'chat_id': chatId,
        fieldName: await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
      });

      Response response = await _dio.post(
        url,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200) {
        var responseBody = response.data;

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
        return FileResultModel(
          fileName: fileName,
          fileUrl: fileUrl,
          fileType: fieldName,
          fileId: fileId,
          thumbnail: null,
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
    } catch (e) {
      debugPrint('Error uploading file: $e');
      return FileResultModel(
        fileName: fileName,
        fileUrl: null,
        fileType: fieldName,
        fileId: null,
        thumbnail: null,
      );
    }
  }

  String? extractFileId(Map<String, dynamic> responseBody, String type) {
    var data = responseBody['result'][type];
    if (type == 'photo') {
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
