import 'package:json_annotation/json_annotation.dart';

part 'recipe.g.dart';

@JsonSerializable()
class Recipe {
  int recipeId;
  String name;
  String cover;
  int authorId;
  String authorName;
  String authorAvatar;
  String introduction;
  double score;
  String publishTime;
  bool favorite;
  int favoriteNum;

  Recipe(
      this.recipeId,
      this.name,
      this.cover,
      this.authorId,
      this.authorName,
      this.authorAvatar,
      this.introduction,
      this.score,
      this.publishTime,
      this.favorite,
      this.favoriteNum
    );

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);
}