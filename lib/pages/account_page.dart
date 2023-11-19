import 'package:flutter/material.dart';
import 'package:seecooker/pages/login_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  //var text = 'account';
  bool isLoggedIn = false; // 默认未登录

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
      ),
      body: ListView(
        children: [
          // 个人信息部分
          isLoggedIn
              ? _buildLoggedInProfileSection()
              : _buildNotLoggedInProfileSection(context),

          // 收藏和发布栏目
          _buildTabBarSection(),
        ],
      ),
    );
  }

  Widget _buildLoggedInProfileSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
                'https://example.com/avatar.jpg'), // 你的头像图片地址
          ),
          const SizedBox(height: 16),
          const Text(
            '用户名',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text('用户描述或其他信息'),

          // 发布数和获赞数
          _buildUserStats(),
        ],
      ),
    );
  }

  Widget _buildUserStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatItem('发布数', 'X'),
        const SizedBox(width: 16),
        _buildStatItem('获赞数', 'Y'),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildNotLoggedInProfileSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '还未登录',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              // 在此处理登录操作，可以跳转到登录页面等
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );

              // 根据返回的结果更新 isLoggedIn 变量
              if (result == true) {
                setState(() {
                  isLoggedIn = true;
                });
              }
            },
            child: const Text('登录'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarSection() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: '收藏'),
              Tab(text: '发布'),
            ],
            indicatorColor: Colors.blue, // 选项卡指示器颜色
          ),
          SizedBox(
            height: 300, // 适当设置高度
            child: TabBarView(
              children: [
                // 收藏页面内容
                _buildFavoriteContent(),

                // 发布页面内容
                _buildPublishedContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteContent() {
    return const Center(
      child: Text('收藏页面内容'),
    );
  }

  Widget _buildPublishedContent() {
    return const Center(
      child: Text('发布页面内容'),
    );
  }
}