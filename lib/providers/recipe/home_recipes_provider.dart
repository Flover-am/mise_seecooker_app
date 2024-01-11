import 'package:flutter/material.dart';
import 'package:seecooker/models/recipe.dart';
import 'package:seecooker/providers/recipe/recipes_provider.dart';
import 'package:seecooker/services/recipe_service.dart';

class HomeRecipesProvider with ChangeNotifier implements RecipesProvider {
  List<Recipe>? _list;

  @override
  int get count => _list?.length ?? 0;

  @override
  Recipe itemAt(int index) => _list![index];

  @override
  Future<void> fetchRecipes() async {
    // TODO: 改为分页获取
    final res = await RecipeService.getRecipes();
    if(!res.isSuccess()) {
      throw Exception('未获取到菜谱数据: ${res.message}');
    }
    _list = res.data
      .map((e) => Recipe.fromJson(e))
      .toList()
      .cast<Recipe>();
  }

  @override
  Future<void> fetchMoreRecipes() async {
    // TODO: 改为分页获取
    final res = await RecipeService.getRecipes();
    if(!res.isSuccess()) {
      throw Exception('未获取到菜谱数据: ${res.message}');
    }
    _list?.addAll(res.data
      .map((e) => Recipe.fromJson(e))
      .toList()
      .cast<Recipe>()
    );
    notifyListeners();
  }
}