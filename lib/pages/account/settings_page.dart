import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/providers/user_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('账号与安全'),
            leading: const Icon(Icons.lock),
            onTap: () {
              // 处理账号与安全的逻辑
            },
          ),
          ListTile(
            title: const Text('帮助与客服'),
            leading: const Icon(Icons.help),
            onTap: () {
              // 处理帮助与客服的逻辑
            },
          ),
          ListTile(
            title: const Text('支持我们'),
            leading: const Icon(Icons.favorite),
            onTap: () {
              // 处理支持我们的逻辑
            },
          ),
          ListTile(
            title: const Text('关于我们'),
            leading: const Icon(Icons.info),
            onTap: () {
              // 处理关于我们的逻辑
            },
          ),
          ListTile(
            title: const Text('退出登录'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () {
              // 处理退出登录的逻辑
              UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);
              userProvider.logout();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}