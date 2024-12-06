import 'dart:io';

abstract interface class FirestoreService {
  Future<String> uploadFile(File file);
}
