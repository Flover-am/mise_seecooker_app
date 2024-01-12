import 'package:flutter/material.dart';

/// 支持我们页面
class SettingsSupportPage extends StatelessWidget {
  const SettingsSupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('支持我们'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.shopping_cart_outlined),
            title: const Text('购买高级版'),
            onTap: () {
              // 处理购买高级版的逻辑
            },
          ),
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('赞助开发者'),
            onTap: () {
              // 处理赞助开发者的逻辑
            },
          ),
        ],
      ),
    );
  }
}