import 'package:flutter/material.dart';
import 'package:seecooker/models/recipe.dart';
import 'package:seecooker/providers/recipe/recipes_provider.dart';
import 'package:seecooker/services/recipe_service.dart';

class HomeRecipesProvider with ChangeNotifier implements RecipesProvider {
  List<Recipe>? _list;

  int _pageNo = 0;

  @override
  int get count => _list?.length ?? 0;

  @override
  Recipe itemAt(int index) => _list![index];

  @override
  Future<void> fetchRecipes() async {
    _pageNo = 0;
    final res = await RecipeService.getRecipesByPage(_pageNo);
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
    _pageNo++;
    final res = await RecipeService.getRecipesByPage(_pageNo);
    if(!res.isSuccess()) {
      throw Exception('未获取到菜谱数据: ${res.message}');
    }
    Iterable<Recipe> newList = res.data
        .map((e) => Recipe.fromJson(e))
        .toList()
        .cast<Recipe>();

    if(newList.isNotEmpty){
      _list?.addAll(newList);
      notifyListeners();
    } else {
      _pageNo = -1;
      fetchMoreRecipes();
    }
  }

  Future<bool> favorRecipe(int recipeId) async {
    final res = await RecipeService.favorRecipe(recipeId);
    if(!res.isSuccess()) {
      throw Exception('收藏失败: ${res.message}');
    }
    return res.data;
  }
}