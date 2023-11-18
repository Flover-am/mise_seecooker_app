import 'package:flutter/material.dart';
import 'package:seecooker/models/post.dart';

class CommunityPostsModel extends ChangeNotifier {
  final List<PostModel> _posts = [];

  int get length => _posts.length;

  PostModel itemAt(int index) => _posts[index];

  CommunityPostsModel() {
    getMorePosts();
  }

  void getMorePosts() async {
    // TODO: ADD HTTP GET REQUEST
    await Future.delayed(const Duration(seconds: 1));
    _posts.addAll(List.generate(
        5,
        (index) => PostModel(
            index,
            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
            'author$index',
            'title$index',
            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg')));

    notifyListeners();
  }
}
