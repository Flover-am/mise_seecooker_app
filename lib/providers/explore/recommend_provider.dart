import 'dart:ffi';

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
    _list.add(ExploreRecipe.fromJson(res.data));
    notifyListeners();
  }

  Future<void> fetchMorePosts(List<String> ingredients) async {
    final res = await ExploreService.fetchPosts(ingredients);
    _list.add(ExploreRecipe.fromJson(res.data));
    notifyListeners();
  }
}