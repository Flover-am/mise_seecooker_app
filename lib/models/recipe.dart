import 'package:json_annotation/json_annotation.dart';

part 'recipe.g.dart';

@JsonSerializable()
class Recipe {
  int id;
  String name;
  String cover;
  String authorName;
  String? authorAvatar;

  Recipe(this.id, this.name, this.cover, this.authorName, this.authorAvatar);

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);
}