import 'dart:math';

import 'package:flutter/material.dart';
import 'package:seecooker/services/recipe_service.dart';

class SearchRecommendProvider extends ChangeNotifier {
  late List<String> _list;

  List<String> get list => _list;

  Future<void> fetchSearchRecommend() async {
    final res = await RecipeService.getRandomRecommend();
    if(!res.isSuccess()) {
      throw Exception('未获取到推荐菜谱: ${res.message}');
    }
    _list = res.data.toList().cast<String>();
  }

  Future<void> refreshSearchRecommend() async {
    final res = await RecipeService.getRandomRecommend();
    if(!res.isSuccess()) {
      throw Exception('未获取到推荐菜谱: ${res.message}');
    }
    _list = res.data.toList().cast<String>();
    notifyListeners();
  }
}