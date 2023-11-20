class PostDetailModel {
  int id;
  String author;
  String title;
  String avatarUrl;
  String content;
  List<String> imageUrls;
  List<CommentModel> comments;

  PostDetailModel(this.id, this.author, this.title, this.avatarUrl, this.content, this.imageUrls, this.comments);
}

class CommentModel {
  int id;
  String author;
  DateTime date;
  String content;
  String avatarUrl;

  CommentModel(this.id, this.author, this.date, this.content, this.avatarUrl);
}