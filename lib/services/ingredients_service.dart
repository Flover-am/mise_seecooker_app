
import 'package:dio/dio.dart';
import 'package:seecooker/utils/server_url_util.dart';

class ExploreService {
  static const String baseUrl = ServerUrlUtil.mockUrl;

  static Dio dio = Dio();
  // static Future<String> fetchAllIngredients() async {}
}