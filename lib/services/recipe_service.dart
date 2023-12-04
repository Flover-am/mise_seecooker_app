import 'package:dio/dio.dart';
import 'package:seecooker/models/NewRecipe.dart';
import 'package:seecooker/models/http_result.dart';

class RecipeService {
  /// 测试阶段可以先用apiFox的Mock的url
  static const String baseUrl = 'https://mock.apifox.com/m1/3614939-0-default';
  /// 使用Dio进行网络请求
  static var dio = Dio();

  static Future<HttpResult> getRecipes() async {
    String lastUrl = "$baseUrl/recipes";
    final response = await dio.get(lastUrl);
    if(response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }

  static Future<HttpResult> postRecipe(NewRecipe recipe) async {
    String lastUrl = '$baseUrl/recipe';
    /// 将Recipe转换成FormData
    var data = recipe.toFormData();
    /// 发送请求，拿到 Response
    var response = await dio.post(lastUrl, data: data);
    /// 将Response的data转换成封装对象HttpResult
    return HttpResult.fromJson(response.data);
  }

  static Future<HttpResult> getRecipe(int id) async {
    String lastUrl = '$baseUrl/recipe/$id';
    /// 发起get请求，拿到response
    var response = await dio.get(lastUrl);
    /// 将response的data转换为HttpResult返回给上一层
    return HttpResult.fromJson(response.data);
  }
}
