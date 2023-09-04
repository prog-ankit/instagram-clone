import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/providers/user_provider.dart';
import 'package:instagramclone/utils/dimensions.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreen;
  final Widget mobileScreen;

  const ResponsiveLayout(
      {super.key, required this.webScreen, required this.mobileScreen});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userChange();
  }

  userChange() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreensize) {
          return widget.webScreen;
        }
        return widget.mobileScreen;
      },
    );

    // return FutureBuilder<User?>(
    //     future: UserProvider().refreshUser(),
    //     builder: ((context, snapshot) {
    //       if (snapshot.hasData) {
    //         print("Success");
    //         return webScreen();
    //       } else {
    //         print("Faile");
    //         return Center(child: CircularProgressIndicator());
    //       }
    //     }));
  }
}
