import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  int postId;
  String cover;
  String title;
  int posterId;
  String posterName;
  String posterAvatar;

  Post(this.postId, this.cover, this.title, this.posterId, this.posterName, this.posterAvatar);

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}