import 'package:dio/dio.dart';
import 'package:seecooker/models/NewRecipe.dart';
import 'package:seecooker/models/http_result.dart';
import 'package:seecooker/utils/server_url_util.dart';
import 'package:seecooker/utils/shared_preferences_util.dart';
import 'package:seecooker/utils/sa_token_util.dart';

class RecipeService {
  /// 测试阶段可以先用apiFox的Mock的url
  static const String baseUrl = ServerUrlUtil.baseUrl;

  /// 使用Dio进行网络请求
  static Dio dio = Dio();

  static Future<HttpResult> getRecipes() async {
    String lastUrl = "$baseUrl/recipes";
    final response = await dio.get(lastUrl);
    if (response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }

  static Future<HttpResult> searchRecipes(String query) async {
    String lastUrl = "https://mock.apifox.com/m2/3614939-0-default/128343201";
    final response = await dio.get(lastUrl, queryParameters: {'query': query});
    print(response);
    if (response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }

  static Future<HttpResult> publishRecipe(NewRecipe recipe) async {
    String lastUrl = '$baseUrl/recipe';
    Options testOpt = Options(headers: {
      // await SharedPreferencesUtil.getString("tokenName"):
      // await SharedPreferencesUtil.getString("tokenValue")
      await SaTokenUtil.getTokenName():
      await SaTokenUtil.getTokenValue()
    });
    /// 将Recipe转换成FormData
    FormData data = await recipe.toFormData();

    /// 发送请求，拿到 Response
    var response = await dio.post(lastUrl, data: data, options: testOpt);

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

  /// 收藏或取消收藏菜谱
  static Future<HttpResult> favorRecipe(int id) async {
    String lastUrl = '$baseUrl/recipe/favorite/$id';
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
}
