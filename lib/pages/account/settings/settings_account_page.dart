import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/pages/account/modify_password_page.dart';
import 'package:seecooker/pages/account/settings/settings_account_page.dart';
import 'package:seecooker/providers/user_provider.dart';

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