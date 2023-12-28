import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/providers/user_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:seecooker/utils/FileConverter.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('注册'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RegisterForm(),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final ImagePicker picker = ImagePicker();
  late XFile avatar_xfile;
  late File avatar_file;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool hasNewAvatar = false;


  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);

    return SingleChildScrollView(
        child:Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildAvatar(),


        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: '用户名',
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: '密码',
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () async {
            // 在此处理注册逻辑，例如验证用户输入等
            String username = _usernameController.text;
            String password = _passwordController.text;

            if(!hasNewAvatar){
              Fluttertoast.showToast(
                msg: "头像不能为空",
                toastLength: Toast.LENGTH_SHORT, // Toast持续时间，可以是Toast.LENGTH_SHORT或Toast.LENGTH_LONG
                gravity: ToastGravity.BOTTOM, // Toast位置，可以是ToastGravity.TOP、ToastGravity.CENTER或ToastGravity.BOTTOM
                backgroundColor: Colors.black, // Toast背景颜色
                textColor: Colors.white, // Toast文本颜色
                fontSize: 16.0,
                //timeInSecForIosWeb: 1,// Toast文本字体大小
              );
            }else if(username == ""){
              Fluttertoast.showToast(
                msg: "用户名不能为空",
                toastLength: Toast.LENGTH_SHORT, // Toast持续时间，可以是Toast.LENGTH_SHORT或Toast.LENGTH_LONG
                gravity: ToastGravity.BOTTOM, // Toast位置，可以是ToastGravity.TOP、ToastGravity.CENTER或ToastGravity.BOTTOM
                backgroundColor: Colors.black, // Toast背景颜色
                textColor: Colors.white, // Toast文本颜色
                fontSize: 16.0,
                //timeInSecForIosWeb: 1,// Toast文本字体大小
              );
            }else if(password == ""){
              Fluttertoast.showToast(
                msg: "密码不能为空",
                toastLength: Toast.LENGTH_SHORT, // Toast持续时间，可以是Toast.LENGTH_SHORT或Toast.LENGTH_LONG
                gravity: ToastGravity.BOTTOM, // Toast位置，可以是ToastGravity.TOP、ToastGravity.CENTER或ToastGravity.BOTTOM
                backgroundColor: Colors.black, // Toast背景颜色
                textColor: Colors.white, // Toast文本颜色
                fontSize: 16.0,
                //timeInSecForIosWeb: 1,// Toast文本字体大小
              );
            }else if (!isPasswordValid(password)){

            }
            else {
              // 执行注册操作
              var isRegistered = await userProvider.register(
                  username, password, avatar_xfile.path);

              if (isRegistered) {
                Fluttertoast.showToast(
                  msg: "账号注册成功！",
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
              }
              else {
                Fluttertoast.showToast(
                  msg: "用户名已被使用",
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
          child: const Text('注册'),
        ),
      ],
    ),
    );
  }

  @override
  void dispose() {
    // 释放控制器资源
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildAvatar() {
    ImageProvider defaultImageProvider = AssetImage('assets/images/tmp/avatar.png');
    return GestureDetector(
        onTap: () {
          selectAvatar();
          setState(() {
          });
        },
      child:
          hasNewAvatar
              ?
          CircleAvatar(
            radius: 100, // 设置圆形头像的半径
            backgroundImage: FileImage(File(avatar_xfile.path)),
          )
              :
      CircleAvatar(
        radius: 100,
        backgroundImage: defaultImageProvider,
      )
    );
  }
  void selectAvatar() async {
    XFile image = (await picker.pickImage(source: ImageSource.gallery))!;
    setState((){
      hasNewAvatar = true;
      avatar_xfile = image;
      avatar_file = convertXFileToFile(avatar_xfile);
    });
  }

  bool isPasswordValid(String password) {
    if(!isPasswordContainNumAndLetter(password)){
      Fluttertoast.showToast(
          msg: "密码必须同时包含字母和数字",
          toastLength: Toast.LENGTH_SHORT, // Toast持续时间，可以是Toast.LENGTH_SHORT或Toast.LENGTH_LONG
          gravity: ToastGravity.BOTTOM, // Toast位置，可以是ToastGravity.TOP、ToastGravity.CENTER或ToastGravity.BOTTOM
          backgroundColor: Colors.black, // Toast背景颜色
          textColor: Colors.white, // Toast文本颜色
          fontSize: 16.0 // Toast文本字体大小
      );
      return false;
    }else if(password.length < 6 || password.length > 56){
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
  bool isPasswordContainNumAndLetter(String password) {
    // 判断密码是否同时包含字母和数字
    RegExp digitRegex = RegExp(r'\d');
    RegExp letterRegex = RegExp(r'[a-zA-Z]');

    bool containsDigit = digitRegex.hasMatch(password);
    bool containsLetter = letterRegex.hasMatch(password);

    return containsDigit && containsLetter;
  }
}

Future<File> createTemporaryFileFromAsset(String assetPath) async {
  final byteData = await rootBundle.load(assetPath);
  final tempDir = await getTemporaryDirectory();
  final tempFile = File('${tempDir.path}/${assetPath.split('/').last}');
  await tempFile.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
  return tempFile;
}

File convertXFileToFile(XFile xfile) {
  return File(xfile.path);
}