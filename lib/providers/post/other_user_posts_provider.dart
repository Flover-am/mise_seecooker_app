import 'package:flutter/material.dart';
import 'package:seecooker/providers/post/posts_provider.dart';
import 'package:seecooker/models/post.dart';
import 'package:seecooker/services/user_service.dart';

class OtherUserPostsProvider with ChangeNotifier implements PostsProvider {
  List<Post>? _list;

  late int userId;

  OtherUserPostsProvider(this.userId);

  @override
  int get count => _list?.length ?? 0;

  @override
  Post itemAt(int index) => _list![index];

  @override
  Future<void> fetchPosts() async {
    final res = await UserService.getUserPosts(userId);
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

  }
}