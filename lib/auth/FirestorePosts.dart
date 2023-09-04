import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/auth/img_storage.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FirestorePost {
  final FirebaseFirestore store = FirebaseFirestore.instance;

  Future<bool> uploadPost(
    String uid,
    String username,
    String prof,
    String description,
    XFile file,
  ) async {
    bool result;

    try {
      String url = await Storage().uploadImage('/posts', file, true);
      String postId = const Uuid().v1();
      Post mypost = Post(
        uid: uid,
        username: username,
        description: description,
        postURL: url,
        postId: postId,
        pubDate: DateTime.now(),
        profImg: prof,
        likes: [],
      );

      store.collection('posts').doc(postId).set(mypost.toJSON());
      result = true;
    } catch (e) {
      result = false;
    }
    return result;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        store.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        store.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> deletePost(String postId) async {
    try {
      await store.collection('posts').doc(postId).delete();
      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot myDoc = await store.collection('users').doc(uid).get();
      List following = myDoc['following'];
      if (following.contains(followId)) {
        store.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        store.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        store.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
        store.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    } catch (e) {}
  }

  Future<bool> postComment(String uid, String username, String comment,
      String postId, String dp) async {
    String commentId = const Uuid().v1();
    if (comment.isNotEmpty) {
      try {
        store
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'uid': uid,
          'profile': dp,
          'username': username,
          'commentId': commentId,
          'comment': comment,
          'datePublished': DateTime.now()
        });

        return true;
      } catch (e) {
        print(e.toString());
      }
    }
    return false;
  }
}
