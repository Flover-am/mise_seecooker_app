import 'package:flutter/material.dart';
import 'package:seecooker/models/recipe.dart';

class HomeRecipesProvider extends ChangeNotifier {
  final List<Recipe> _list = [];

  int get length => _list.length;

  Recipe itemAt(int index) => _list[index];

  Future<void> fetchRecipes() async {
    // TODO: ADD HTTP GET REQUEST
    await Future.delayed(const Duration(seconds: 1));
    _list.addAll(List.generate(
        5,
            (index) => Recipe(
            index,
            '五红银耳羹',
            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
            'author$index',
            114514,
            3.2,
        )
    ));
  }

  Future<void> fetchMoreRecipes() async {
    // TODO: ADD HTTP GET REQUEST
    await Future.delayed(const Duration(seconds: 1));
    _list.addAll(List.generate(
        5,
            (index) => Recipe(
          index,
          '黄焖鸡',
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
          'author$index',
          114514,
          3.2,
        )
    ));
    notifyListeners();
  }
}