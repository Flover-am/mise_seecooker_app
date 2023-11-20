import 'package:flutter/cupertino.dart';
import 'package:seecooker/models/post_detail.dart';

class PostDetailProvider with ChangeNotifier{
  late PostDetailModel _model;

  PostDetailModel get model => _model;

  Future<PostDetailModel> fetchPostDetail(int id) async {
    // TODO: ADD HTTP GET REQUEST
    await Future.delayed(const Duration(seconds: 2));
    _model = PostDetailModel(
      id,
      '作者$id',
      '标题$id',
      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      '内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容$id',
      ['https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
       'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
       'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'
      ],
      [
        CommentModel(1, 'author1', DateTime.now(), '内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容', 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
        CommentModel(2, 'author2', DateTime.now(), '内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容', 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
        CommentModel(3, 'author3', DateTime.now(), '内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容', 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
        CommentModel(4, 'author4', DateTime.now(), '内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容', 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
        CommentModel(5, 'author5', DateTime.now(), '内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容', 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
        CommentModel(6, 'author6', DateTime.now(), '内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容', 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
        CommentModel(7, 'author7', DateTime.now(), '内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容', 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
      ]
    );
    return _model;
  }

  void postComment(String content) {
    _model.comments.insert(0, CommentModel(6, 'newauthor', DateTime.now(), content, 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'));
    // TODO: ADD HTTP POST REQUEST
    notifyListeners();
  }
}