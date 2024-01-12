import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/models/user.dart';
import 'package:seecooker/pages/account/login_page.dart';
import 'package:seecooker/providers/recipe/user_favor_recipe_provider.dart';
import 'package:seecooker/providers/user/user_provider.dart';
import 'package:seecooker/providers/recipe/user_recipe_provider.dart';
import 'package:seecooker/utils/shared_preferences_util.dart';
import 'package:seecooker/widgets/posts_waterfall.dart';
import 'package:skeletons/skeletons.dart';

import '../../providers/recipe/other_user_favor_recipe_provider.dart';
import '../../providers/post/other_user_posts_provider.dart';
import '../../providers/user/other_user_provider.dart';
import '../../providers/recipe/other_user_recipe_provider.dart';
import '../../providers/recipe/home_recipes_provider.dart';
import '../../providers/post/community_posts_provider.dart';
import '../../providers/recipe/search_recipes_provider.dart';
import '../../providers/post/user_posts_provider.dart';
import '../../widgets/recipe_card.dart';
import '../../widgets/recipes_list.dart';
import 'package:tabbed_sliverlist/tabbed_sliverlist.dart';

import 'modify/modify_page.dart';
import 'settings/settings_page.dart';
///其他用户界面
class OtherAccountPage extends StatefulWidget {
  const OtherAccountPage({super.key});

  @override
  State<OtherAccountPage> createState() => _OtherAccountPageState();
}

class _OtherAccountPageState extends State<OtherAccountPage> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  bool flag = false;
  final ScrollController _scrollController = ScrollController();
  bool isPinned = true;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _scrollController.addListener(() {
      setState(() {
        isPinned = _scrollController.offset > 0;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    OtherUserProvider otherUserProvider = Provider.of<OtherUserProvider>(context);
    int id = otherUserProvider.id;
    print("id: " + id.toString());
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<OtherUserRecipeProvider>(
          create: (_) => OtherUserRecipeProvider(id),
        ),
        ChangeNotifierProvider<OtherUserFavorRecipesProvider>(
          create: (_) => OtherUserFavorRecipesProvider(id),
        ),
        ChangeNotifierProvider<OtherUserPostsProvider>(
          create: (_) => OtherUserPostsProvider(id),
        ),
      ],
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          body: buildBodyWidget(context),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              buildSliverAppBar(otherUserProvider),
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
      _buildFavorRecipesContent(context),
      _buildRecipesContent(context),
      _buildPostContent(context),
    ],);
  }

  buildSliverAppBar(OtherUserProvider otherUserProvider) {
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
                        backgroundImage: NetworkImage(otherUserProvider.avatar),
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
                      _buildProfileSection(otherUserProvider,context)
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

        ]
    );
  }


}

///构建其他用户界面
Widget _buildProfileSection(OtherUserProvider otherUserProvider,BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 42,
                backgroundImage: NetworkImage(otherUserProvider.avatar),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherUserProvider.username,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    otherUserProvider.signature,
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
                  Text(otherUserProvider.postNum.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('发布数', style: TextStyle(fontSize: 12)),
                ],
              ),
              SizedBox(width: 160),

            ],
          ),
        ],
      ),
    );
  }

///构建其他用户发布帖子列表
Widget _buildPostContent(BuildContext context) {

      return UserPostList();

  }
///构建其他用户发布菜谱列表
Widget _buildRecipesContent(BuildContext context) {
  return UserRecipesList();

}
///构建其他用户收藏列表
Widget _buildFavorRecipesContent(BuildContext context) {
  return UserFavorRecipesList();

}

class UserPostList extends StatefulWidget {
  const UserPostList({super.key});

  @override
  State<UserPostList> createState() => _UserPostListState();
}

class _UserPostListState extends State<UserPostList> with AutomaticKeepAliveClientMixin{

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return const PostsWaterfall<OtherUserPostsProvider>();
  }

  @override
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
    return const RecipesList<OtherUserRecipeProvider>(
      emptyMessage: '暂无菜谱',
      enableRefresh: false,
      private: false,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class UserFavorRecipesList extends StatefulWidget {
  const UserFavorRecipesList({super.key});

  @override
  State<UserFavorRecipesList> createState() => _UserFavorRecipesListState();
}

class _UserFavorRecipesListState extends State<UserFavorRecipesList> with AutomaticKeepAliveClientMixin{

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const RecipesList<OtherUserFavorRecipesProvider>(
      emptyMessage: '暂无菜谱',
      enableRefresh: false,
      private: false,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
