import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seecooker/services/post_service.dart';

import '../models/post.dart';

class CommunityPostsProvider extends ChangeNotifier {
  List<Post>? _list;

  int get length => _list?.length ?? 0;

  Post itemAt(int index) => _list![index];

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