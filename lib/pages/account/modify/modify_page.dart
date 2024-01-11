import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:seecooker/providers/user_provider.dart';

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
  String _description = '这是一个用户';
  String defaultDescription  = '';
  String defaultAvatar = '';
  bool hasNewAvatar = false;
  bool hasModified = false;
  late UserProvider userProvider;




  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context,listen: false);
    _username = userProvider.username;
    defaultUserName = _username;
    _description = userProvider.description;
    defaultDescription = _description;
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
              SizedBox(height: 50.0),
              _buildAvatar(),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: _username,
                decoration: InputDecoration(
                  labelText: '用户名',
                ),
                onChanged: _updateUsername,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(
                  labelText: '描述',
                ),
                onChanged: _updateDescription,
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
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
                  }else {
                    bool hasUsernameModified = false;
                    bool hasAvatarModified = false;
                    if (hasNewAvatar) {
                      hasAvatarModified = await userProvider.modifyAvatar(
                          defaultUserName, _avatar_file.path);
                      if (!hasAvatarModified) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(
                        //     content: Text('错误:修改失败'),
                        //     duration: Duration(seconds: 2),
                        //   ),
                        // );
                      } else {
                        hasNewAvatar = false;
                      }
                    }
                    if (defaultUserName != _username) {
                      //CircularProgressIndicator();
                      hasUsernameModified = await userProvider.modifyUsername(
                          defaultUserName, _username);
                      //TODO:wait for server make an api
                      if (!hasUsernameModified) {
                        Fluttertoast.showToast(
                          msg: "用户名已经存在",
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
                    if (hasUsernameModified || hasAvatarModified) {
                      if(hasAvatarModified && hasUsernameModified) {
                        Fluttertoast.showToast(
                          msg: "头像和用户名修改成功！",
                          toastLength: Toast.LENGTH_SHORT,
                          // Toast持续时间，可以是Toast.LENGTH_SHORT或Toast.LENGTH_LONG
                          gravity: ToastGravity.BOTTOM,
                          // Toast位置，可以是ToastGravity.TOP、ToastGravity.CENTER或ToastGravity.BOTTOM
                          backgroundColor: Colors.black,
                          // Toast背景颜色
                          textColor: Colors.white,
                          // Toast文本颜色
                          fontSize: 16.0,
                          //timeInSecForIosWeb: 1,// Toast文本字体大小
                        );
                      }else if(hasAvatarModified){
                        Fluttertoast.showToast(
                          msg: "头像修改成功！",
                          toastLength: Toast.LENGTH_SHORT,
                          // Toast持续时间，可以是Toast.LENGTH_SHORT或Toast.LENGTH_LONG
                          gravity: ToastGravity.BOTTOM,
                          // Toast位置，可以是ToastGravity.TOP、ToastGravity.CENTER或ToastGravity.BOTTOM
                          backgroundColor: Colors.black,
                          // Toast背景颜色
                          textColor: Colors.white,
                          // Toast文本颜色
                          fontSize: 16.0,
                          //timeInSecForIosWeb: 1,// Toast文本字体大小
                        );
                      }else if(hasUsernameModified){
                        Fluttertoast.showToast(
                          msg: "用户名修改成功！",
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

                      Navigator.pop(context);
                    }else{
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
    _description = value;
  }

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

  void selectAvatar() async {
    XFile image = (await picker.pickImage(source: ImageSource.gallery))!;
    setState(() {
      avatar_xfile = image;
      _avatar_file = File(avatar_xfile.path);
      hasNewAvatar = true;
    });
  }
}