import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool alreadyUser = true;
  void toogleUser() {
    alreadyUser = !alreadyUser;
    notifyListeners();
  }
}
