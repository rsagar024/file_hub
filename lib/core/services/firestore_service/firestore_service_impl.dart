import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mime/mime.dart';
import 'package:tuple/tuple.dart';
import 'package:vap_uploader/core/common/models/file_model.dart';
import 'package:vap_uploader/core/common/models/file_result_model.dart';
import 'package:vap_uploader/core/services/firestore_service/firestore_service.dart';
import 'package:vap_uploader/core/services/telegram_service/telegram_service.dart';
import 'package:vap_uploader/core/utilities/file_type_checker.dart';

class FirestoreServiceImpl implements FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TelegramService _telegramService;

  FirestoreServiceImpl(this._telegramService);

  @override
  Future<Tuple2<bool, String>> uploadFile(File file) async {
    bool isSuccess = false;
    String message = '';

    try {
      String fileName = file.uri.pathSegments.last;
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      String fileType = FileTypeChecker.checkFileType(mimeType);

      QuerySnapshot existingFileQuery = await _firestore
          .collection('files')
          .doc(_auth.currentUser?.uid ?? '') // user id
          .collection(fileType)
          .where('fileName', isEqualTo: fileName)
          .get();

      if (existingFileQuery.docs.isNotEmpty) {
        isSuccess = false;
        message = 'File with the same name already exists.';
      } else {
        FileResultModel? result = await _telegramService.uploadFile(file);

        if (result?.fileUrl != null) {
          FileModel model = FileModel(
            fileName: result?.fileName,
            fileId: result?.fileId,
            fileType: result?.fileType,
            fileUrl: result?.fileUrl,
            thumbnail: result?.thumbnail,
            createdOn: DateTime.now().toString(),
            createdBy: _auth.currentUser?.uid,
            modifiedOn: DateTime.now().toString(),
            modifiedBy: _auth.currentUser?.uid,
          );

          await _firestore
              .collection('files')
              .doc(_auth.currentUser?.uid ?? '')
              .collection(model.fileType ?? '') // file type
              .doc(model.fileId)
              .set(model.toJson());

          isSuccess = true;
          message = 'File uploaded successfully.';
        } else {
          isSuccess = false;
          message = 'File upload failed. No URL returned.';
        }
      }
    } catch (e) {
      isSuccess = false;
      message = 'An error occurred: ${e.toString()}';
    }

    return Tuple2(isSuccess, message);
  }
}
