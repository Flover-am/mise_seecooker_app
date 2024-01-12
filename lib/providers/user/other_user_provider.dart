import 'package:flutter/cupertino.dart';
import 'package:seecooker/models/other_user.dart';
import 'package:seecooker/services/user_service.dart';

class OtherUserProvider extends ChangeNotifier{
  var defaultAvatar = "https://seecooker.oss-cn-shanghai.aliyuncs.com/avatar/ecff12a2-2986-4bd9-a393-cf8f1065397f.webp";
  late OtherUser _otherUser = OtherUser(112,"username", defaultAvatar, 'signature',0,0);
  late int _id;

  int get id => _id;


  String get username => _otherUser.username;


  String get signature => _otherUser.signature ?? "这个人很懒，没有留下任何签名";

  String get avatar => _otherUser.avatar;

  get postNum => _otherUser.postNum;


  Future<OtherUser> getUserById(int id) async {
    /// 先进行请求，然后从请求中拿数据
    var res =  await UserService.getUserById(id);
    /// 判断是否获取成功
    if(!res.isSuccess()){
      throw Exception("未成功获取用户:${res.message}");
    }
    /// 将数据转换成Model
    _otherUser = OtherUser.fromJson(res.data);
    _id = id;
    _otherUser.id = id;
    return _otherUser;
  }
}