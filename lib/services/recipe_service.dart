import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:seecooker/models/NewRecipe.dart';
import 'package:seecooker/models/http_result.dart';
import 'package:seecooker/utils/server_url_util.dart';
import 'package:seecooker/utils/shared_preferences_util.dart';
import 'package:seecooker/utils/sa_token_util.dart';

class RecipeService {
  /// 测试阶段可以先用apiFox的Mock的url
  static const String baseUrl = "${ServerUrlUtil.baseUrl}/recipe";

  /// 使用Dio进行网络请求
  static Dio dio = Dio();

  static Future<HttpResult> getRecipes() async {
    String lastUrl = "$baseUrl/list";
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
    if (response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }

  static Future<HttpResult> getRecipesByPage(int pageNo) async {
    String lastUrl = "$baseUrl/list/page/$pageNo";
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
    if (response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }

  static Future<HttpResult> searchRecipes(String query) async {
    String lastUrl = "$baseUrl/search";
    final response = await dio.get(lastUrl, queryParameters: {'query': query});
    if (response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }

  static Future<HttpResult> publishRecipe(NewRecipe recipe) async {
    String lastUrl = baseUrl;
    Options testOpt = Options(headers: {
      await SaTokenUtil.getTokenName():
      await SaTokenUtil.getTokenValue()
    });
    FormData data = await recipe.toFormData();

    var response = await dio.post(lastUrl, data: data, options: testOpt);

    return HttpResult.fromJson(response.data);
  }

  static Future<HttpResult> getRecipe(int id) async {
    String lastUrl = '$baseUrl/detail/$id';
    Options options = Options(headers: {
      await SaTokenUtil.getTokenName():
      await SaTokenUtil.getTokenValue()
    });
    var response = await dio.get(lastUrl, options: options);
    if(response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }

  /// 收藏或取消收藏菜谱
  static Future<HttpResult> favorRecipe(int id) async {
    String lastUrl = '$baseUrl/favorite/$id';
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

  /// 评分菜谱
  static Future<HttpResult> scoreRecipe(int id, double score) async {
    String lastUrl = '$baseUrl/score';
    Options options = Options(headers: {
      await SaTokenUtil.getTokenName():
      await SaTokenUtil.getTokenValue()
    });
    final response = await dio.post(
      lastUrl,
      options: options,
      data: FormData.fromMap(
        {
          'recipeId': id,
          'score': score
        }
      )
    );
    if(response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }

  /// 获取随机推荐菜谱
  static Future<HttpResult> getRandomRecommend() async {
    String lastUrl = '$baseUrl/recommend';
    final response = await dio.get(lastUrl);
    if(response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }

  /// 获取AI回答
  static Future<HttpResult> getAiResponse(String query) async {
    String lastUrl = "$baseUrl/llm";
    final response = await dio.get(lastUrl, queryParameters: {'prompt': query});
    if(response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }
}
