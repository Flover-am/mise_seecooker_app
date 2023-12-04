import 'package:flutter/cupertino.dart';
import 'package:seecooker/utils/shared_preferences_util.dart';

import '../models/user.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier{
  late User _user = User("未登录", "未登录", "未登录",[],[],[],false);
  get isLoggedIn => _user.isLoggedIn;
  String get username => _user.username;


  Future<void> loadLoginStatus() async {
    _user.username = await SharedPreferencesUtil.getString("username");
    _user.password = await SharedPreferencesUtil.getString("password");
    _user.isLoggedIn = await SharedPreferencesUtil.getBool("isLoggedIn");
    notifyListeners();
  }

  Future<void> login(String username,String password) async {
    /// 先进行请求，然后从请求中拿数据
    var res =  await UserService.login(username,password);
    /// 判断是否获取成功
    if(!res.isSuccess()){
      throw Exception("登录失败:${res.message}");
    }
    _user.username = username;
    _user.password = password;
    _user.isLoggedIn = true;
    await SharedPreferencesUtil.setString("username", username);
    await SharedPreferencesUtil.setString("password", password);
    await SharedPreferencesUtil.setBool("isLoggedIn", true);
    notifyListeners();
  }

  Future<void> logout() async {
      _user.username = "未登录";
      _user.password = "未登录";
      _user.isLoggedIn = false;
      SharedPreferencesUtil.setString("username","未登录");
      SharedPreferencesUtil.setString("password","未登录");
      SharedPreferencesUtil.setBool("isLoggedIn", false);
      notifyListeners();
  }


  // Future<void> logout() async{
  //   var res =  await UserService.logout(_user.tokenName);
  //   if(!res.isSuccess()){
  //     throw Exception("登出失败:${res.message}");
  //   }
  //   _user.username = "未登录";
  //   _user.password = "未登录";
  //   _user.isLoggedIn = false;
  //   SharedPreferencesUtil.setString("username","未登录");
  //   SharedPreferencesUtil.setString("password","未登录");
  //   SharedPreferencesUtil.setBool("isLoggedIn", false);
  //   notifyListeners();
  // }

  Future<User> getUserById(int id) async {
    /// 先进行请求，然后从请求中拿数据
    var res =  await UserService.getUserById(id);
    /// 判断是否获取成功
    if(!res.isSuccess()){
      throw Exception("未成功获取用户:${res.message}");
    }
    /// 将数据转换成Model
    _user = User.fromJson(res.data);
    return _user;
  }
}