import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/pages/account/settings/settings_account_page.dart';
import 'package:seecooker/providers/user/user_provider.dart';

class SettingsHelpPage extends StatelessWidget {
  const SettingsHelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('帮助与客服'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('发送邮件'),
            subtitle: const Text('support@example.com'),
            onTap: () {
              // 处理发送邮件的逻辑
              // 可以使用flutter_email_sender或url_launcher等库来实现发送邮件的功能
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone_outlined),
            title: const Text('拨打电话'),
            subtitle: const Text('123-456-7890'),
            onTap: () {
              // 处理拨打电话的逻辑
              // 可以使用url_launcher库来实现拨打电话的功能
            },
          ),
        ],
      ),
    );
  }
}