import 'package:flutter/cupertino.dart';

import '../models/post.dart';

class CommunityPostsProvider extends ChangeNotifier {
  final List<PostModel> _list = [];

  int get length => _list.length;

  PostModel itemAt(int index) => _list[index];

  Future<void> fetchPosts() async {
    // TODO: ADD HTTP GET REQUEST
    await Future.delayed(const Duration(seconds: 1));
    _list.addAll(List.generate(
        5,
            (index) => PostModel(
            index,
            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
            'author$index',
            'title$index',
            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'
        )
    ));
  }

  Future<void> fetchMorePosts() async {
    // TODO: ADD HTTP GET REQUEST
    await Future.delayed(const Duration(seconds: 1));
    _list.addAll(List.generate(
      5,
      (index) => PostModel(
        index,
        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
        'author$index',
        'title$index',
        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'
      )
    ));
    notifyListeners();
  }
}