import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/pages/account/settings/settings_aboutUs_page.dart';
import 'package:seecooker/pages/account/settings/settings_account_page.dart';
import 'package:seecooker/pages/account/settings/settings_help_page.dart';
import 'package:seecooker/pages/account/settings/settings_support_page.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../providers/user/user_provider.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            title: const Text('账号与安全'),
            leading: const Icon(Icons.lock_outline_rounded),
            onTap: () {
              if(userProvider.isLoggedIn) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsAccountPage()),
                );
              }else{
                Fluttertoast.showToast(
                  msg: "请先登录账号",
                  toastLength: Toast.LENGTH_SHORT, // Toast持续时间，可以是Toast.LENGTH_SHORT或Toast.LENGTH_LONG
                  gravity: ToastGravity.BOTTOM, // Toast位置，可以是ToastGravity.TOP、ToastGravity.CENTER或ToastGravity.BOTTOM
                  backgroundColor: Colors.black, // Toast背景颜色
                  textColor: Colors.white, // Toast文本颜色
                  fontSize: 16.0,
                  //timeInSecForIosWeb: 1,// Toast文本字体大小
                );
              }
            },
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            title: const Text('帮助与客服'),
            leading: const Icon(Icons.help_outline_rounded),
            onTap: () {
              // 处理帮助与客服的逻辑
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsHelpPage()),
              );
            },
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            title: const Text('切换主题'),
            leading: const Icon(Icons.color_lens_outlined),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) => ThemeConsumer(
                      child: ThemeDialog(
                        title: const Text('切换主题'),
                        innerCircleRadius: 16,
                        animatedOpacityDuration: 500,
                        hasDescription: false,
                        selectedOverlayColor: Colors.transparent,
                      )
                  )
              );
            },
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            title: const Text('支持我们'),
            leading: const Icon(Icons.favorite_outline_rounded),
            onTap: () {
              // 处理支持我们的逻辑
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsSupportPage()),
              );
            },
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            title: const Text('关于我们'),
            leading: const Icon(Icons.info_outline_rounded),
            onTap: () {
              // 处理关于我们的逻辑
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsAboutUsPage()),
              );
            },
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            title: const Text('退出登录'),
            leading: const Icon(Icons.exit_to_app_rounded),
            onTap: () {
              // 处理退出登录的逻辑
              if(userProvider.isLoggedIn) {
                userProvider.logout();
                Navigator.pop(context);
              }else{
                Fluttertoast.showToast(
                  msg: "请先登录账号",
                  toastLength: Toast.LENGTH_SHORT, // Toast持续时间，可以是Toast.LENGTH_SHORT或Toast.LENGTH_LONG
                  gravity: ToastGravity.BOTTOM, // Toast位置，可以是ToastGravity.TOP、ToastGravity.CENTER或ToastGravity.BOTTOM
                  backgroundColor: Colors.black, // Toast背景颜色
                  textColor: Colors.white, // Toast文本颜色
                  fontSize: 16.0,
                  //timeInSecForIosWeb: 1,// Toast文本字体大小
                );
              }
            },
          ),
        ],
      ),
    );
  }
}