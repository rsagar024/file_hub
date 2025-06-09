import 'dart:io';

import 'package:file_hub/core/common/models/file_model.dart';
import 'package:file_hub/core/common/models/file_upload_state.dart';
import 'package:tuple/tuple.dart';

abstract interface class FirestoreService {
  Future<Tuple2<bool, String>> uploadFile(File file);

  Stream<FileUploadState> uploadMultipleFiles(List<File> files);

  Future<List<FileModel>> getAllFiles(String type, int pageNo, {int pageSize = 15});

  Future<int> getFilesCount(String type);

  Future<void> updateFile(FileModel file);
}
