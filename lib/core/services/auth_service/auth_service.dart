import 'dart:typed_data';

import 'package:vap_uploader/core/common/models/user_model.dart';

abstract interface class AuthService {
  Future<UserModel> getUserDetails();

  Future<bool> signUpUser({required String name, required String email, required String password, String? bio, Uint8List? file});

  Future<bool> signInUser({required String email, required String password});

  Future<void> signOut();
}
