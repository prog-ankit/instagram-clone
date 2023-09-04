import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/auth/FirestorePosts.dart';
import 'package:instagramclone/models/user.dart';
import 'package:instagramclone/providers/user_provider.dart';
import 'package:instagramclone/utils/dimensions.dart';
import 'package:instagramclone/widgets/comment_card.dart';
import 'package:instagramclone/widgets/text_form_field.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({super.key, required this.snap});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: InkWell(
            onTap: (() {
              Navigator.pop(context);
            }),
            child: const Icon(Icons.arrow_back)),
        title: const Text("Comments"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.snap['postID'])
              .collection('comments')
              .orderBy('datePublished', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: ((context, index) {
                  return CommentCard(
                    snap: snapshot.data!.docs[index],
                  );
                }));
          }),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(left: 8, right: 16),
        child: Row(
          children: [
            //User-profile Image
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(user!.download),
            ),

            //Comment Textfield
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: "Comment as ${user.username}",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            //Post Button
            TextButton(
              onPressed: () async {
                bool res = await FirestorePost().postComment(
                    user.uid,
                    user.username,
                    commentController.text,
                    widget.snap['postID'],
                    user.download);

                commentController.clear();
                if (res) {
                  showSnackBar('Comment Posted!', context);
                } else {
                  print("Failed to Post");
                }
              },
              child: const Text(
                "Post",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
