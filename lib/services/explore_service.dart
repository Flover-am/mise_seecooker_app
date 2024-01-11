import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/models/Ingredients.dart';
import 'package:seecooker/models/http_result.dart';
import 'package:seecooker/utils/server_url_util.dart';

import '../models/explore_recipe.dart';
import '../providers/explore/explore_post_provider.dart';

class ExploreService {
  static const String baseUrl =ServerUrlUtil.baseUrl;

  static Dio dio = Dio();
  static Future<HttpResult> fetchPosts(List<String> ingredients) async {
    String lastUrl = '$baseUrl/recipe/explore';
    Map<String, List<String> > map = Map();
    map["ingredients"] = ingredients;
    // final FormData formData =FormData.fromMap(map);
    final response = await dio.get(lastUrl,queryParameters: map);
    if(response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }

  }

  static Future<HttpResult> fetchMorePosts(List<String> ingredients) async {
    String lastUrl = '$baseUrl/recipe/explore';
    Map<String, List<String>> map = Map();//请求参数放在map中
    map["ingredients"] = ingredients;
    // final FormData formData =FormData.fromMap(map);
    final response = await dio.get(lastUrl,queryParameters: map);
    if(response.statusCode == 200) {
      return HttpResult.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }
  static Future<void> favourite(int id) async {
    final response = await dio.put("$baseUrl/recipe/favorite/$id");
    if(response.statusCode == 200) {
      log("success");
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }

}