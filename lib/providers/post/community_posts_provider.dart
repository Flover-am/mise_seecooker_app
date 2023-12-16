import 'package:flutter/material.dart';
import 'package:seecooker/providers/post/posts_provider.dart';
import 'package:seecooker/services/post_service.dart';

import '../../models/post.dart';

class CommunityPostsProvider with ChangeNotifier implements PostsProvider{
  List<Post>? _list;

  @override
  int get count => _list?.length ?? 0;

  @override
  Post itemAt(int index) => _list![index];

  @override
  Future<void> fetchPosts() async {
    final res = await PostService.getPosts();
    if(!res.isSuccess()) {
      throw Exception('未拿到帖子数据: ${res.message}');
    }
    _list = res.data
      .map((e) => Post.fromJson(e))
      .toList()
      .cast<Post>();
    notifyListeners();
  }

  @override
  Future<void> fetchMorePosts() async {
    final res = await PostService.getPosts();
    if(!res.isSuccess()) {
      throw Exception('未拿到帖子数据: ${res.message}');
    }
    _list?.addAll(res.data
      .map((e) => Post.fromJson(e))
      .toList()
      .cast<Post>()
    );
    notifyListeners();
  }
}