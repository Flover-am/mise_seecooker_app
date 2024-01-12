import 'package:flutter/cupertino.dart';
import 'package:seecooker/models/recipe_detail.dart';
import 'package:seecooker/services/recipe_service.dart';

class RecipeDetailProvider with ChangeNotifier {
  final int _recipeId;
  late RecipeDetail _model;

  RecipeDetail get model => _model;

  RecipeDetailProvider(this._recipeId);

  Future<void> fetchRecipeDetail() async {
    var res =  await RecipeService.getRecipe(_recipeId);
    if(!res.isSuccess()){
      throw Exception("未获取到食谱数据: ${res.message}");
    }
    _model = RecipeDetail.fromJson(res.data);
  }

  Future<bool> favorRecipe() async {
    final res = await RecipeService.favorRecipe(_recipeId);
    if(!res.isSuccess()) {
      throw Exception('收藏失败: ${res.message}');
    }
    return res.data;
  }


  Future<void> scoreRecipe(int score) async {
    final res = await RecipeService.scoreRecipe(_recipeId, score.toDouble());
    if(!res.isSuccess()) {
      throw Exception('评分失败: ${res.message}');
    }
    model.scored = true;
    notifyListeners();
  }
}
