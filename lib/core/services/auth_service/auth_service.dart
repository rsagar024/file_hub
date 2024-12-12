import 'dart:typed_data';

import 'package:tuple/tuple.dart';
import 'package:vap_uploader/core/common/models/user_model.dart';

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
}
