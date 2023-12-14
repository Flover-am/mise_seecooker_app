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
import 'package:tabbed_sliverlist/tabbed_sliverlist.dart';

import 'modify_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  bool flag = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

  }

  @override
  Widget build(BuildContext context){


    return NestedScrollView(
        body: buildBodyWidget(context),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            buildSliverAppBar(),
          ]; },
      );

  }

  buildBodyWidget(BuildContext context) {
    return TabBarView(
      controller: _tabController,
      children: [
      _buildFavoriteContent(context),
      _buildFavoriteContent(context),
      _buildFavoriteContent(context),
    ],);
  }

  buildSliverAppBar() {
    return SliverAppBar(
              backgroundColor: Color.fromRGBO(244,164,96, 1),
              pinned: true,
              expandedHeight: 280,
              toolbarHeight: 30,
              scrolledUnderElevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 190, top: 30),
                expandedTitleScale: 2,
                title: const Column(
                    children: [
                      CircleAvatar(
                        radius: 15,
                      //   backgroundImage: NetworkImage(
                      //       'https://example.com/avatar.jpg'), // 你的头像图片地址
                      // )
                    backgroundImage: AssetImage('assets/images/tmp/avatar.png'),
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
            bottom: TabBar(controller: _tabController, tabs: const [
              Tab(text: '收藏',),
              Tab(text: '收藏'),
              Tab(text: '收藏'),
      ],        labelColor: Colors.black, // 设置选中标签的文本颜色为白色
                unselectedLabelColor: Colors.black,
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ModifyPage()),
              );
            },
          ),
        ]
    );
  }


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
                // backgroundImage: NetworkImage(
                //   'https://example.com/avatar.jpg',
                // ),
                backgroundImage: NetworkImage(userProvider.avatar),
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
            userProvider.description,
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
                  Text(userProvider.postNum.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('发布数', style: TextStyle(fontSize: 12)),
                ],
              ),
              SizedBox(width: 20),
              Column(
                children: [
                  Text(userProvider.getLikedNum.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('点赞数', style: TextStyle(fontSize: 12)),
                ],
              ),
              SizedBox(width: 120),
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


Widget _buildNotLoggedInProfileSection(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(60),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
            onPressed: () {
              // 在此处理登录操作，可以跳转到登录页面等
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text('登录'),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildFavoriteContent(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    if (!userProvider.isLoggedIn) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '请先登录',
              style: TextStyle(fontSize: 20), // 设置字体大小为24
            ),
          ],
        ),
      );
    }

      return SingleChildScrollView(
        // child:  FutureBuilder(
        //         future: Provider.of<HomeRecipesProvider>(context, listen: false).fetchRecipes(),
        //         builder: (context, snapshot) {
        //           if (snapshot.connectionState == ConnectionState.waiting) {
        //             return _buildSkeleton(context);
        //
        //           } else if (snapshot.hasError) {
        //             return Center(
        //                 child: Text('Error: ${snapshot.error}'),
        //               );
        //
        //           } else {
        //             return const RecipeList();
        //           }
        //         },
        //       ),
        child: const RecipeList(),
    );
  }



class RecipeList extends StatelessWidget {
  const RecipeList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(20, (index) {
        return ListTile(
          title: Text('收藏项 $index'),
        );
      }),);
  }
}