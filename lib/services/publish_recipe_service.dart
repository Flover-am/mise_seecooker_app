
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:seecooker/models/NewRecipe.dart';

import 'package:seecooker/models/http_result.dart';

class PublishRecipeService {
  static const String baseUrl = 'https://mock.apifox.com/m1/3614939-0-default/recipe';

  static Future<Response> postRecipe(NewRecipe recipe) async {
    var dio = Dio();
    var response = await dio.post(baseUrl, data: recipe.toFormData());
    log(response.toString());
    return response;
  }
}
