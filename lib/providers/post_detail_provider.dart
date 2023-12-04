import 'package:flutter/material.dart';
import 'package:seecooker/models/post_detail.dart';
import 'package:seecooker/services/post_service.dart';

class PostDetailProvider with ChangeNotifier{
  final int _postId;
  late PostDetail _model;

  PostDetailProvider(this._postId);

  PostDetail get model => _model;

  Future<void> fetchPostDetail() async {
    final res = await PostService.getPostDetail(_postId);
    if(!res.isSuccess()) {
      throw Exception('未拿到帖子详情数据: ${res.message}');
    }
    _model = PostDetail.fromJson(res.data);
  }
}