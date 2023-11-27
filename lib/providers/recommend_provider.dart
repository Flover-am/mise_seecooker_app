import 'package:flutter/cupertino.dart';

import '../models/post.dart';

class RecommendProvider extends ChangeNotifier {
  final List<String> _list = [];

  int get length => _list.length;

  String itemAt(int index) => _list[index];

  Future<void> fetchPosts() async {
    // TODO: ADD HTTP GET REQUEST
    await Future.delayed(const Duration(seconds: 1));
    _list.addAll(List.generate(
        5,
            (index) =>
            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'
    ));
  }

  Future<void> fetchMorePosts() async {
    // TODO: ADD HTTP GET REQUEST
    await Future.delayed(const Duration(seconds: 1));
    _list.addAll(List.generate(
        5,
            (index) => 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'
    ));
    notifyListeners();
  }
}