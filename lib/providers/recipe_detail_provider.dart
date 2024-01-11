import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seecooker/models/recipe_detail.dart';
import 'package:seecooker/services/recipe_service.dart';

class RecipeDetailProvider with ChangeNotifier {
  final int _recipeId;
  late RecipeDetail _model;
  int _newScore = 0;

  RecipeDetail get model => _model;

  int get newScore => _newScore;

  RecipeDetailProvider(this._recipeId);

  Future<RecipeDetail> fetchRecipeDetail() async {
    var res =  await RecipeService.getRecipe(_recipeId);
    if(!res.isSuccess()){
      throw Exception("未获取到食谱数据: ${res.message}");
    }
    _model = RecipeDetail.fromJson(res.data);
    return _model;
  }

  Future<bool> favorRecipe() async {
    final res = await RecipeService.favorRecipe(_recipeId);
    if(!res.isSuccess()) {
      throw Exception('收藏失败: ${res.message}');
    }
    return res.data;
  }

  void changeScore(int score) async {
    _newScore = score;
    notifyListeners();
  }

  void scoreRecipe() async {
    model.scored = true;
    final res = await RecipeService.scoreRecipe(_recipeId, _newScore.toDouble());
    if(!res.isSuccess()) {
      throw Exception('评分失败: ${res.message}');
    }
    notifyListeners();
  }
}
