import 'dart:typed_data';

import 'package:file_hub/core/common/models/user_model.dart';
import 'package:tuple/tuple.dart';

abstract interface class AuthService {
  Future<UserModel> getUserDetails();

  Future<Tuple2<bool, String>> signUpUser({
    required String name,
    required String email,
    required String password,
    String? bio,
    Uint8List? file,
  });

  Future<Tuple2<bool, String>> signInUser({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<bool> updateUser(UserModel user);
}
