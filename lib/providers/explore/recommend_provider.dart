/// 发布用户选择

import 'dart:ffi';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:seecooker/models/Ingredients.dart';
import 'package:seecooker/models/explore_recipe.dart';
import 'package:seecooker/services/explore_service.dart';



class RecommendProvider extends ChangeNotifier {
  //从服务端拿到的Recipe
  List<ExploreRecipe> _list = [];
  int get length => _list.length;
  ExploreRecipe itemAt(int index) => _list[index];
  Future<void> fetchPosts(List<String> ingredients) async {
    final res = await ExploreService.fetchPosts(ingredients);
    print(res.data);
    List<ExploreRecipe> cardlist = [];
    cardlist = res.data
        .map((e) => ExploreRecipe.fromJson(e))
        .toList()
        .cast<ExploreRecipe>();
    for(ExploreRecipe item in cardlist) {
      _list.add(item);
    }
    notifyListeners();
  }

  Future<void> fetchMorePosts(List<String> ingredients) async {
    final res = await ExploreService.fetchPosts(ingredients);
    List<ExploreRecipe> cardlist = [];
    cardlist = res.data
        .map((e) => ExploreRecipe.fromJson(e))
        .toList()
        .cast<ExploreRecipe>();
    for(ExploreRecipe item in cardlist) {
      _list.add(item);
    }
    notifyListeners();
  }
}