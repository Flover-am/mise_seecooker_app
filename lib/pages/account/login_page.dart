import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/models/user.dart';
import 'package:seecooker/providers/user_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登录'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

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
        // 添加 seecooker 的 logo
        Image.asset(
          'assets/images/seecooker_logo.png', // 请将图片路径替换为你实际的图片路径
          height: 200, // 根据需要调整高度
        ),
        const SizedBox(height: 16),
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
          onPressed: () {
            // 在此处理登录逻辑，例如验证用户输入等
            String username = _usernameController.text;
            String password = _passwordController.text;

            // 获取当前上下文中的 UserModel 实例
            final userProvider = Provider.of<UserProvider>(context, listen: false);

            // 简单的示例：如果用户名和密码都不为空，视为登录成功
            if (username == 'admin' && password == '123456') {
              userProvider.loginAdmin();
              // 登录成功后可以使用 Navigator.pop 或 Navigator.pushReplacement 返回上一个页面
              Navigator.pop(context);
              // 或者你可以进行其他操作
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('登录成功'),
                  duration: Duration(seconds: 2),
                ),
              );
            } else {
              // 登录失败的处理，例如显示错误消息
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('用户名和密码不能为空'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          child: const Text('登录'),
        ),
      ],
    )
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


