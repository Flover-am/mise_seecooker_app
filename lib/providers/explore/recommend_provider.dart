import 'package:flutter/cupertino.dart';
import 'package:seecooker/models/explore_recipe.dart';
import 'package:seecooker/services/recipe_service.dart';

class RecommendProvider extends ChangeNotifier {
  //从服务端拿到的Recipe
  List<ExploreRecipe> _list = [];

  int get length => _list.length;

  ExploreRecipe itemAt(int index) => _list[index];

  Future<void> fetchRecommendRecipes(List<String> ingredients) async {
    final res = await RecipeService.getRecommendRecipes(ingredients);
    List<ExploreRecipe> list = [];
    list = res.data
        .map((e) => ExploreRecipe.fromJson(e))
        .toList()
        .cast<ExploreRecipe>();
    _list = list;
  }

  Future<bool> favorRecipe(int recipeId) async {
    final res = await RecipeService.favorRecipeWithoutCheckLogin(recipeId);
    if(!res.isSuccess()) {
      throw Exception('收藏失败: ${res.message}');
    }
    return res.data;
  }
}