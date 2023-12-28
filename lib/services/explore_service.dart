import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:seecooker/utils/server_url_util.dart';

import '../models/explore_recipe.dart';

class ExploreService {
  static const String baseUrl =ServerUrlUtil.mockUrl;

  static Dio dio = Dio();
  static Future<ExploreRecipe> fetchPosts() async {
    String lastUrl = '$baseUrl/explore';

    final response = await dio.get(lastUrl);
    if(response.statusCode == 200) {
      return ExploreRecipe.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }

  }

  static Future<ExploreRecipe> fetchMorePosts() async {
    String lastUrl = '$baseUrl/explore';
    final response = await dio.get(lastUrl);
    if(response.statusCode == 200) {
      return ExploreRecipe.fromJson(response.data);
    } else {
      throw Exception('Network exception: ${response.statusCode}');
    }
  }
  static void addToFavorite(int index) {
    print("I like $index");
  }

}