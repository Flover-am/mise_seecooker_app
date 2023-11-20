import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  String username = "未登录";
  String password = "未登录";
  bool isLoggedIn = false;

  void loginAdmin(){
    username = "admin";
    password = "123456";
    isLoggedIn = true;
    notifyListeners();
  }
}