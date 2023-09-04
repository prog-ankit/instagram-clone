import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/providers/user_provider.dart';
import 'package:instagramclone/screens/add_feed.dart';
import 'package:instagramclone/screens/feed_screen.dart';
import 'package:instagramclone/screens/profile_screen.dart';
import 'package:instagramclone/screens/search_screen.dart';
import 'package:provider/provider.dart';

import '../models/user.dart' as models;

class webScreen extends StatefulWidget {
  const webScreen({super.key});

  @override
  State<webScreen> createState() => _webScreenState();
}

class _webScreenState extends State<webScreen> {
  // String name = "";
  // @override
  // void initState() {
  // TODO: implement initState
  //   super.initState();
  //   getUsername();
  // }

  // void getUsername() async {
  //   DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();

  //   // print(documentSnapshot.data());
  //   setState(() {
  //     name = (documentSnapshot.data() as Map<String, dynamic>)['username'];
  //   });
  // }
  // @override
  // void initState() {
  // TODO: implement initState
  //   super.initState();
  //   setState(() {
  //   });
  // }
  int page = 0;

  late PageController _pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  void navTapped(int page) {
    _pageController.jumpToPage(page);
  }

  void onPageChanged(int val) {
    setState(() {
      page = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    models.User? user;
    try {
      user = Provider.of<UserProvider>(context).getUser;
    } catch (e) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const FeedScreen(),
          const SearchScreen(),
          const AddFeed(),
          const Text('Favorite'),
          ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: page == 0 ? Colors.white : Colors.grey,
            ),
            label: '',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: page == 1 ? Colors.white : Colors.grey,
            ),
            label: '',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: page == 2 ? Colors.white : Colors.grey,
            ),
            backgroundColor: Colors.black,
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: page == 3 ? Colors.white : Colors.grey,
            ),
            label: '',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: page == 4 ? Colors.white : Colors.grey,
            ),
            label: '',
            backgroundColor: Colors.black,
          ),
        ],
        onTap: navTapped,
      ),
    );
  }
}
