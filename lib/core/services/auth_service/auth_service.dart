import 'dart:typed_data';

import 'package:vap_uploader/core/common/models/user_model.dart';

abstract interface class AuthService {
  Future<UserModel> getUserDetails();

  Future<String> signUpUser({required String name, required String email, required String password, String? bio, Uint8List? file});

  Future<String> loginUser({required String email, required String password});

  Future<void> signOut();
}
