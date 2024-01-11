
import 'package:json_annotation/json_annotation.dart';
part 'Ingredients.g.dart';


/*
程序界面与服务端对接配料类型
 */
@JsonSerializable()
class Ingredients {
  //配料的分类
  String category;
  //这个配料分类有些什么配料
  List<String> name;

  Ingredients({required this.category, required this.name});
  factory Ingredients.fromJson(Map<String, dynamic> json) => _$IngredientsFromJson(json);
  Map<String, dynamic> toJson() => _$IngredientsToJson(this);
}