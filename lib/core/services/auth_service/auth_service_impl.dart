import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vap_uploader/core/common/models/user_model.dart';
import 'package:vap_uploader/core/services/auth_service/auth_service.dart';

class AuthServiceImpl implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
    return UserModel.fromSnap(snap);
  }

  @override
  Future<String> signUpUser({
    required String name,
    required String email,
    required String password,
    String? bio,
    Uint8List? file,
  }) async {
    String res = 'Some error occurred';
    try {
      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        // String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);
        UserModel user = UserModel(
          name: name,
          email: email,
          uid: cred.user?.uid ?? '',
          photoUrl: '',
          bio: bio ?? '',
        );
        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        res = 'success';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  @override
  Future<String> loginUser({required String email, required String password}) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
