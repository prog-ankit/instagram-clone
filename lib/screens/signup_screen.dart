import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/auth/database.dart';
import 'package:instagramclone/screens/login_screen.dart';
import 'package:instagramclone/utils/dimensions.dart';

import '../responsive_layout/mobile_screen.dart';
import '../responsive_layout/responsive_screen.dart';
import '../responsive_layout/web_screen.dart';
import '../widgets/text_form_field.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController mailController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  XFile? img;
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mailController.dispose();
    pwdController.dispose();
    bioController.dispose();
    userController.dispose();
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthService().signUpUser(
      email: mailController.text,
      password: pwdController.text,
      username: userController.text,
      bio: bioController.text,
      profile: img!,
    );
    setState(() {
      isLoading = false;
    });
    if (res != 'Success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: ((context) => const ResponsiveLayout(
              webScreen: webScreen(), mobileScreen: mobileScreen()))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(32.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Image.asset(
                'assets/instagram.png',
                color: Colors.white,
                height: 64,
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  imagePicker();
                },
                child: img != null
                    ? CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(img!.path),
                      )
                    : const CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(
                            'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg'),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextInputField(
                  textEditingController: userController,
                  hint: 'Enter Username',
                  textInputType: TextInputType.emailAddress),
              const SizedBox(
                height: 10,
              ),
              TextInputField(
                textEditingController: mailController,
                hint: 'Enter Mail',
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 20,
              ),
              TextInputField(
                textEditingController: pwdController,
                hint: 'Enter Password',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(
                height: 20,
              ),
              TextInputField(
                textEditingController: bioController,
                hint: 'Enter Bio',
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () => signUpUser(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      color: Colors.blue),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text('Sign up'),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an Account? "),
                  GestureDetector(
                    onTap: navigateLogin,
                    child: const Text(
                      "Login",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  navigateLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => const LoginScreen())));
  }

  void imagePicker() async {
    XFile? myImg = await selectImage(ImageSource.gallery);
    setState(() {
      img = myImg;
    });
  }

  // selectImage() async {
  //   final ImagePicker imagePicker = ImagePicker();
  //   XFile? myImg = await imagePicker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     img = myImg;
  //   });
  // }
}
