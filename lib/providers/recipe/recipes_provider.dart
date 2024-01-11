import 'package:seecooker/models/recipe.dart';

abstract class RecipesProvider {
  /// 帖子数量
  int get count;

  /// 单个帖子
  Recipe itemAt(int index);

  /// 初始化菜谱列表及刷新菜谱列表
  Future<void> fetchRecipes();

  /// 获取更多菜谱，用于无限滑动
  Future<void> fetchMoreRecipes();
}