import 'package:flutter/material.dart';
import 'package:seecooker/pages/account/modify/modify_password_page.dart';

/// 账户设置页面
class SettingsAccountPage extends StatelessWidget {
  const SettingsAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('账号与安全'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('修改密码'),
            leading: const Icon(Icons.lock_outline),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ModifyPasswordPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}