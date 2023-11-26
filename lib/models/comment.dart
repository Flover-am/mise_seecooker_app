import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  String commenterAvatar;
  String commenterName;
  String commentTime;
  String content;

  Comment(this.commenterName, this.commentTime, this.content, this.commenterAvatar);

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}