import 'package:json_annotation/json_annotation.dart';

part 'recipe_detail.g.dart';
@JsonSerializable()
class RecipeModel {
  String name;
  String cover;
  String introduction;
  String authorName;
  String authorAvatar;
  List<String> stepContents;
  List<String> stepImages;

  int starAmount;
  bool isFavorite;
  bool isMarked;

  RecipeModel(
      this.name,
      this.cover,
      this.introduction,
      this.authorName,
      this.authorAvatar,
      this.stepContents,
      this.stepImages,
      this.starAmount,
      this.isFavorite,
      this.isMarked);




  factory RecipeModel.fromJson(Map<String, dynamic> json) => _$RecipeModelFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeModelToJson(this);
}
