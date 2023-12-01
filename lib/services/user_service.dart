import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';


import 'package:seecooker/models/http_result.dart';
import 'package:seecooker/models/user.dart';


class UserService {
  /// 测试阶段可以先用apiFox的Mock的url
  static const String baseUrl =
      'https://mock.apifox.com/m1/3614939-0-default/session';
  /// 使用Dio进行网络请求
  static var dio = Dio();



  static Future<HttpResult> login(String username,String password) async {

    var data =  FormData.fromMap({
      "username": username,
      "password": password,
    });

    /// 发送请求，拿到 Response
    var response = await dio.post(baseUrl, data: data);
    /// 将Response的data转换成封装对象HttpResult
    return HttpResult.fromJson(response.data);
  }

  // static Future<HttpResult> getUser(int id) async {
  //   String lastUrl = "$baseUrl/$id";
  //   /// 发起get请求，拿到response
  //   var response = await dio.get(lastUrl);
  //   /// 将response的data转换为HttpResult返回给上一层
  //   return HttpResult.fromJson(response.data);
  // }
}
