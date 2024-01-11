import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:seecooker/providers/post/posts_provider.dart';
import 'package:seecooker/services/community_service.dart';

import '../../models/post.dart';

class CommunityPostsProvider with ChangeNotifier implements PostsProvider {
  List<Post>? _list;

  int _pageNo = 0;

  @override
  int get count => _list?.length ?? 0;

  @override
  Post itemAt(int index) => _list![index];

  @override
  Future<void> fetchPosts() async {
    _pageNo = 0;
    final res = await CommunityService.getPostsByPage(_pageNo);
    if(!res.isSuccess()) {
      throw Exception('未获取到帖子数据: ${res.message}');
    }
    _list = res.data
        .map((e) => Post.fromJson(e))
        .toList()
        .cast<Post>();
    notifyListeners();
  }

  @override
  Future<void> fetchMorePosts() async {
    _pageNo++;
    final res = await CommunityService.getPostsByPage(_pageNo);
    if(!res.isSuccess()) {
      throw Exception('未获取到帖子数据: ${res.message}');
    }
    List<Post> newPosts = res.data
        .map((e) => Post.fromJson(e))
        .toList()
        .cast<Post>();
    if(newPosts.isNotEmpty){
      _list?.addAll(newPosts);
      notifyListeners();
    } else {
      _pageNo = -1;
      fetchMorePosts();
    }
  }
}