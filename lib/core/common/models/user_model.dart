import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? name;
  final String? email;
  final String? uid;
  final String? photoUrl;
  final String? bio;
  final String? authPin;

  UserModel({
    this.name,
    this.email,
    this.uid,
    this.photoUrl,
    this.bio,
    this.authPin,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'uid': uid,
        'photoUrl': photoUrl,
        'bio': bio,
        'authPin': authPin,
      };

  factory UserModel.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      name: snapshot['name']?.toString(),
      email: snapshot['email']?.toString(),
      uid: snapshot['uid']?.toString(),
      photoUrl: snapshot['photoUrl']?.toString(),
      bio: snapshot['bio']?.toString(),
      authPin: snapshot['authPin']?.toString(),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      uid: json['uid']?.toString(),
      photoUrl: json['photoUrl']?.toString(),
      bio: json['bio']?.toString(),
      authPin: json['authPin']?.toString(),
    );
  }
}
