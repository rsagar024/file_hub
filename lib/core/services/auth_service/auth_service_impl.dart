import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuple/tuple.dart';
import 'package:vap_uploader/core/common/models/user_model.dart';
import 'package:vap_uploader/core/services/auth_service/auth_service.dart';

class AuthServiceImpl implements AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthServiceImpl(this._auth, this._firestore);

  @override
  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
    return UserModel.fromSnap(snap);
  }

  @override
  Future<Tuple2<bool, String>> signUpUser({
    required String name,
    required String email,
    required String password,
    String? bio,
    Uint8List? file,
  }) async {
    bool isSuccess = false;
    String message = '';

    try {
      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        UserModel user = UserModel(
          name: name,
          email: email,
          uid: cred.user?.uid ?? '',
          photoUrl: null,
          bio: bio,
          authPin: null,
        );
        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        isSuccess = true;
        message = 'User signed up successfully.';
      } else {
        isSuccess = false;
        message = 'Please fill all the required fields.';
      }
    } catch (e) {
      isSuccess = false;
      message = 'An error occurred: ${e.toString()}';
    }
    return Tuple2(isSuccess, message);
  }

  @override
  Future<Tuple2<bool, String>> signInUser({required String email, required String password}) async {
    bool isSuccess = false;
    String message = '';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        isSuccess = true;
        message = 'User signed in successfully.';
      } else {
        isSuccess = false;
        message = 'Please fill all the required fields.';
      }
    } catch (e) {
      isSuccess = false;
      message = 'An error occurred: ${e.toString()}';
    }
    return Tuple2(isSuccess, message);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<bool> updateUser(UserModel user) async {
    try {
      final String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty && userId != user.uid) throw Exception('User is not authenticated.');

      DocumentReference userRef = _firestore.collection('users').doc(userId); // User Id
      await userRef.update(user.toJson());
      return true;
    } catch (e) {
      throw Exception('Failed to update user details: ${e.toString()}');
    }
  }
}
