import 'package:json_annotation/json_annotation.dart';

part 'explore_recipe.g.dart';

@JsonSerializable()
class ExploreRecipe {
  late String name;
  late String cover;
  late String introduction;
  late String authorName;
  late String authorAvatar;
  ExploreRecipe({required this.name, required this.cover, required this.introduction,required this.authorName,required this.authorAvatar});
  factory  ExploreRecipe.fromJson(Map<String, dynamic> json) => _$ExploreRecipeFromJson(json);
  Map<String, dynamic> toJson() => _$ExploreRecipeToJson(this);
}