import 'dart:io';

import 'package:mime/mime.dart';

class FileTypeChecker {
  static String checkFileType(String mimeType) {
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
    return fieldName;
  }

  static Future<String> getMimeType(String filePath) async {
    return lookupMimeType(filePath, headerBytes: await File(filePath).readAsBytes()) ?? 'application/octet-stream';
  }
}
