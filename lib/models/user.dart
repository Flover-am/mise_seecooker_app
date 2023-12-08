import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int? id;

  String username;

  String password;

  String avatar;

  String description;

  List<int> likeRecipes;

  List<int> postRecipes;

  List<int> posts;

  String tokenName;

  String tokenValue;

  @JsonKey(name: "isLogin")
  bool isLoggedIn;


  User(
      this.username,
      this.password,
      this.avatar,
      this.description,
      this.likeRecipes,
      this.postRecipes,
      this.posts,
      this.tokenName,
      this.tokenValue,
      this.isLoggedIn);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);


  Map<String, dynamic> toJson() => _$UserToJson(this);
}
