import 'package:flutter/cupertino.dart';
import 'package:seecooker/services/explore_service.dart';

import '../models/explore_recipe.dart';
import '../models/recipe.dart';

class RecommendProvider extends ChangeNotifier {
  //从服务端拿到的Recipe
  List<ExploreRecipe> _list = [];
  int get length => _list.length;
  ExploreRecipe itemAt(int index) => _list[index];

  Future<void> fetchPosts() async {
    _list.add(await ExploreService.fetchPosts());
    notifyListeners();
  }

  Future<void> fetchMorePosts() async {
    _list.add(await ExploreService.fetchMorePosts());
    notifyListeners();
  }
}