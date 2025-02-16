import 'dart:io';

import 'package:tuple/tuple.dart';
import 'package:vap_uploader/core/common/models/file_model.dart';
import 'package:vap_uploader/core/common/models/file_upload_state.dart';

abstract interface class FirestoreService {
  Future<Tuple2<bool, String>> uploadFile(File file);

  Stream<FileUploadState> uploadMultipleFiles(List<File> files);

  Future<List<FileModel>> getAllFiles(String type, int pageNo, {int pageSize = 15});

  Future<int> getFilesCount(String type);

  Future<void> updateFile(FileModel file);
}
