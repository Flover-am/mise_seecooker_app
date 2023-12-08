import 'package:seecooker/models/recipe.dart';
import 'package:seecooker/services/recipe_service.dart';

class SearchResultProvider {
  List<Recipe>? _list;

  int get length => _list?.length ?? 0;

  Recipe itemAt(int index) => _list![index];

  Future<void> fetchSearchResult(String query) async {
    final res = await RecipeService.searchRecipes(query);
    if(!res.isSuccess()) {
      throw Exception('未拿到菜谱数据: ${res.message}');
    }
    _list = res.data
        .map((e) => Recipe.fromJson(e))
        .toList()
        .cast<Recipe>();
  }
}