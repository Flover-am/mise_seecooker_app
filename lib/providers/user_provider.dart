import 'package:flutter/cupertino.dart';
import 'package:seecooker/utils/shared_preferences_util.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier{
  late UserModel _userModel = UserModel("未登录", "未登录", false);

  void refreshStatus() async {
    await _initializeUserModel();
    notifyListeners();
  }

  Future<void> _initializeUserModel() async {
    bool isLoggedIn = await SharedPreferencesUtil.getBool("isLoggedIn") ?? false;
    if(isLoggedIn) {
      _userModel.username = "admin";
      _userModel.password = "123456";
      _userModel.isLoggedIn = true;
    }else{
      _userModel.username = "未登录";
      _userModel.password = "未登录";
      _userModel.isLoggedIn = false;
    }
  }

  get isLoggedIn => _userModel.isLoggedIn;

  String get username => _userModel.username;

  void loginAdmin(){
    _userModel.username = "admin";
    _userModel.password = "123456";
    _userModel.isLoggedIn = true;
    SharedPreferencesUtil.setString("username","admin");//
    SharedPreferencesUtil.setString("password","123456");
    SharedPreferencesUtil.setBool("isLoggedIn", true);
    notifyListeners();
  }

  void logout(){
    _userModel.username = "未登录";
    _userModel.password = "未登录";
    _userModel.isLoggedIn = false;
    SharedPreferencesUtil.setString("username","未登录");
    SharedPreferencesUtil.setString("password","未登录");
    SharedPreferencesUtil.setBool("isLoggedIn", false);
    notifyListeners();
  }
}