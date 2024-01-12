import 'package:flutter/material.dart';

/// 关于我们页面
class SettingsAboutUsPage extends StatelessWidget {
  const SettingsAboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于我们'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('应用信息'),
            onTap: () {
              // 处理显示应用信息的逻辑
            },
          ),
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('团队介绍'),
            onTap: () {
              // 处理显示团队介绍的逻辑
            },
          ),
          ListTile(
            leading: const Icon(Icons.policy_outlined),
            title: const Text('隐私政策'),
            onTap: () {
              // 处理显示隐私政策的逻辑
            },
          ),
        ],
      ),
    );
  }
}