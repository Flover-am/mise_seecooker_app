import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../models/explore_recipe.dart';

class ExploreService {

  static const String baseUrl ="https://mock.apifox.com/m1/3730356-0-default";
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