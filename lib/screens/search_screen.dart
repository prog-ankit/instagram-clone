import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagramclone/screens/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool showUsers = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
                hintText: 'Search for user', border: InputBorder.none),
            onFieldSubmitted: ((value) {
              setState(() {
                showUsers = true;
              });
            }),
          ),
        ),
        body: showUsers == true
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username', isGreaterThanOrEqualTo: _controller.text)
                    .get(),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                      padding: EdgeInsets.only(top: 5),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        return InkWell(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                      uid: snapshot.data!.docs[index]["uid"]))),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  snapshot.data!.docs[index]["photoURL"]),
                            ),
                            title: Text(snapshot.data!.docs[index]["username"]),
                          ),
                        );
                      }));
                }))
            : Text("data"));
  }
}
