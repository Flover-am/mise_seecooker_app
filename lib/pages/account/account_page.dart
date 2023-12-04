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
  // Widget build(BuildContext context) {
  //
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('我的'),
  //     ),
  //     body: ListView(
  //       children: [
  //         // 个人信息部分
  //         Consumer<UserProvider>(
  //           builder: (context, userProvider, child) {
  //             userProvider.loadLoginStatus();
  //             return userProvider.isLoggedIn
  //                 ? _buildLoggedInProfileSection(userProvider)
  //                 : _buildNotLoggedInProfileSection(context);
  //           },
  //         ),
  //         // 收藏和发布栏目
  //         _buildTabBarSection(),
  //       ],
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
   //  var userProvider = Provider.of<UserProvider>(context);
   //
   // if(!userProvider.isLoggedIn){
   //   return _buildNotLoggedInProfileSection(context);
   // }
    return CustomScrollView(
        slivers: [
          SliverAppBar(
              pinned: true,
              expandedHeight: 350,
              scrolledUnderElevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 24, top: 30),
                expandedTitleScale: 1,
                title: Column(
                  children:[
                   Text('我的', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  // _buildTabBarSection(),
                  ]
                ),
                // title: Text('我的', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                background: Padding(


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
                            _buildLoggedInProfileSection(userProvider);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
                  },
                ),
                const SizedBox(width: 4),
              ]
          ),
          SliverToBoxAdapter(
            child:_buildTabBarSection(),
          ),

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
                Text(
            userProvider.username,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text('用户描述或其他信息'),

          // 发布数和获赞数
          _buildUserStats(),

          // 添加退出登录按钮
          ElevatedButton(
            onPressed: () =>{
              userProvider.logout(),
              //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AccountPage())),
            },
            child: const Text('退出登录'),
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
          //       _buildFavoriteContent(),
          //
          //       // 发布页面内容
          //       _buildPublishedContent(),
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
}

class RecipeList extends StatelessWidget {
  const RecipeList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeRecipesProvider>(
        builder: (context, provider, child) {
          return SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  if (index == provider.length - 1) {
                    provider.fetchMoreRecipes();
                  }
                  return TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 500),
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: child,
                      );
                    },
                    child: GestureDetector(
                      child: RecipeCard(
                        recipeId: provider.itemAt(index).recipeId,
                        name: provider.itemAt(index).name,
                        cover: provider.itemAt(index).cover,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RecipeDetail(id: index)));
                      },
                    ),
                  );
                },
                childCount: provider.length,
              )
          );
        }
    );
  }
}