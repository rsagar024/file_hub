import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:vap_uploader/core/common/models/file_result_model.dart';
import 'package:vap_uploader/secure_storage_service.dart';

class TelegramService {
  SecureStorageService secureStorage = SecureStorageService();

  Future<String?> getBotToken() async {
    return utf8.decode(base64Decode(await secureStorage.getData("botToken") ?? ''));
  }

  Future<String?> getChatId() async {
    return utf8.decode(base64Decode(await secureStorage.getData("chatId") ?? ''));
  }

  /*Future<String?> uploadFile(File file) async {
    final botToken = await getBotToken();
    final chatId = await getChatId();

    if (botToken == null || chatId == null) {
      return null;
      // return (null, null);
    }

    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

    String fieldName;
    if (mimeType.startsWith('image/')) {
      fieldName = 'photo';
    } else if (mimeType.startsWith('video/')) {
      fieldName = 'video';
    } else if (mimeType.startsWith('audio/')) {
      fieldName = 'audio';
    } else {
      fieldName = 'document';
    }

    final url = Uri.parse("https://api.telegram.org/bot$botToken/send${capitalize(fieldName)}");

    // Create multipart request
    var request = http.MultipartRequest('POST', url)
      ..fields['chat_id'] = chatId
      ..files.add(await http.MultipartFile.fromPath(
        fieldName,
        file.path,
        contentType: MediaType.parse(mimeType),
      ));

    // Send the request
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      print("File uploaded successfully: $responseBody");
      return getFileUrl(extractFileId(responseBody, fieldName) ?? '');
      // return (getFileUrl(extractFileId(responseBody, fieldName) ?? ''), fieldName);
    } else {
      print("Failed to upload file: ${response.statusCode}");
      return null;
    }
  }*/
  Future<FileResultModel?> uploadFile(File file) async {
    final botToken = await getBotToken();
    final chatId = await getChatId();

    if (botToken == null || chatId == null) {
      return null;
    }
    String fileName = file.uri.pathSegments.last;
    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

    String fieldName;
    if (mimeType.startsWith('image/')) {
      fieldName = 'photo';
    } else if (mimeType.startsWith('video/')) {
      fieldName = 'video';
    } else if (mimeType.startsWith('audio/')) {
      fieldName = 'audio';
    } else {
      fieldName = 'document';
    }

    final url = Uri.parse("https://api.telegram.org/bot$botToken/send${capitalize(fieldName)}");

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
      print("File uploaded successfully: $responseBody");

      String? fileId = extractFileId(responseBody, fieldName);
      if (fileId == null) {
        return FileResultModel(
          fileName: fileName,
          fileUrl: null,
          fileType: fieldName,
          fileId: null,
        );
      }

      String? fileUrl = await getFileUrl(fileId);

      return FileResultModel(
        fileName: fileName,
        fileUrl: fileUrl,
        fileType: fieldName,
        fileId: fileId,
      );
    } else {
      print("Failed to upload file: ${response.statusCode}");
      return FileResultModel(
        fileName: fileName,
        fileUrl: null,
        fileType: fieldName,
        fileId: null,
      );
    }
  }

// Helper function to capitalize field name
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  String? extractFileId(String responseBody, String type) {
    var data = jsonDecode(responseBody)['result'][type];

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

  // Add this function to the TelegramService class
  Future<String?> getFileUrl(String fileId) async {
    final botToken = await getBotToken();
    final url = Uri.parse("https://api.telegram.org/bot$botToken/getFile?file_id=$fileId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      String filePath = responseBody['result']['file_path'];
      print('Before File : https://api.telegram.org/file/bot$botToken/');
      print('File path : $filePath');
      return "https://api.telegram.org/file/bot$botToken/$filePath";
    } else {
      print("Failed to get file URL: ${response.statusCode}");
      return null;
    }
  }
}
