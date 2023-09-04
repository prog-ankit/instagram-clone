import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:instagramclone/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../models/user.dart' as models;

class mobileScreen extends StatefulWidget {
  const mobileScreen({super.key});

  @override
  State<mobileScreen> createState() => _mobileScreenState();
}

class _mobileScreenState extends State<mobileScreen> {
  // String username = "";
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getUsername();
  // }

  // void getUsername() async {
  //   DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  // }

  @override
  Widget build(BuildContext context) {
    // user == null ? print("1") : print("2");
    // models.User? user = Provider.of<UserProvider>(context).getUser;

    // try {
    //   user =

    //   print("TEst ==>");
    //   print("HEYYY -- ${user!.username}");
    //   // if (user == null) {
    //   print("ITZZ MEE ==>");
    //   // } else {
    //   // print("ITZZ NOT MEE ==>");
    //   // }
    // } catch (e) {
    //   print("Exception here ==> ${e.toString()}");
    // }
    return Scaffold(
      body: Center(
          // child: Text("Hello ${user!.username}"),
          ),
    );
  }
}
