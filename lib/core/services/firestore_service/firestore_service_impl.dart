import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_hub/core/common/models/file_model.dart';
import 'package:file_hub/core/common/models/file_result_model.dart';
import 'package:file_hub/core/common/models/file_upload_state.dart';
import 'package:file_hub/core/services/firestore_service/firestore_service.dart';
import 'package:file_hub/core/services/telegram_service/telegram_service.dart';
import 'package:file_hub/core/utilities/file_type_checker.dart';
import 'package:file_hub/core/utilities/image_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuple/tuple.dart';

class FirestoreServiceImpl implements FirestoreService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final TelegramService _telegramService;

  FirestoreServiceImpl(this._auth, this._firestore, this._telegramService);

  @override
  Future<Tuple2<bool, String>> uploadFile(File file) async {
    bool isSuccess = false;
    String message = '';

    try {
      String fileName = file.uri.pathSegments.last;
      final mimeType = await FileTypeChecker.getMimeType(file.path);
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

  @override
  Stream<FileUploadState> uploadMultipleFiles(List<File> files) async* {
    for (var file in files) {
      try {
        String fileName = file.uri.pathSegments.last;
        final mimeType = await FileTypeChecker.getMimeType(file.path);
        String fileType = FileTypeChecker.checkFileType(mimeType);

        QuerySnapshot existingFileQuery = await _firestore
            .collection('files')
            .doc(_auth.currentUser?.uid ?? '') // user ID
            .collection(fileType)
            .where('isDeleted', isEqualTo: false)
            .where('fileName', isEqualTo: fileName)
            .get();

        if (existingFileQuery.docs.isNotEmpty) {
          yield FileUploadState.popup(
            message: 'File with the name "$fileName" already exists.',
          );
          continue;
        }

        FileResultModel? result = await _telegramService.uploadFile(file);

        if (result?.fileUrl != null) {
          FileModel model = FileModel(
            fileName: result?.fileName,
            fileId: result?.fileId,
            fileType: result?.fileType,
            fileUrl: result?.fileUrl,
            thumbnail: result?.fileType == 'audio' ? ImageGenerator.generate() : result?.thumbnail,
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

          yield FileUploadState.success(
            fileName: fileName,
            message: 'File uploaded successfully.',
          );
        } else {
          yield FileUploadState.error(
            fileName: fileName,
            message: 'File upload failed. No URL returned.',
          );
        }
      } catch (e) {
        yield FileUploadState.error(
          fileName: file.uri.pathSegments.last,
          message: 'An error occurred: ${e.toString()}',
        );
      }
    }
  }

  @override
  Future<List<FileModel>> getAllFiles(String type, int pageNo, {int pageSize = 15}) async {
    try {
      final String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) throw Exception('User is not authenticated.');

      Query query = _firestore
          .collection('files')
          .doc(userId) // User id
          .collection(type)
          .where('isDeleted', isEqualTo: false)
          .orderBy('modifiedOn', descending: true)
          .limit(pageSize);

      if (pageNo > 1) {
        DocumentSnapshot? lastDocument = await _getLastDocument(type, pageNo, pageSize);
        if (lastDocument != null) {
          query = query.startAfterDocument(lastDocument);
        }
      }

      QuerySnapshot fileQuery = await query.get();

      List<FileModel> models = fileQuery.docs.map((doc) => FileModel.fromSnap(doc)).toList();
      final updatedModels = await Future.wait(models.map((model) async {
        final newUrl = await _telegramService.getFileUrl(model.fileId ?? '', type);
        String? thumbnail;
        if (type == 'video') {
          // thumbnail = await _generateThumbnail(model.fileUrl ?? '');
        }
        return model.copyWith(fileUrl: newUrl, thumbnail: thumbnail);
      }));

      return updatedModels;
    } catch (e) {
      throw Exception('Failed to fetch files: ${e.toString()}');
    }
  }

  Future<DocumentSnapshot?> _getLastDocument(String type, int pageNo, int pageSize) async {
    try {
      final String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception('User is not authenticated.');
      }

      QuerySnapshot snapshot = await _firestore
          .collection('files')
          .doc(userId) // User id
          .collection(type)
          .where('isDeleted', isEqualTo: false)
          .orderBy('modifiedOn', descending: true)
          .limit((pageNo - 1) * pageSize)
          .get();

      return snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
    } catch (e) {
      throw Exception('Failed to fetch last document for pagination: ${e.toString()}');
    }
  }

  @override
  Future<int> getFilesCount(String type) async {
    try {
      final String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) throw Exception('User is not authenticated.');
      final query = _firestore
          .collection('files')
          .doc(userId) // User
          .collection(type)
          .where('isDeleted', isEqualTo: false)
          .count();
      final countSnapshot = await query.get();
      return countSnapshot.count ?? 0;
    } catch (e) {
      throw Exception('Failed to fetch files count: ${e.toString()}');
    }
  }

  @override
  Future<void> updateFile(FileModel file) async {
    try {
      final String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) throw Exception('User is not authenticated.');

      DocumentReference fileRef = _firestore
          .collection('files')
          .doc(userId) // User Id
          .collection(file.fileType ?? '')
          .doc(file.fileId);

      await fileRef.update(file.toJson());
    } catch (e) {
      throw Exception('Failed to update file: ${e.toString()}');
    }
  }

/*Future<String?> _generateThumbnail(String videoUrl) async {
    try {
      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: videoUrl,
        thumbnailPath: (await Directory.systemTemp.createTemp()).path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 200,
        // Specify thumbnail height
        quality: 75,
      );
      return thumbnailPath.path;
    } catch (e) {
      throw Exception('Failed to get thumbnail file: ${e.toString()}');
    }
  }*/
}
