import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/auth/FirestorePosts.dart';
import 'package:instagramclone/models/user.dart';
import 'package:instagramclone/providers/user_provider.dart';
import 'package:instagramclone/widgets/follow_button.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  int postLen = 0;
  int followersCount = 0;
  int followingCount = 0;

  bool isLoading = false;
  bool isFollowing = false;
  User? currUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    try {
      setState(() {
        currUser = Provider.of<UserProvider>(context, listen: false).getUser;
      });
    } catch (e) {
      print(e.toString());
    }

    getData();
  }

  void getData() async {
    // Fetch data from firestore
    DocumentSnapshot snapUser = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();
    // print((snapUser.data() as dynamic)['uid']);
    // print(snapUser['uid']);
    setState(() {
      //Stores the data of profile we are visiting
      user = User.fromJson(snapUser);
      followersCount = user!.followers.length;
      followingCount = user!.following.length;
    });

    var snapPost = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: widget.uid)
        .get();
    postLen = snapPost.docs.length;
    isFollowing = user!.following.contains(currUser!.uid);
    setState(() {
      isLoading = false;
    });

    // print(postLen.toString());
    // print(snap);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: Text(user!.username),
              backgroundColor: Colors.black,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(user!.download),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildColumns(postLen, 'Posts'),
                                    buildColumns(followersCount, 'Followers'),
                                    buildColumns(followingCount, 'Following'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    currUser!.uid == widget.uid
                                        ? FollowButton(
                                            function: () {},
                                            text: "Edit Profile",
                                            txtColor: Colors.white,
                                            btnColor: Colors.black,
                                            borderColor: Colors.grey,
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                function: () async {
                                                  await FirestorePost()
                                                      .followUser(currUser!.uid,
                                                          widget.uid);

                                                  setState(() {
                                                    isFollowing = false;
                                                    followersCount--;
                                                  });
                                                },
                                                text: "Unfollow",
                                                txtColor: Colors.black,
                                                btnColor: Colors.white,
                                                borderColor: Colors.grey,
                                              )
                                            : FollowButton(
                                                function: () async {
                                                  await FirestorePost()
                                                      .followUser(currUser!.uid,
                                                          widget.uid);

                                                  setState(() {
                                                    isFollowing = true;
                                                    followersCount++;
                                                  });
                                                },
                                                text: "Follow",
                                                txtColor: Colors.white,
                                                btnColor: Colors.blue,
                                                borderColor: Colors.blue,
                                              ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      //Username-Bio Section (Below User DP)
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          user!.username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          user!.bio,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return GridView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          mainAxisExtent:
                              MediaQuery.of(context).size.width * 0.195,
                        ),
                        itemBuilder: ((context, index) {
                          DocumentSnapshot docSnap = snapshot.data!.docs[index];
                          // print(docSnap);
                          return Container(
                            padding: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                docSnap['post'],
                              ),
                            )),
                          );
                        }));
                  }),
                )
              ],
            ),
          );
  }

  Column buildColumns(int num, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5.0),
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
