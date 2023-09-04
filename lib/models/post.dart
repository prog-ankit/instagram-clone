import 'package:image_picker/image_picker.dart';

class Post {
  final String uid;
  final String description;
  final String username;
  final DateTime pubDate;
  final String postId;
  final String postURL;
  final String profImg;
  final List likes;
  Post(
      {required this.uid,
      required this.username,
      required this.description,
      required this.postURL,
      required this.postId,
      required this.pubDate,
      required this.profImg,
      required this.likes});

  Map<String, dynamic> toJSON() => {
        'uid': uid,
        'username': username,
        'description': description,
        'post': postURL,
        'postID': postId,
        'pubDate': pubDate,
        'profImg': profImg,
        'likes': likes,
      };
}
