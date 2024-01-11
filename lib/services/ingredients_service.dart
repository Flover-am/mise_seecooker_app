
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:seecooker/models/Ingredients.dart';
import 'package:seecooker/models/http_result.dart';
import 'package:seecooker/utils/server_url_util.dart';


class IngredientsService {
  static const String baseUrl =ServerUrlUtil.baseUrl;

  static Dio dio = Dio();
  static Future<HttpResult> getIngredients() async {
    List<Ingredients> ingredients = [];
    String lastUrl = '$baseUrl/recipe/ingredients';
    final response = await dio.get(lastUrl);
    if(response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }

  }


}