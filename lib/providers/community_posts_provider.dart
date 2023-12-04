import 'package:flutter/material.dart';
import 'package:seecooker/services/post_service.dart';

import '../models/post.dart';

class CommunityPostsProvider extends ChangeNotifier {
  List<Post>? _list;

  int get length => _list?.length ?? 0;

  Post itemAt(int index) => _list![index];

  Future<void> fetchPosts() async {
    _list = await PostService.getPosts();
    notifyListeners();
  }

  Future<void> fetchMorePosts() async {
    _list?.addAll(await PostService.getPosts());
    notifyListeners();
  }
}