import 'package:dio/dio.dart';
import 'package:seecooker/models/http_result.dart';

class CommentService {
  static const String baseUrl = 'https://mock.apifox.com/m1/3614939-0-default';

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
    final response = await dio.post(
      lastUrl,
      data: {
        'postId': postId,
        'content': content,
      },
    );
    if(response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }
}