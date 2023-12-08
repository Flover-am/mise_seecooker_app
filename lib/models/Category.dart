
import 'package:json_annotation/json_annotation.dart';

part 'Category.g.dart';
@JsonSerializable()
class Category {
   String name;
   List<String> ingredients;
   String tagline;
  Category({required this.name, required this.ingredients, required this.tagline});


  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}