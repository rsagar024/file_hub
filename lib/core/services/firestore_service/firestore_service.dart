import 'dart:io';
import 'package:tuple/tuple.dart';

abstract interface class FirestoreService {
  Future<Tuple2<bool, String>> uploadFile(File file);
}
