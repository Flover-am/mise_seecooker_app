import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:seecooker/models/http_result.dart';
import 'package:seecooker/utils/sa_token_util.dart';
import 'package:seecooker/utils/server_url_util.dart';

class CommunityService {
  static const String baseUrl = "${ServerUrl.baseUrl}/community";

  static Dio dio = Dio();

  /// 获取帖子
  static Future<HttpResult> getPosts() async {
    String lastUrl = '$baseUrl/posts';
    final response = await dio.get(lastUrl);
    log(response.data);
    if(response.statusCode == 200) {
        return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }

  /// 查看帖子
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

  /// 点赞或取消点赞帖子
  static Future<HttpResult> likePost(int postId) async {
    String lastUrl = '$baseUrl/post/like/$postId';
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

  /// 删除帖子
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

  /// 分页获取帖子
  static Future<HttpResult> getPostsByPage(int pageNo) async {
    String lastUrl = '$baseUrl/posts/page/$pageNo';
    final response = await dio.get(lastUrl);
    if(response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }

  /// 获取帖子评论
  static Future<HttpResult> getComments(int postId) async {
    String lastUrl = '$baseUrl/comments/$postId';
    final response = await dio.get(lastUrl);
    if(response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }

  /// 发布评论
  static Future<HttpResult> postComment(int postId, String content) async {
    String lastUrl = '$baseUrl/comment';
    Options options = Options(headers: {
      await SaTokenUtil.getTokenName():
      await SaTokenUtil.getTokenValue()
    });
    final response = await dio.post(
        lastUrl,
        data: {
          'postId': postId,
          'content': content,
        },
        options: options
    );
    if(response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }

  /// 发布帖子
  static Future<HttpResult> publishPost(String title, String content, List<String> filePath) async {
    String tokenName = await SaTokenUtil.getTokenName();
    String tokenValue = await SaTokenUtil.getTokenValue();
    BaseOptions publishOptions=BaseOptions(
        baseUrl: baseUrl,
        headers:{
          tokenName: tokenValue
        }
    );
    dio.options=publishOptions;
    //构建FormData
    final FormData formData =FormData.fromMap(
        {
          'title': title,
          'content': content
        }
    );
    for(String singleFilePath in filePath){
      MultipartFile multipartFile = await MultipartFile.fromFile(singleFilePath, filename: singleFilePath.split('/').last);
      formData.files.add(MapEntry("images",multipartFile));
    }
    //发送请求并等待回复
    final response = await dio.post(
        '/post',
        data: formData
    );
    if(response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network Exception: ${response.statusCode}');
    }
  }
}