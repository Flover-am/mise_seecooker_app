import 'package:flutter/cupertino.dart';
import 'package:seecooker/services/explore_service.dart';

import '../models/post.dart';
import '../models/recipe.dart';

class RecommendProvider extends ChangeNotifier {
  //从服务端拿到的Recipe
  List<Recipe> _list = [];
  int get length => _list.length;
  Recipe itemAt(int index) => _list[index];

  Future<void> fetchPosts() async {
    _list = await ExploreService.fetchPosts();
    notifyListeners();
  }

  Future<void> fetchMorePosts() async {
    _list.addAll(await ExploreService.fetchMorePosts());
    notifyListeners();
  }
}