import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:seecooker/models/post_detail.dart';
import 'package:seecooker/services/community_service.dart';

class PostDetailProvider{
  final int _postId;
  late PostDetail _model;

  PostDetailProvider(this._postId);

  PostDetail get model => _model;

  Future<void> fetchPostDetail() async {
    final res = await CommunityService.getPostDetail(_postId);
    if(!res.isSuccess()) {
      throw Exception('未获取到帖子详情数据: ${res.message}');
    }
    _model = PostDetail.fromJson(res.data);
  }

  Future<bool> likePost() async {
    final res = await CommunityService.likePost(_postId);
    if(!res.isSuccess()) {
      throw Exception('点赞失败: ${res.message}');
    }
    return res.data as bool;
  }

  Future<void> deletePost() async {
    final res = await CommunityService.deletePost(_postId);
    if(!res.isSuccess()) {
      throw Exception('删除失败: ${res.message}');
    }
  }
}