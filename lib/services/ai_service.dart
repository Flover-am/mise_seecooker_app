import 'package:dio/dio.dart';
import 'package:seecooker/models/http_result.dart';
import 'package:seecooker/utils/server_url_util.dart';

class AiService {
  static const String baseUrl = "${ServerUrlUtil.baseUrl}/recipe/llm";

  static Dio dio = Dio();

  static Future<HttpResult> getAiResponse(String query) async {
    String lastUrl = baseUrl;
    final response = await dio.get(lastUrl, queryParameters: {'prompt': query});
    if(response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }
}