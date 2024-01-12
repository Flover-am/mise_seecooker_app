import 'package:flutter/material.dart';
import 'package:seecooker/models/new_recipe.dart';
import 'package:seecooker/services/recipe_service.dart';

class NewRecipeProvider with ChangeNotifier {
  final NewRecipe _model = NewRecipe();

  NewRecipe get model => _model;

   Future<void> publish() async {
    var res = await RecipeService.publishRecipe(_model);

    if (!res.isSuccess()) {
      throw Exception("发布失败${res.message}");
    }
  }

  void changeIngredientName(int index, String value) {
    _model.ingredientsName[index] = value;
    notifyListeners();
  }

  void changeIngredientAmout(int index, String value) {
    _model.ingredientsAmount[index] = value;
    notifyListeners();
  }



}
