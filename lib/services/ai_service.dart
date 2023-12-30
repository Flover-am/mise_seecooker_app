import 'package:dio/dio.dart';
import 'package:seecooker/models/http_result.dart';
import 'package:seecooker/utils/server_url_util.dart';

class AiService {
  static const String baseUrl = ServerUrlUtil.baseUrl;

  static Dio dio = Dio();

  static Future<HttpResult> getAiResponse(String query) async {
    // TODO: 实现大模型访问
    // String lastUrl = '';
    // final response = await dio.get(lastUrl);
    // if(response.statusCode == 200) {
    //   return HttpResult.fromJson(response.data);
    // } else {
    //   throw Exception('Network exception: ${response.statusCode}');
    // }
    await Future.delayed(Duration(milliseconds: 1000));
    return HttpResult(0, 'success', '大模型返回值');
  }
}