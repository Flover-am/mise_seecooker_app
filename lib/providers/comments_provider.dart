import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:seecooker/models/comment.dart';
import 'package:seecooker/services/community_service.dart';

class CommentsProvider extends ChangeNotifier {
  final int _postId;
  List<Comment>? _list;

  CommentsProvider(this._postId);

  int get length => _list?.length ?? 0;

  Comment itemAt(int index) => _list![index];

  Future<void> fetchComments() async {
    final res = await CommunityService.getComments(_postId);
    if(!res.isSuccess()) {
      throw Exception('未获取到评论数据: ${res.message}');
    }
    _list = res.data
        .map((e) => Comment.fromJson(e))
        .toList()
        .cast<Comment>();
    notifyListeners();
  }

  Future<void> createComment(String content) async {
    if(_list == null){
      await fetchComments();
    }
    final res = await CommunityService.postComment(_postId, content);
    if(!res.isSuccess()) {
      throw Exception('发布评论失败: ${res.message}');
    }
    _list?.insert(0, Comment.fromJson(res.data));
    notifyListeners();
  }
}