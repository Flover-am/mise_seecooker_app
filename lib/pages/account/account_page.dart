import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/models/user.dart';
import 'package:seecooker/pages/account/login_page.dart';
import 'package:seecooker/providers/user_provider.dart';
import 'package:seecooker/utils/shared_preferences_util.dart';
import 'package:skeletons/skeletons.dart';

import '../../providers/home_recipes_provider.dart';
import '../../widgets/recipe_card.dart';
import '../recipe/recipe_detail.dart';
import '../search/search_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  @override
  Widget build(BuildContext context) {
   //  var userProvider = Provider.of<UserProvider>(context);
   //
   // if(!userProvider.isLoggedIn){
   //   return _buildNotLoggedInProfileSection(context);
   // }
    return CustomScrollView(
        slivers: [
          SliverAppBar(
              backgroundColor: Color.fromRGBO(244,164,96, 1),
              pinned: true,
              expandedHeight: 240,
              scrolledUnderElevation: 0,
        //   bottom: const TabBar(
        //       tabs: [
        //       Tab(text: '选项卡1'),
        //   Tab(text: '选项卡2'),]
        // ),

            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 200, top: 30),
              expandedTitleScale: 2.4,
              title: const Column(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(
                          'https://example.com/avatar.jpg'), // 你的头像图片地址
                    )
                  ]
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFE0B2), // 起始颜色
                      Color(0xFFFFCC80), // 结束颜色
                    ],
                  ),
                ),
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top + 16),
                    Consumer<UserProvider>(
                      builder: (context, userProvider, child) {
                        userProvider.loadLoginStatus();
                        return userProvider.isLoggedIn
                            ? _buildLoggedInProfileSection(userProvider)
                            : _buildNotLoggedInProfileSection(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child:_buildTabBarSection(),
          ),

          // SliverToBoxAdapter(
          //   child: TabBarView(
          //     children: [
          //       _buildTabContent1(),
          //       _buildTabContent2(),
          //     ],
          //   ),
          // ),
          FutureBuilder(
            future: Provider.of<HomeRecipesProvider>(context, listen: false).fetchRecipes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: _buildSkeleton(context),
                );
              } else if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              } else {
                return const RecipeList();
              }
            },
          ),
        ]
    );
  }


}

Widget _buildTabContent2() {
  return NestedScrollView(
    headerSliverBuilder: (context, innerBoxIsScrolled) {
      return [
        SliverAppBar(
          pinned: true,
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('选项卡2内容'),
          ),
        ),
      ];
    },
    body: ListView.builder(
      itemCount: 5, // 假设有5个项目
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('选项卡2 - 项目 $index'),
        );
      },
    ),
  );
}

Widget _buildTabContent1() {
  return NestedScrollView(
    headerSliverBuilder: (context, innerBoxIsScrolled) {
      return [
        SliverAppBar(
          pinned: true,
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('选项卡1内容'),
          ),
        ),
      ];
    },
    body: ListView.builder(
      itemCount: 10, // 假设有10个项目
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('选项卡1 - 项目 $index'),
        );
      },
    ),
  );
}
  Widget _buildSkeleton(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        SkeletonLine(
          style: SkeletonLineStyle(
              height: MediaQuery.of(context).size.width - 48,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              borderRadius: BorderRadius.circular(12)
          ),
        ),
        const SizedBox(height: 24),
        SkeletonLine(
          style: SkeletonLineStyle(
              height: 368,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              borderRadius: BorderRadius.circular(12)
          ),
        ),
      ],
    );
  }


  Widget _buildLoggedInProfileSection(UserProvider userProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 42,
                backgroundImage: NetworkImage(
                  'https://example.com/avatar.jpg',
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userProvider.username,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('用户编号：xxxxxxxxx'), // 替换为用户描述
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            '替换为新的用户描述', // 新的用户描述内容
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              SizedBox(width: 10),
              Column(
                children: [
                  Text('10', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('发布数', style: TextStyle(fontSize: 12)),
                ],
              ),
              SizedBox(width: 20),
              Column(
                children: [
                  Text('20', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('点赞数', style: TextStyle(fontSize: 12)),
                ],
              ),
              SizedBox(width: 140),
              ElevatedButton(
                onPressed: () {
                  userProvider.logout();
                  //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AccountPage())),
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange, // 按钮背景色
                  onPrimary: Colors.white, // 文字颜色
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // 圆角大小
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // 按钮内边距
                ),
                child: Text('退出登录'),
              ),
            ],
          ),
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
            onPressed: () => {
              // 在此处理登录操作，可以跳转到登录页面等
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              )
            },
            child: const Text('登录'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarSection() {
    return const DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: '收藏菜谱'),
              Tab(text: '发布菜谱'),
              Tab(text: '发布帖子'),
            ],
            indicatorColor: Colors.blue, // 选项卡指示器颜色
          ),
          // SizedBox(
          //   height: 300, // 适当设置高度
          //   child: TabBarView(
          //     children: [
          //       // 收藏页面内容
          //       RecipeList(),
          //       RecipeList(),
          //       RecipeList()
          //
          //       // 发布页面内容
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildFavoriteContent() {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(20, (index) {
          return ListTile(
            title: Text('收藏项 $index'),
          );
        }),
      ),
    );
  }

  Widget _buildPublishedContent() {
    return const Center(
      child: Text('发布页面内容'),
    );
  }


class RecipeList extends StatelessWidget {
  const RecipeList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeRecipesProvider>(
        builder: (context, provider, child) {
          return SliverList(
              delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return ListTile(
              title: Text('Item $index'),
            );
          },
          childCount: 20, // 列表项的数量
          )
          );
        }
    );
  }
}