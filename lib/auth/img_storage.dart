import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class Storage {
  final FirebaseStorage fireStore = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<String> uploadImage(String childName, XFile file, bool isPost) async {
    Reference ref =
        fireStore.ref().child(childName).child(auth.currentUser!.uid);

    if (isPost) {
      String pId = const Uuid().v1();
      print(pId);
      ref = ref.child(pId);
      // print("My PATH HELL THIS ${ref.fullPath}");
    }
    final fileBytes = file.readAsBytes();

    UploadTask upload = ref.putData(await fileBytes);
    TaskSnapshot snapshot = await upload;
    String downloadURL = await snapshot.ref.getDownloadURL();

    // print("From imgStore => $downloadURL");
    return downloadURL;
  }
}
