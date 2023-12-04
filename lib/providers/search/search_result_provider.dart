import 'package:seecooker/models/recipe.dart';

class SearchResultProvider {
  final List<Recipe> _list = [];

  int get length => _list.length;

  Recipe itemAt(int index) => _list[index];

  Future<void> fetchSearchResult() async {
    await Future.delayed(const Duration(seconds: 1));
    _list.addAll(List.generate(
        5,
            (index) => Recipe(
          index,
          '五红银耳羹',
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
        )
    ));
  }
}