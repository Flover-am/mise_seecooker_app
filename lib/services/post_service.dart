import 'package:dio/dio.dart';
import 'package:seecooker/models/http_result.dart';

class PostService {
  static const String baseUrl = 'https://mock.apifox.com/m1/3614939-0-default';

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
    final response = await dio.get(lastUrl);
    if(response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }
}