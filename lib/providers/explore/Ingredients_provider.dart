import 'package:flutter/material.dart';
import 'package:seecooker/models/Ingredients.dart';
import 'package:seecooker/services/recipe_service.dart';


class IngredientsProvider extends ChangeNotifier {
  late List<Ingredients> _list = [];

  List<Ingredients> showlist() {
    if(_list == null){
      return [];
    }
    return _list;
  }
  Future<void> getIngredients() async {
    final res = await RecipeService.getIngredients();
    _list = res.data
        .map((e) => Ingredients.fromJson(e))
        .toList()
        .cast<Ingredients>();
  }

}
