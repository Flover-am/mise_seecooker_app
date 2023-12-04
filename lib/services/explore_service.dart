import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:seecooker/models/comment.dart';

import '../models/recipe.dart';

class ExploreService {

  static Future<List<Recipe>> fetchPosts() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(
        5,
            (index) => Recipe(
          index,
          '五红银耳羹',
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
        )
    );
  }

  static Future<List<Recipe>> fetchMorePosts() async {
    // TODO: ADD HTTP GET REQUEST
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(
        5,
            (index) => Recipe(
          index,
          '黄焖鸡',
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
        )
    );
  }


}