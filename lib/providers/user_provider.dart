import 'package:flutter/material.dart';
import 'package:instagramclone/auth/database.dart';
import 'package:instagramclone/models/user.dart';

class UserProvider extends ChangeNotifier {
  late User? _user;

  User? get getUser => _user;

  Future<void> refreshUser() async {
    _user = await AuthService().getUserDetails();
    notifyListeners();
  }
}
