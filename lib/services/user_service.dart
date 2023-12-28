import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:seecooker/models/http_result.dart';
import 'package:seecooker/utils/server_url_util.dart';

import '../utils/shared_preferences_util.dart';


class UserService {
  /// 测试阶段可以先用apiFox的Mock的url
  static const String baseUrl = ServerUrlUtil.baseUrl;
  /// 使用Dio进行网络请求
  static var dio = Dio();

  static Future<HttpResult> login(String username, String password) async {
    String requestUrl = "$baseUrl/session";


    Map<String, dynamic> requestData = {
      "username": username,
      "password": password,
    };

    dio.options.headers['Content-Type'] = 'application/json'; // Set the request content type to JSON

    var response = await dio.post(requestUrl, data: jsonEncode(requestData));

    return HttpResult.fromJson(response.data);
  }

  static Future<HttpResult> logout(String tokenName) async {
    String requestUrl = "$baseUrl/session";
    var data =  FormData.fromMap({
      "tokenName": tokenName,
    });
    /// 发送请求，拿到 Response
    var response = await dio.delete(requestUrl, data: data);
    /// 将Response的data转换成封装对象HttpResult
    return HttpResult.fromJson(response.data);
  }

  static Future<HttpResult> getUserById(int id) async {
    String requestUrl = "$baseUrl/user/$id";


    /// 发起get请求，拿到response
    var response = await dio.get(requestUrl);
    /// 将response的data转换为HttpResult返回给上一层
    return HttpResult.fromJson(response.data);
  }

  static Future<HttpResult> getUser() async {
    String requestUrl = "$baseUrl/user";
    Options testOpt = Options(headers: {
      await SharedPreferencesUtil.getString("tokenName"):
      await SharedPreferencesUtil.getString("tokenValue")
    });

    /// 发起get请求，拿到response
    var response = await dio.get(requestUrl,options: testOpt);
    /// 将response的data转换为HttpResult返回给上一层
    return HttpResult.fromJson(response.data);
  }

  static Future<HttpResult> register(String username,String password, String avatarFile) async {
    String requestUrl = "$baseUrl/user";
    final FormData formData =FormData.fromMap(
{     "username": username,
      "password": password,
    });
    MultipartFile multipartFile = await MultipartFile.fromFile(avatarFile,filename:avatarFile.split('/').last);
    formData.files.add(MapEntry("avatar",multipartFile));
    var data = formData;

    /// 发送请求，拿到 Response
    var response = await dio.post(requestUrl, data: data);
    /// 将Response的data转换成封装对象HttpResult
    return HttpResult.fromJson(response.data);
  }


  static Future<HttpResult> modifyUsername(String username,String newname) async {
    String requestUrl = "$baseUrl/modify/username";
    Options testOpt = Options(headers: {
      await SharedPreferencesUtil.getString("tokenName"):
      await SharedPreferencesUtil.getString("tokenValue")
    });


    final FormData formData =FormData.fromMap(
        {     "username": username,
              "newname": newname,
        });

    var data = formData;

    /// 发送请求，拿到 Response
    var response = await dio.post(requestUrl, data: data,options: testOpt);
    /// 将Response的data转换成封装对象HttpResult
    return HttpResult.fromJson(response.data);
  }

  static Future<HttpResult> modifyAvatar(String username,String avatar) async {
    String requestUrl = "$baseUrl/modify/avatar";
    Options testOpt = Options(headers: {
      await SharedPreferencesUtil.getString("tokenName"):
      await SharedPreferencesUtil.getString("tokenValue")
    });

    final FormData formData =FormData.fromMap(
        {  "username": username,
        });
    MultipartFile multipartFile = await MultipartFile.fromFile(avatar,filename:avatar.split('/').last);
    formData.files.add(MapEntry("avatar",multipartFile));
    var data = formData;

    /// 发送请求，拿到 Response
    var response = await dio.post(requestUrl, data: data,options: testOpt);
    /// 将Response的data转换成封装对象HttpResult
    return HttpResult.fromJson(response.data);
  }

  static Future<HttpResult> modifyPassword(String username,String password, String newPassword) async {
    String requestUrl = "$baseUrl/modify/password";


    final FormData formData =FormData.fromMap(
        {  "username": username,
          "password":password,
          "newPassword":newPassword,
        });

    var data = formData;

    /// 发送请求，拿到 Response
    var response = await dio.post(requestUrl, data: data);
    /// 将Response的data转换成封装对象HttpResult
    return HttpResult.fromJson(response.data);
  }


}
