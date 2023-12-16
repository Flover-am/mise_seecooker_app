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
                  if(_newPassword == '' || _oldPassword == '' || _doubledPassword == '') {
                    Fluttertoast.showToast(
                        msg: "请填完所有信息",
                        toastLength: Toast.LENGTH_SHORT, // Toast持续时间，可以是Toast.LENGTH_SHORT或Toast.LENGTH_LONG
                        gravity: ToastGravity.BOTTOM, // Toast位置，可以是ToastGravity.TOP、ToastGravity.CENTER或ToastGravity.BOTTOM
                        backgroundColor: Colors.black, // Toast背景颜色
                        textColor: Colors.white, // Toast文本颜色
                        fontSize: 16.0 // Toast文本字体大小
                    );
                  }else {
                    bool isNewPasswordValidFlag = isNewPasswordValid(
                        _newPassword, _doubledPassword);
                    if (isNewPasswordValidFlag) {
                      bool hasPasswordModified = await userProvider
                          .modifyPassword(
                          userProvider.username, _oldPassword, _newPassword);
                      if (hasPasswordModified) {
                        Fluttertoast.showToast(
                            msg: "修改密码成功！",
                            toastLength: Toast.LENGTH_SHORT,
                            // Toast持续时间，可以是Toast.LENGTH_SHORT或Toast.LENGTH_LONG
                            gravity: ToastGravity.BOTTOM,
                            // Toast位置，可以是ToastGravity.TOP、ToastGravity.CENTER或ToastGravity.BOTTOM
                            backgroundColor: Colors.black,
                            // Toast背景颜色
                            textColor: Colors.white,
                            // Toast文本颜色
                            fontSize: 16.0 // Toast文本字体大小
                        );
                        hasPasswordModified = false;
                        Navigator.pop(context);
                      } else {
                        Fluttertoast.showToast(
                            msg: "原密码输入错误！",
                            toastLength: Toast.LENGTH_SHORT,
                            // Toast持续时间，可以是Toast.LENGTH_SHORT或Toast.LENGTH_LONG
                            gravity: ToastGravity.BOTTOM,
                            // Toast位置，可以是ToastGravity.TOP、ToastGravity.CENTER或ToastGravity.BOTTOM
                            backgroundColor: Colors.black,
                            // Toast背景颜色
                            textColor: Colors.white,
                            // Toast文本颜色
                            fontSize: 16.0 // Toast文本字体大小
                        );
                      }
                    } else {}
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

  bool isNewPasswordValid(String newPassword,String doubledPassword){
    if(newPassword != doubledPassword){
      Fluttertoast.showToast(
          msg: "两次密码输入不相同",
          toastLength: Toast.LENGTH_SHORT, // Toast持续时间，可以是Toast.LENGTH_SHORT或Toast.LENGTH_LONG
          gravity: ToastGravity.BOTTOM, // Toast位置，可以是ToastGravity.TOP、ToastGravity.CENTER或ToastGravity.BOTTOM
          backgroundColor: Colors.black, // Toast背景颜色
          textColor: Colors.white, // Toast文本颜色
          fontSize: 16.0 // Toast文本字体大小
      );
      return false;
    }else if(!isPasswordContainNumAndLetter(newPassword)){
      Fluttertoast.showToast(
          msg: "密码必须同时包含字母和数字",
          toastLength: Toast.LENGTH_SHORT, // Toast持续时间，可以是Toast.LENGTH_SHORT或Toast.LENGTH_LONG
          gravity: ToastGravity.BOTTOM, // Toast位置，可以是ToastGravity.TOP、ToastGravity.CENTER或ToastGravity.BOTTOM
          backgroundColor: Colors.black, // Toast背景颜色
          textColor: Colors.white, // Toast文本颜色
          fontSize: 16.0 // Toast文本字体大小
      );
      return false;
    }else if(newPassword.length < 6 || newPassword.length > 56){
      Fluttertoast.showToast(
          msg: "密码长度必须在 6-56 之间",
          toastLength: Toast.LENGTH_SHORT, // Toast持续时间，可以是Toast.LENGTH_SHORT或Toast.LENGTH_LONG
          gravity: ToastGravity.BOTTOM, // Toast位置，可以是ToastGravity.TOP、ToastGravity.CENTER或ToastGravity.BOTTOM
          backgroundColor: Colors.black, // Toast背景颜色
          textColor: Colors.white, // Toast文本颜色
          fontSize: 16.0 // Toast文本字体大小
      );
      return false;
    }


    return true;
  }
  bool isPasswordContainNumAndLetter(String newPassword) {
    // 判断密码是否同时包含字母和数字
    RegExp digitRegex = RegExp(r'\d');
    RegExp letterRegex = RegExp(r'[a-zA-Z]');

    bool containsDigit = digitRegex.hasMatch(newPassword);
    bool containsLetter = letterRegex.hasMatch(newPassword);

    return containsDigit && containsLetter;
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
