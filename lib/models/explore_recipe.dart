import 'package:json_annotation/json_annotation.dart';

part 'explore_recipe.g.dart';


/*
服务端为发现界面提供的菜品推荐
 */
@JsonSerializable()
class ExploreRecipe {

  late int recipeId;
  late bool favourite;
  late String name;
  late String cover;
  late String introduction;
  late String authorName;
  late String authorAvatar;
  ExploreRecipe({required this.favourite, required this.recipeId, required this.name, required this.cover, required this.introduction,required this.authorName,required this.authorAvatar});
  factory  ExploreRecipe.fromJson(Map<String, dynamic> json) => _$ExploreRecipeFromJson(json);
  Map<String, dynamic> toJson() => _$ExploreRecipeToJson(this);
}