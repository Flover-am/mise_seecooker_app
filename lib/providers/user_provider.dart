import 'package:flutter/cupertino.dart';
import 'package:seecooker/models/user_login.dart';
import 'package:seecooker/utils/sa_token_util.dart';
import 'package:seecooker/utils/shared_preferences_util.dart';

import '../models/user.dart';
import '../models/user_info.dart';
import '../services/user_service.dart';
import 'dart:io';

class UserProvider extends ChangeNotifier{
  var defaultAvatar = "https://seecooker.oss-cn-shanghai.aliyuncs.com/avatar/ecff12a2-2986-4bd9-a393-cf8f1065397f.webp";
  late User _user = User("未登录", "未登录", defaultAvatar,"请填写一段用户描述",[],[],[],999,999,"","",false);
  late UserLogin _userLogin;
  late UserInfo _userInfo;
  get isLoggedIn => _user.isLoggedIn;
  String get username => _user.username;

  String get password => _user.password;

  String get description => _user.description;

  int get postNum => _user.postNum;

  int get getLikedNum => _user.getLikedNum;

  String get avatar => _user.avatar;


  Future<void> loadLoginStatus() async {
    _user.username = await SharedPreferencesUtil.getString("username");
    _user.password = await SharedPreferencesUtil.getString("password");
    login(username, password);
    notifyListeners();
  }

  Future<void> login(String username,String password) async {
    /// 先进行请求，然后从请求中拿数据
    var res =  await UserService.login(username,password);
    /// 判断是否获取成功
    if(!res.isSuccess()){
      throw Exception("登录失败:${res.message}");
    }
    _userLogin = UserLogin.fromJson(res.data);


    var tempTokenName;
    var tempTokenValue;

    tempTokenName = _userLogin.tokenName;
    tempTokenValue = _userLogin.tokenValue;

    _user.username = username;
    _user.password = password;
    _user.isLoggedIn = true;
    _user.tokenName = tempTokenName;
    _user.tokenValue = tempTokenValue;
    print("tokenName: "+tempTokenName);
    print("tokenValue: "+tempTokenValue);
    await SharedPreferencesUtil.setString("username", username);
    await SharedPreferencesUtil.setString("password", password);
    await SharedPreferencesUtil.setBool("isLoggedIn", true);

    await SharedPreferencesUtil.setString("tokenName", tempTokenName);
    await SharedPreferencesUtil.setString("tokenValue", tempTokenValue);

    SaTokenUtil.refreshToken();

    getUser();

    notifyListeners();
  }

  Future<void> logout() async {
      _user.username = "未登录";
      _user.password = "未登录";
      _user.isLoggedIn = false;
      _user.tokenName = "";
      _user.tokenValue = "";
      _user.avatar = defaultAvatar;
      SharedPreferencesUtil.setString("username","未登录");
      SharedPreferencesUtil.setString("password","未登录");
      SharedPreferencesUtil.setBool("isLoggedIn", false);
      SharedPreferencesUtil.setString("tokenName","");
      SharedPreferencesUtil.setString("tokenValue","");
      SharedPreferencesUtil.setString("description", "请填写一段用户描述");
      notifyListeners();
  }

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

  Future<void> getUser() async {
    /// 先进行请求，然后从请求中拿数据
    var res =  await UserService.getUser();
    /// 判断是否获取成功
    if(!res.isSuccess()){
      throw Exception("未成功获取用户:${res.message}");
    }
    /// 将数据转换成Model
    _userInfo = UserInfo.fromJson(res.data);
    _user.username = _userInfo.username;
    _user.postNum = _userInfo.postNum;
    _user.getLikedNum = _userInfo.getLikedNum;
    _user.avatar = _userInfo.avatar;
    notifyListeners();

  }

  Future<bool> register(String username,String password, String avatarFile) async {
    /// 先进行请求，然后从请求中拿数据
    var res =  await UserService.register(username,password,avatarFile);
    print("返回的注册信息： "+res.message);
    
    /// 判断是否获取成功
    if(!res.isSuccess()){
      return false;
    }
    return true;
  }


  Future<bool> modifyUsername(String username,String newname) async {
    /// 先进行请求，然后从请求中拿数据
    var res =  await UserService.modifyUsername(username,newname);

    /// 判断是否获取成功
    if(!res.isSuccess()){
      return false;
    }
    getUser();

    await SharedPreferencesUtil.setString("username",newname);
    return true;
  }

  Future<bool> modifyAvatar(String username,String avatar) async {
    /// 先进行请求，然后从请求中拿数据
    var res =  await UserService.modifyAvatar(username,avatar);

    /// 判断是否获取成功
    if(!res.isSuccess()){
      return false;
    }
    getUser();
    return true;
  }

  Future<bool> modifyPassword(String username,String password,String newPassword) async {
    /// 先进行请求，然后从请求中拿数据
    var res =  await UserService.modifyPassword(username,password,newPassword);

    /// 判断是否获取成功
    if(!res.isSuccess()){
      return false;
    }
    getUser();
    await SharedPreferencesUtil.setString("password",newPassword);

    return true;
  }

}