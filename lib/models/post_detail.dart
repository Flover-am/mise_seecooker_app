import 'package:json_annotation/json_annotation.dart';

part 'post_detail.g.dart';

@JsonSerializable()
class PostDetail {
  String title;
  String posterAvatar;
  String posterName;
  String content;
  List<String> images;

  PostDetail(this.title, this.posterAvatar, this.posterName, this.content, this.images);

  factory PostDetail.fromJson(Map<String, dynamic> json) => _$PostDetailFromJson(json);

  Map<String, dynamic> toJson() => _$PostDetailToJson(this);
}