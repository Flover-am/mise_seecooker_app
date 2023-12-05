import 'package:flutter/material.dart';

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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
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
            // 在此处理注册逻辑，例如验证用户输入等
            String username = _usernameController.text;
            String password = _passwordController.text;

            // 执行注册操作
            // ...

            // 注册成功后可以进行其他操作，例如显示成功消息
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('注册成功'),
                duration: Duration(seconds: 2),
              ),
            );
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
}