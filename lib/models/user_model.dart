import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String photoURL;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoURL,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
      photoURL: user.photoURL ?? '',
    );
  }
}
