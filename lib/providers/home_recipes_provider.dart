import 'package:flutter/material.dart';
import 'package:seecooker/models/recipe.dart';
import 'package:seecooker/services/recipe_service.dart';

class HomeRecipesProvider extends ChangeNotifier {
  List<Recipe>? _list;

  int get length => _list?.length ?? 0;

  Recipe itemAt(int index) => _list![index];

  Future<void> fetchRecipes() async {
    final res = await RecipeService.getRecipes();
    if(!res.isSuccess()) {
      throw Exception('未拿到菜谱数据: ${res.message}');
    }
    _list = res.data
      .map((e) => Recipe.fromJson(e))
      .toList()
      .cast<Recipe>();
  }

  Future<void> fetchMoreRecipes() async {
    final res = await RecipeService.getRecipes();
    if(!res.isSuccess()) {
      throw Exception('未拿到菜谱数据: ${res.message}');
    }
    _list?.addAll(res.data
      .map((e) => Recipe.fromJson(e))
      .toList()
      .cast<Recipe>()
    );
    notifyListeners();
  }
}