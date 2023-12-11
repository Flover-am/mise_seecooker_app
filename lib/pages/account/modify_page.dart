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
  String _oldUserName = '';
  String _description = '这是一个用户';
  String _oldDescription  = '';
  bool hasNewAvatar = false;
  bool hasModified = false;

  void _updateUsername(String value) {
    setState(() {
      _oldUserName = _username;
      _username = value;
      hasModified = true;
    });
  }

  void _updateDescription(String value) {
    setState(() {
      _oldDescription = _description;
      _description = value;
      hasModified = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    _username = userProvider.username;
    _oldUserName = _username;
    _description = userProvider.description;
    _oldDescription = _description;

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

                  if (hasModified) {
                    var hasModifiedSuccess = await userProvider.modify(_username, _description, avatar_xfile.path);

                    if(hasModifiedSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('修改成功!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      hasModified = false;
                      Navigator.pop(context);
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('错误:修改失败'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }

                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('抱歉，用户信息未改动'),
                        duration: Duration(seconds: 2),
                      ),
                    );
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

  Widget _buildAvatar() {
    ImageProvider defaultImageProvider =
    AssetImage('assets/images/tmp/avatar.png');

    return GestureDetector(
      onTap: () {
        selectAvatar();
        setState(() {});
      },
      child: hasNewAvatar
          ? CircleAvatar(
        radius: 100,
        child: ClipOval(
          child: Image.file(File(avatar_xfile.path), fit: BoxFit.fitWidth),
        ),
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