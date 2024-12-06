import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vap_uploader/core/common/models/file_model.dart';
import 'package:vap_uploader/core/common/models/file_result_model.dart';
import 'package:vap_uploader/core/services/firestore_service/firestore_service.dart';
import 'package:vap_uploader/telegram_service.dart';

class FirestoreServiceImpl implements FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TelegramService _telegramService;

  FirestoreServiceImpl(this._telegramService);

  @override
  Future<String> uploadFile(File file) async {
    String res = 'Some error occurred';
    try {
      String fileName = file.uri.pathSegments.last;
      var existingFileQuery = await _firestore.collection('files').where('fileName', isEqualTo: fileName).get();

      if (existingFileQuery.docs.isNotEmpty) {
        res = 'File already exists in Firestore';
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
          await _firestore.collection('files').doc(result?.fileId).set(model.toJson());
          res = 'success';
        } else {
          res = 'file can\'t be uploaded';
        }
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
