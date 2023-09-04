import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/auth/FirestorePosts.dart';
import 'package:instagramclone/providers/user_provider.dart';
import 'package:instagramclone/utils/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:instagramclone/models/user.dart' as models;

class AddFeed extends StatefulWidget {
  const AddFeed({super.key});

  @override
  State<AddFeed> createState() => _AddFeedState();
}

class _AddFeedState extends State<AddFeed> {
  final TextEditingController descController = TextEditingController();
  bool isLoading = false;

  XFile? file;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    descController.dispose();
  }

  void clearImage() {
    setState(() {
      file = null;
      descController.clear();
    });
  }

  imageSelctor(BuildContext context) {
    return showDialog(
        context: context,
        builder: ((context) {
          return SimpleDialog(
            title: const Text(
              "Create a Post",
              style: TextStyle(color: Colors.blueAccent),
            ),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(30.0),
                onPressed: (() async {
                  Navigator.of(context).pop();
                  XFile? srfile = await selectImage(ImageSource.camera);
                  setState(() {
                    file = srfile;
                  });
                }),
                child: const Text("Take Image"),
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(30.0),
                onPressed: (() async {
                  Navigator.of(context).pop();
                  XFile? srfile = await selectImage(ImageSource.gallery);
                  setState(() {
                    file = srfile;
                  });
                }),
                child: const Text("Choose from gallery"),
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(30.0),
                onPressed: (() {
                  Navigator.of(context).pop();
                }),
                child: const Text("Cancel"),
              ),
            ],
          );
        }));
  }

  void postImage(String uid, String username, String download) async {
    setState(() {
      isLoading = true;
    });
    try {
      bool msg = await FirestorePost()
          .uploadPost(uid, username, download, descController.text, file!);
      print(msg);
      setState(() {
        isLoading = false;
      });
      if (true) {
        showSnackBar('Posted!!', context);
      }
      clearImage();
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final models.User? user = Provider.of<UserProvider>(context).getUser;

    // print(user!.username);
    return file == null
        ? IconButton(
            onPressed: () {
              imageSelctor(context);
            },
            icon: const Icon(Icons.upload),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                  onPressed: () => clearImage(),
                  icon: const Icon(Icons.arrow_back)),
              title: const Text(
                "New Post",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // centerTitle: true, ---> by default false
              actions: [
                TextButton(
                  onPressed: () =>
                      postImage(user!.uid, user.username, user.download),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                isLoading == true
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0)),
                const Divider(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user!.download),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: descController,
                        decoration: const InputDecoration(
                          hintText: "Write a caption...",
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    file!.path,
                                  ),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.center)),
                        ),
                      ),
                    ),
                    const Divider()
                  ],
                )
              ],
            ),
          );
  }
}
