import 'package:flutter/material.dart';
import 'package:seecooker/models/recipe.dart';
import 'package:seecooker/providers/recipe/recipes_provider.dart';
import 'package:seecooker/services/user_service.dart';

class UserRecipeProvider  with ChangeNotifier implements RecipesProvider {
  List<Recipe>? _list;

  late int userId;

  UserRecipeProvider(this.userId);

  @override
  int get count => _list?.length ?? 0;

  @override
  Recipe itemAt(int index) => _list![index];

  @override
  Future<void> fetchRecipes() async {
    final res = await UserService.getUserRecipe(userId);
    if(!res.isSuccess()) {
      throw Exception('未拿到菜谱数据: ${res.message}');
    }
    _list = res.data
        .map((e) => Recipe.fromJson(e))
        .toList()
        .cast<Recipe>();
  }

  @override
  Future<void> fetchMoreRecipes() async {

  }
}