import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/models/user.dart';
import 'package:seecooker/pages/account/register_page.dart';
import 'package:seecooker/providers/user_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          '欢迎登录',
          style: TextStyle(
            fontSize: 22,
            letterSpacing: 2.0, // 调整字间距
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          // 添加 seecooker 的 logo
          Image.asset(
            'assets/images/seecooker_logo.png', // 请将图片路径替换为你实际的图片路径
            height: 200, // 根据需要调整高度
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: '用户名',
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: '密码',
            ),
          ),
          const SizedBox(height: 48),
          FilledButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all<Size>(
                const Size(96, 48), // 设置按钮的宽度和高度
              ),
            ),
            onPressed: () async {
              // 在此处理登录逻辑，例如验证用户输入等
              String username = _usernameController.text;
              String password = _passwordController.text;

              if(username == "") {
                Fluttertoast.showToast(msg: "用户名不能为空");
              } else if(password == "") {
                Fluttertoast.showToast(msg: "密码不能为空");
              } else {
                // 获取当前上下文中的 UserModel 实例
                final userProvider = Provider.of<UserProvider>(
                    context, listen: false);
                try {
                  await userProvider.login(username, password);
                } catch (e) {
                  // 处理异常的代码
                  if(e.toString().contains("Password error")) {
                    Fluttertoast.showToast(msg: "密码输入错误");
                  } else if(e.toString().contains("User not exist")){
                    Fluttertoast.showToast(msg: "账号不存在");
                  }
                }
                // 简单的示例：如果用户名和密码都不为空，视为登录成功
                if (userProvider.isLoggedIn) {
                  // 登录成功后可以使用 Navigator.pop 或 Navigator.pushReplacement 返回上一个页面
                  Navigator.pop(context);
                  // 或者你可以进行其他操作
                  Fluttertoast.showToast(
                    msg: "账号登录成功！",
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
                }
              }
            },
            child: const Text(
              '登录',
              style: TextStyle(fontSize: 16), // 设置字体大小
            ),
          ),
          const SizedBox(height: 22),
          Text.rich(
              TextSpan(
                  style: Theme.of(context).textTheme.labelLarge,
                  children: [
                    TextSpan(
                        text: '还没有账号？点击这里',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                        )
                    ),
                    TextSpan(
                      text: '注册 ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          );
                        },
                    )
                  ]
              )
          ),
          const SizedBox(height: 48),
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
}


