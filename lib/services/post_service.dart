import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:seecooker/models/http_result.dart';
import 'package:seecooker/utils/sa_token_util.dart';
import 'package:seecooker/utils/server_url_util.dart';

class PostService {
  static const String baseUrl = ServerUrlUtil.baseUrl;

  static Dio dio = Dio();

  static Future<HttpResult> getPosts() async {
    String lastUrl = '$baseUrl/posts';
    final response = await dio.get(lastUrl);
    if(response.statusCode == 200) {
        return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }

  static Future<HttpResult> getPostDetail(int postId) async {
    String lastUrl = '$baseUrl/post/$postId';

    Options? options;
    try {
      options = Options(headers: {
        await SaTokenUtil.getTokenName():
        await SaTokenUtil.getTokenValue()
      });
    } catch (e) {
      log("用户未登录");
    }

    final response = await dio.get(lastUrl, options: options);
    if(response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }

  static Future<HttpResult> likePost(int postId) async {
    String lastUrl = '$baseUrl/post/like/$postId';
    // TODO: add token
    Options options = Options(headers: {
      await SaTokenUtil.getTokenName():
      await SaTokenUtil.getTokenValue()
    });
    final response = await dio.put(lastUrl, options: options);
    if(response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }

  static Future<HttpResult> deletePost(int postId) async {
    String lastUrl = '$baseUrl/post/$postId';
    Options options = Options(headers: {
      await SaTokenUtil.getTokenName():
      await SaTokenUtil.getTokenValue()
    });
    final response = await dio.delete(lastUrl, options: options);
    if(response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }

  static Future<HttpResult> getPostsByPage(int pageNo) async {
    String lastUrl = '$baseUrl/posts/page/$pageNo';
    final response = await dio.get(lastUrl);
    if(response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }
}