import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../../providers/user/user_provider.dart';


///修改页面
class ModifyPage extends StatefulWidget {
  @override
  _ModifyPageState createState() => _ModifyPageState();
}

class _ModifyPageState extends State<ModifyPage> {
  final ImagePicker picker = ImagePicker();
  late XFile avatar_xfile;
  late File _avatar_file;
  late String avatar;
  String _username = '张三';
  String defaultUserName = '';
  String _signature = '这是一个用户';
  String defaultSignature  = '';
  String defaultAvatar = '';
  bool hasNewAvatar = false;
  bool hasModified = false;
  late UserProvider userProvider;




  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context,listen: false);
    _username = userProvider.username;
    defaultUserName = _username;
    _signature = userProvider.description;
    defaultSignature = _signature;
    avatar = userProvider.avatar;
    defaultAvatar = avatar;

    return Scaffold(
      appBar: AppBar(
        title: Text('编辑信息'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50.0),
              _buildAvatar(),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: _username,
                decoration: const InputDecoration(
                  labelText: '用户名',
                ),
                onChanged: _updateUsername,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: _signature,
                decoration: const InputDecoration(
                  labelText: '描述',
                ),
                onChanged: _updateDescription,
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  bool avatarFlag = !hasNewAvatar;
                  bool signatureFlag = defaultSignature == _signature;
                  bool usernameFlag = defaultUserName == _username;


                  if(_username == ""){
                    Fluttertoast.showToast(
                      msg: "用户名不能为空",
                      toastLength: Toast.LENGTH_SHORT, // Toast持续时间，可以是Toast.LENGTH_SHORT或Toast.LENGTH_LONG
                      gravity: ToastGravity.BOTTOM, // Toast位置，可以是ToastGravity.TOP、ToastGravity.CENTER或ToastGravity.BOTTOM
                      backgroundColor: Colors.black, // Toast背景颜色
                      textColor: Colors.white, // Toast文本颜色
                      fontSize: 16.0,
                      //timeInSecForIosWeb: 1,// Toast文本字体大小
                    );
                  }else if(avatarFlag && signatureFlag && usernameFlag){
                    Fluttertoast.showToast(
                      msg: "未修改用户信息",
                      toastLength: Toast.LENGTH_SHORT,
                      // Toast持续时间，可以是Toast.LENGTH_SHORT或Toast.LENGTH_LONG
                      gravity: ToastGravity.BOTTOM,
                      // Toast位置，可以是ToastGravity.TOP、ToastGravity.CENTER或ToastGravity.BOTTOM
                      backgroundColor: Colors.black,
                      // Toast背景颜色
                      textColor: Colors.white,
                      // Toast文本颜色
                      fontSize: 16.0,
                      timeInSecForIosWeb: 2, // Toast文本字体大小
                    );
                  }
                  else {
                    bool hasSignatureModified = signatureFlag;
                    bool hasUsernameModified = usernameFlag;
                    bool hasAvatarModified = avatarFlag;

                    if(!avatarFlag){
                      hasAvatarModified |= await userProvider.modifyAvatar(
                          defaultUserName, _avatar_file.path);
                    }
                    if(!signatureFlag){
                      hasSignatureModified |= await userProvider.modifySignature(_signature);
                      //hasSignatureModified = true;
                    }
                    if(!usernameFlag){
                      hasUsernameModified |= await userProvider.modifyUsername(defaultUserName, _username);
                    }

                    if(hasAvatarModified && hasUsernameModified && hasSignatureModified){
                      Fluttertoast.showToast(
                        msg: "修改成功！",
                        toastLength: Toast.LENGTH_SHORT,
                        // Toast持续时间，可以是Toast.LENGTH_SHORT或Toast.LENGTH_LONG
                        gravity: ToastGravity.BOTTOM,
                        // Toast位置，可以是ToastGravity.TOP、ToastGravity.CENTER或ToastGravity.BOTTOM
                        backgroundColor: Colors.black,
                        // Toast背景颜色
                        textColor: Colors.white,
                        // Toast文本颜色
                        fontSize: 16.0,
                        timeInSecForIosWeb: 2, // Toast文本字体大小
                      );
                      Navigator.pop(context);
                    }else{
                      Fluttertoast.showToast(
                        msg: "修改失败",
                        toastLength: Toast.LENGTH_SHORT,
                        // Toast持续时间，可以是Toast.LENGTH_SHORT或Toast.LENGTH_LONG
                        gravity: ToastGravity.BOTTOM,
                        // Toast位置，可以是ToastGravity.TOP、ToastGravity.CENTER或ToastGravity.BOTTOM
                        backgroundColor: Colors.black,
                        // Toast背景颜色
                        textColor: Colors.white,
                        // Toast文本颜色
                        fontSize: 16.0,
                        timeInSecForIosWeb: 2, // Toast文本字体大小
                      );
                    }


                  }
                },
                child: Text('保存更改'),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  void _updateUsername(String value) {
    _username = value;
  }

  void _updateDescription(String value) {
    _signature = value;
  }
  ///构建头像
  Widget _buildAvatar() {
    ImageProvider defaultImageProvider =
    NetworkImage(avatar);

    return GestureDetector(
      onTap: () {
        selectAvatar();
        setState(() {});
      },
      child: hasNewAvatar
          ? CircleAvatar(
        radius: 100, // 设置圆形头像的半径
        backgroundImage: FileImage(File(avatar_xfile.path)),
      )
          : CircleAvatar(
        radius: 100,
        backgroundImage: defaultImageProvider,
      ),
    );
  }
  ///选择头像
  void selectAvatar() async {
    XFile image = (await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 80
    ))!;
    setState(() {
      avatar_xfile = image;
      _avatar_file = File(avatar_xfile.path);
      hasNewAvatar = true;
    });
  }
}