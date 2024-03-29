import 'package:json_annotation/json_annotation.dart';

part 'recipe_detail.g.dart';

@JsonSerializable()
class RecipeDetail {
  String name;
  String cover;
  String introduction;
  int authorId;
  String authorName;
  String authorAvatar;
  List<String> stepImages;
  List<String> stepContents;
  bool scored;
  double score;
  double averageScore;
  bool favorite;
  List<Map<String,String>>? ingredientAmount;
  String? publishTime;

  RecipeDetail(
      this.name,
      this.cover,
      this.introduction,
      this.authorId,
      this.authorName,
      this.authorAvatar,
      this.stepImages,
      this.stepContents,
      this.scored,
      this.score,
      this.averageScore,
      this.favorite,
      this.ingredientAmount,
      this.publishTime
    );

  factory RecipeDetail.fromJson(Map<String, dynamic> json) => _$RecipeDetailFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeDetailToJson(this);
}
