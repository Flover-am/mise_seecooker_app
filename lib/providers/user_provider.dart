import 'package:flutter/cupertino.dart';
import 'package:seecooker/utils/shared_preferences_util.dart';

import '../models/user.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier{
  late User _user = User("未登录1", "未登录", "未登录",[],[],[],false);

  get isLoggedIn => _user.isLoggedIn;

  String get username => _user.username;


  void refreshStatus() async {
    await _initializeUserModel();
    notifyListeners();
  }

  Future<void> _initializeUserModel() async {
    bool isLoggedIn = await SharedPreferencesUtil.getBool("isLoggedIn") ?? false;
    if(isLoggedIn) {
      _user.username = await SharedPreferencesUtil.getString("username");
      _user.password = await SharedPreferencesUtil.getString("password");
      _user.isLoggedIn = true;
      print("User is logged in and name is ${_user.username}");

    }else{
      _user.username = "未登录2";
      _user.password = "未登录";
      _user.isLoggedIn = false;
    }
  }


  Future<void> logout() async{
    _user.username = "未登录";
    _user.password = "未登录";
    _user.isLoggedIn = false;
    await SharedPreferencesUtil.setString("username","未登录");
    await SharedPreferencesUtil.setString("password","未登录");
    await SharedPreferencesUtil.setBool("isLoggedIn", false);
    notifyListeners();
  }

  Future<void> login(String username,String password) async {
    /// 先进行请求，然后从请求中拿数据
    var res =  await UserService.login(username,password);
    /// 判断是否获取成功
    if(!res.isSuccess()){
      throw Exception("登录失败:${res.message}\n${res.code}\n${username+" "+password}");
    }
    _user.username = username;
    _user.password = password;
    _user.isLoggedIn = true;
    await SharedPreferencesUtil.setString("username", username);
    await SharedPreferencesUtil.setString("password", password);
    await SharedPreferencesUtil.setBool("isLoggedIn", true);
    notifyListeners();
  }

  // Future<User> fetchUser(int id) async {
  //   /// 先进行请求，然后从请求中拿数据
  //   var res =  await UserService.login();
  //   /// 判断是否获取成功
  //   if(!res.isSuccess()){
  //     throw Exception("未拿到菜谱数据:${res.message}");
  //   }
  //   /// 将数据转换成Model
  //   _user = User.fromJson(res.data);
  //   return _user;
  // }
}