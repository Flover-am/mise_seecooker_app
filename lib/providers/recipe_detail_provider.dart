import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seecooker/models/recipe_detail.dart';
import 'package:seecooker/services/recipe_service.dart';

class RecipeDetailProvider with ChangeNotifier {
  late RecipeModel _model;

  RecipeModel get model => _model;
  RecipeService recipeService = RecipeService();

  Future<RecipeModel> fetchRecipeDetail(int id) async {
    /// 先进行请求，然后从请求中拿数据
    var res =  await RecipeService.getRecipe(id);
    /// 判断是否获取成功
    if(!res.isSuccess()){
      throw Exception("未拿到菜谱数据:${res.message}");
    }
    /// 将数据转换成Model
    _model = RecipeModel.fromJson(res.data);
    return _model;
  }

  void changeStarAmount(int SM2) {
    _model.starAmount = SM2;
    notifyListeners();
  }

  void addToFavorite() {
    Fluttertoast.showToast(msg: "已收藏");
    _model.isFavorite = true;
    notifyListeners();
  }

  void removeToFavorite() {
    Fluttertoast.showToast(msg: "取消收藏");
    _model.isFavorite = false;
    notifyListeners();
  }

  void sendMark() {
    _model.isMarked = true;
    Fluttertoast.showToast(msg: "评论成功");
    notifyListeners();
  }
}
