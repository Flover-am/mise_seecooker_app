import 'package:json_annotation/json_annotation.dart';

part 'recipe_detail.g.dart';
@JsonSerializable()
class RecipeModel {
  late String name;
  late String cover;
  late String introduction;
  late List<String> stepImages;
  late List<String> stepContents;
  late String authorName;
  late String authorAvatar;
  late bool isFavorite;

  late int? starAmount = 0;
  late List<Map<String,String>>? ingredients;
  late bool? isMarked = false;
  RecipeModel.empty();

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
      this.isMarked,
      this.ingredients);




  factory RecipeModel.fromJson(Map<String, dynamic> json) => _$RecipeModelFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeModelToJson(this);
}
