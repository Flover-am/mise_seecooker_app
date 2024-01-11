import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable()
class UserInfo {

  String username;

  int postNum;

  int? getLikedNum;

  String avatar;

  String signature;


  UserInfo(
    this.username,
      this.postNum,
      this.getLikedNum,
      this.avatar,
      this.signature,
      );

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);


  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}