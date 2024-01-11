import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/models/user.dart';
import 'package:seecooker/pages/account/login_page.dart';
import 'package:seecooker/providers/user/user_provider.dart';
import 'package:seecooker/providers/user/user_recipe_provider.dart';
import 'package:seecooker/utils/shared_preferences_util.dart';
import 'package:seecooker/widgets/posts_waterfall.dart';
import 'package:skeletons/skeletons.dart';

import '../../providers/recipe/home_recipes_provider.dart';
import '../../providers/post/community_posts_provider.dart';
import '../../providers/recipe/search_recipes_provider.dart';
import '../../widgets/recipe_card.dart';
import '../../widgets/recipes_list.dart';
import '../recipe/recipe_detail.dart';
import '../search/search_page.dart';
import 'package:tabbed_sliverlist/tabbed_sliverlist.dart';

import 'modify/modify_page.dart';
import 'settings/settings_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  bool flag = false;
  ScrollController _scrollController = ScrollController();
  bool isPinned = true;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);
    userProvider.loadLoginStatus();

    _scrollController.addListener(() {
      setState(() {
        isPinned = _scrollController.offset > 0;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    UserProvider userProvider = Provider.of<UserProvider>(context);
    int id = userProvider.id;
    return ChangeNotifierProvider<UserRecipeProvider>(
        create: (_) => UserRecipeProvider(id),
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          body: buildBodyWidget(context),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              buildSliverAppBar(userProvider),
            ]; },
        ),
        floatingActionButton: isPinned ? FloatingActionButton(
          heroTag: UniqueKey(),
          onPressed: () {
            // 处理悬浮按钮点击事件
            _scrollController.jumpTo(0);
          },
          child: Icon(Icons.rocket),
        ) : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      ),
    );

  }

  buildBodyWidget(BuildContext context) {
    return TabBarView(
      controller: _tabController,
      children: [
      _buildRecipesContent(context),
      _buildRecipesContent(context),
      _buildFavoriteContent(context),
    ],);
  }

  buildSliverAppBar(UserProvider userProvider) {
    return SliverAppBar(
              backgroundColor: Color.fromRGBO(244,164,96, 1),
              pinned: true,
              expandedHeight: 230,
              toolbarHeight: 30,
              scrolledUnderElevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 190, top: 30),
                expandedTitleScale: 2,
                title:GestureDetector(
                  onTap: () {
                    // 在此处执行点击标题后的逻辑操作
                    // 示例：打印一条消息
                    _scrollController.jumpTo(0);
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(userProvider.avatar),
                      ),
                    ],
                  ),
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
                          return userProvider.isLoggedIn
                              ? _buildLoggedInProfileSection(userProvider,context)
                              : _buildNotLoggedInProfileSection(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            bottom: TabBar(controller: _tabController, tabs: const [
              Tab(text: '收藏菜谱',),
              Tab(text: '发布菜谱'),
              Tab(text: '发布帖子'),
      ],        labelColor: Colors.black, // 设置选中标签的文本颜色为白色
                unselectedLabelColor: Colors.black,
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ]
    );
  }


}





Widget _buildLoggedInProfileSection(UserProvider userProvider,BuildContext context) {
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
                  Text(
                    userProvider.description,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ), // 替换为用户描述
                ],
              ),
            ],
          ),

          SizedBox(height: 8),
          Row(
            children: [
              SizedBox(width: 30),
              Column(
                children: [
                  Text(userProvider.postNum.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('发布数', style: TextStyle(fontSize: 12)),
                ],
              ),
              SizedBox(width: 160),
              ElevatedButton(
                onPressed: () {
                  //userProvider.logout();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ModifyPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange, // 按钮背景色
                  onPrimary: Colors.white, // 文字颜色
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // 圆角大小
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // 按钮内边距
                ),
                child: Text('编辑信息'),
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
      return UserInfoList();

  }

Widget _buildRecipesContent(BuildContext context) {
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
  return UserRecipesList();

}

class UserInfoList extends StatefulWidget {
  const UserInfoList({super.key});

  @override
  State<UserInfoList> createState() => _UserInfoListState();
}

class _UserInfoListState extends State<UserInfoList> with AutomaticKeepAliveClientMixin{

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // return Column(
    //   children: List.generate(20, (index) {
    //     return ListTile(
    //       title: Text('收藏项 $index'),
    //     );
    //   }),);
    return const PostsWaterfall<CommunityPostsProvider>();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


class UserRecipesList extends StatefulWidget {
  const UserRecipesList({super.key});

  @override
  State<UserRecipesList> createState() => _UserRecipesListState();
}

class _UserRecipesListState extends State<UserRecipesList> with AutomaticKeepAliveClientMixin{

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const RecipesList<UserRecipeProvider>(
      emptyMessage: '抱歉',
      enableRefresh: false,
      private: false,
    );
    //return const PostsWaterfall<CommunityPostsProvider>();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
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