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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);

    return Column(
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

            var avatar = await createTemporaryFileFromAsset('assets/images/tmp/avatar_register.jpeg');
            // TODO: 使用自选照片
            //var avatar = convertXFileToFile(avatar_xfile);

            // 执行注册操作
            var isRegistered = await userProvider.register(username, password, avatar);

            if (isRegistered) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('注册成功'),
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.pop(context);

            }
            else {
              ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('注册失败'),
                duration: Duration(seconds: 2),
              ),
            );
            }
          },
          child: const Text('注册'),
        ),
      ],
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
        backgroundImage: AssetImage('assets/images/avatar.png'),
      )
    );
  }
  void selectAvatar() async {
    XFile image = (await picker.pickImage(source: ImageSource.gallery))!;
    setState(() {
      avatar_xfile = image;
    });
  }
}

Future<File> createTemporaryFileFromAsset(String assetPath) async {
  final byteData = await rootBundle.load(assetPath);
  final tempDir = await getTemporaryDirectory();
  final tempFile = File('${tempDir.path}/${assetPath.split('/').last}');
  await tempFile.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
  return tempFile;
}

Future<File> convertXFileToFile(XFile xfile) async {
  return File(xfile.path);
}