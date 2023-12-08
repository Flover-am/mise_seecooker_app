import 'package:json_annotation/json_annotation.dart';

part 'user_login.g.dart';

@JsonSerializable()
class UserLogin {
  String tokenName;

  String tokenValue;

  @JsonKey(name: "isLogin")
  String isLoggedIn;

  @JsonKey(name: "loginId")
  String loginId;

  String loginType;

  DateTime tokenTimeout;

  DateTime sessionTimeout;

  DateTime tokenSessionTimeout;

  DateTime tokenActiveTimeout;

  String loginDevice;

  String tag;

  UserLogin(
      this.tokenName,
      this.tokenValue,
      this.isLoggedIn,
      this.loginId,
      this.loginType,
      this.tokenTimeout,
      this.sessionTimeout,
      this.tokenSessionTimeout,
      this.tokenActiveTimeout,
      this.loginDevice,
      this.tag,
      );

  factory UserLogin.fromJson(Map<String, dynamic> json) =>
      _$UserLoginFromJson(json);

  Map<String, dynamic> toJson() => _$UserLoginToJson(this);
}