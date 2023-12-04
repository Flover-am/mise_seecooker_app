import 'package:flutter/material.dart';
import 'package:seecooker/models/post_detail.dart';
import 'package:seecooker/services/post_service.dart';

class PostDetailProvider with ChangeNotifier{
  final int _postId;
  late PostDetail _model;

  PostDetailProvider(this._postId);

  PostDetail get model => _model;

  Future<void> fetchPostDetail() async {
    _model = await PostService.getPostDetail(_postId);
  }
}