import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? name;
  final String? email;
  final String? uid;
  final String? photoUrl;
  final String? bio;

  UserModel({
    this.name,
    this.email,
    this.uid,
    this.photoUrl,
    this.bio,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'uid': uid,
        'photoUrl': photoUrl,
        'bio': bio,
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      name: snapshot['name']?.toString() ?? '',
      email: snapshot['email']?.toString() ?? '',
      uid: snapshot['uid']?.toString() ?? '',
      photoUrl: snapshot['photoUrl']?.toString() ?? '',
      bio: snapshot['bio']?.toString() ?? '',
    );
  }
}
