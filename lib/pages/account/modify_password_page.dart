import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:seecooker/providers/user_provider.dart';

class ModifyPasswordPage extends StatefulWidget {
  @override
  _ModifyPasswordPageState createState() => _ModifyPasswordPageState();
}

class _ModifyPasswordPageState extends State<ModifyPasswordPage> {
  String _oldPassword = '';
  String _newPassword = '';
  String _doubledPassword = '';
  late UserProvider userProvider;




  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context,listen: false);


    return Scaffold(
      appBar: AppBar(
        title: Text('修改密码'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50.0),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: _oldPassword,
                decoration: InputDecoration(
                  labelText: '旧密码',
                ),
                onChanged: _updateOldPassword,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: _newPassword,
                decoration: const InputDecoration(
                  labelText: '新密码',
                ),
                onChanged: _updateNewPassword,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: _doubledPassword,
                decoration: const InputDecoration(
                  labelText: '再次输入新密码',
                ),
                onChanged: _updateDoubledPassword,
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  print(userProvider.username);
                  print(_oldPassword);
                  print(_newPassword);
                  bool hasPasswordModified = await userProvider.modifyPassword(userProvider.username,_oldPassword,_newPassword);

                  if(hasPasswordModified){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('修改密码成功!'),
                            duration: Duration(seconds: 2),
                          )
                        );
                        hasPasswordModified = false;
                        Navigator.pop(context);
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('修改密码失败'),
                          duration: Duration(seconds: 2),
                        )
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

  void _updateOldPassword(String value) {
    _oldPassword = value;
  }

  void _updateNewPassword(String value) {
    _newPassword = value;
  }

  void _updateDoubledPassword(String value) {
    _doubledPassword = value;
  }

}
