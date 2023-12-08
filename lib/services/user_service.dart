import 'dart:io';

import 'package:dio/dio.dart';
import 'package:seecooker/models/http_result.dart';


class UserService {
  /// 测试阶段可以先用apiFox的Mock的url
  static const String baseUrl =
      'https://mock.apifox.com/m1/3614939-0-default';
  /// 使用Dio进行网络请求
  static var dio = Dio();

  static Future<HttpResult> login(String username,String password) async {
    String requestUrl = "$baseUrl/session";
    var data =  FormData.fromMap({
      "username": username,
      "password": password,
    });
    /// 发送请求，拿到 Response
    var response = await dio.post(requestUrl, data: data);
    /// 将Response的data转换成封装对象HttpResult
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

  static Future<HttpResult> register(String username,String password, File avatar) async {
    String requestUrl = "$baseUrl/user";
    var data =  FormData.fromMap({
      "username": username,
      "password": password,
      "avatar": await MultipartFile.fromFile(avatar.path),
    });
    /// 发送请求，拿到 Response
    var response = await dio.post(requestUrl, data: data);
    /// 将Response的data转换成封装对象HttpResult
    return HttpResult.fromJson(response.data);
  }
}
