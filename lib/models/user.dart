import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String email;
  final String uid;
  final String download;
  final String bio;
  final List followers;
  final List following;

  User(
      {required this.username,
      required this.email,
      required this.uid,
      required this.download,
      required this.bio,
      required this.followers,
      required this.following});

  //converts data to map json used to add data in firestore (database.dart)
  Map<String, dynamic> toJSON() => {
        'username': username,
        'email': email,
        'uid': uid,
        'bio': bio,
        'followers': [],
        'following': [],
        'photoURL': download
      };

  static User fromJson(DocumentSnapshot myDoc) {
    var snap = myDoc.data() as Map<String, dynamic>;

    return User(
        username: snap['username'],
        email: snap['email'],
        uid: snap['uid'],
        download: snap['photoURL'],
        bio: snap['bio'],
        followers: snap['followers'],
        following: snap['following']);
  }
}
