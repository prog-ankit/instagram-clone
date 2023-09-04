import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/auth/img_storage.dart';
import 'package:instagramclone/models/user.dart' as model;

class AuthService {
  final auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User? myuser = auth.currentUser!;

    DocumentSnapshot snaps =
        await firestore.collection('users').doc(myuser.uid).get();

    return model.User.fromJson(snaps);
  }

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required XFile profile}) async {
    String res = "Error!! cannot Register";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        UserCredential creds = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        res = creds.user!.uid;

        String download =
            await Storage().uploadImage('profilePics', profile, false);

        model.User user = model.User(
            username: username,
            email: email,
            uid: res,
            download: download,
            bio: bio,
            followers: [],
            following: []);

        firestore.collection('users').doc(res).set(user.toJSON());
      }
    } catch (e) {
      res = e.toString();
    }
    print("Result is $res");
    // print(res);
    return "Success";
  }

  Future<bool> loginUser(
      {required String email, required String password}) async {
    bool result = false;

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        result = true;
        print("Success");
      } else {
        print("Mention All the fields!!");
      }
    } catch (e) {
      print(e.toString());
    }

    return result;
  }
}
