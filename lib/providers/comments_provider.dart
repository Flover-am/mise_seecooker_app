import 'package:flutter/material.dart';
import 'package:seecooker/models/comment.dart';
import 'package:seecooker/services/comment_service.dart';

class CommentsProvider extends ChangeNotifier {
  final int _postId;
  List<Comment>? _list;

  CommentsProvider(this._postId);

  int get length => _list?.length ?? 0;

  Comment itemAt(int index) => _list![index];

  Future<void> fetchComments() async {
    _list = await CommentService.getComments(_postId);
    notifyListeners();
  }

  Future<void> createComment(int commenterId, String content) async {
    _list ??= await CommentService.getComments(_postId);
    await CommentService.postComment(commenterId, _postId, content);
    // TODO: server return new comment
    //_list.add(await CommentService.postComment(commenterId, _postId, content));
    _list?.insert(0, Comment('111', '2023-11-26', content, 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'));
    notifyListeners();
  }
}