import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagramclone/providers/user_provider.dart';
import 'package:instagramclone/responsive_layout/mobile_screen.dart';
import 'package:instagramclone/responsive_layout/responsive_screen.dart';
import 'package:instagramclone/responsive_layout/web_screen.dart';
import 'package:instagramclone/screens/login_screen.dart';
import 'package:provider/provider.dart';

// flutter23@gmail.com
// flutter23
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme:
              ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
          home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return const SafeArea(
                      child: ResponsiveLayout(
                        webScreen: webScreen(),
                        mobileScreen: mobileScreen(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  }
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }
                // else
                return const LoginScreen();
              })

              // const Scaffold(
              //     body: SafeArea(
              //   child: ResponsiveLayout(
              //       webScreen: webScreen(), mobileScreen: mobileScreen()),
              // ))
              )),
    );
  }
}
