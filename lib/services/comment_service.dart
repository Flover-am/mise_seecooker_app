import 'package:dio/dio.dart';
import 'package:seecooker/models/http_result.dart';
import 'package:seecooker/utils/sa_token_util.dart';
import 'package:seecooker/utils/server_url_util.dart';

class CommentService {
  static const String baseUrl = ServerUrlUtil.baseUrl;

  static Dio dio = Dio();

  static Future<HttpResult> getComments(int postId) async {
    String lastUrl = '$baseUrl/comments/$postId';
    final response = await dio.get(lastUrl);
    if(response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }

  static Future<HttpResult> postComment(int postId, String content) async {
    String lastUrl = '$baseUrl/comment';
    Options testOpt = Options(headers: {
      await SaTokenUtil.getTokenName():
      await SaTokenUtil.getTokenValue()
    });
    final response = await dio.post(
      lastUrl,
      data: {
        'postId': postId,
        'content': content,
      },
      options: testOpt
    );
    if(response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }
}