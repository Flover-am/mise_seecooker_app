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
  String _username = '张三';
  String _description = '这是一个用户';
  String _password = '这是一个密码';

  void _updateUsername(String value) {
    setState(() {
      _username = value;
    });
  }

  void _updateDescription(String value) {
    setState(() {
      _description = value;
    });
  }

  void _updatePassword(String value) {
    setState(() {
      _password = value;
    });
  }

  void _saveChanges() {
    // 将更改保存到服务器或执行必要的操作
    // 为了简单起见，这里只打印更新后的值
    print('用户名：$_username');
    print('描述：$_description');
    print('密码：$_password');
    // 您可以返回到上一个屏幕或执行其他所需操作
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    _username = userProvider.username;
    _description = userProvider.description;
    _password = userProvider.password;


    return Scaffold(
      appBar: AppBar(
        title: Text('编辑信息'),
      ),
      body: SingleChildScrollView( // 使用SingleChildScrollView包裹内容
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: _password,
                decoration: InputDecoration(
                  labelText: "密码",
                ),
                onChanged: _updatePassword,
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _saveChanges,
                child: Text('保存更改'),
              ),
              SizedBox(height: 16.0), // 添加额外的间距以避免底部输入框被键盘遮挡
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return GestureDetector(
        onTap: () {
          Fluttertoast.showToast(msg: "//TODO: 跳转到相册添加图片");
          selectAvatar();
          setState(() {
          });
        },
        child:
        CircleAvatar(
          radius: 100,
          backgroundImage: AssetImage('assets/images/tmp/avatar.png'),
        )
    );
  }
  void selectAvatar() async {
    XFile image = (await picker.pickImage(source: ImageSource.gallery))!;
    setState(() async {
      avatar_xfile = image;
      _avatar_file = await convertXFileToFile(avatar_xfile);
    });
  }
  Future<File> convertXFileToFile(XFile xfile) async {
    return File(xfile.path);
  }
}

