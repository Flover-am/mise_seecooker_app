import 'package:json_annotation/json_annotation.dart';

part 'other_user.g.dart';

@JsonSerializable()
class OtherUser {

  int? id;

  String username;

  String avatar;

  String? signature;


  int postNum;

  int getLikedNum;


  OtherUser(
      this.id,
      this.username,
      this.avatar,
      this.signature,
      this.postNum,
      this.getLikedNum,);

  factory OtherUser.fromJson(Map<String, dynamic> json) => _$OtherUserFromJson(json);


  Map<String, dynamic> toJson() => _$OtherUserToJson(this);
}
