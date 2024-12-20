import 'dart:io';

import 'package:tuple/tuple.dart';
import 'package:vap_uploader/core/common/models/file_upload_state.dart';

abstract interface class FirestoreService {
  Future<Tuple2<bool, String>> uploadFile(File file);

  Stream<FileUploadState> uploadMultipleFiles(List<File> files);
}
