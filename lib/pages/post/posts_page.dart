import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/pages/publish/publish_post_page.dart';
import 'package:seecooker/pages/search/search_page.dart';
import 'package:seecooker/providers/post/community_posts_provider.dart';
import 'package:seecooker/providers/user/user_provider.dart';
import 'package:seecooker/widgets/posts_waterfall.dart';

/// 帖子列表页面
class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text('社区'),
        actions: [
          // 搜索按钮
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
        ],
      ),
      // 浮动按钮，跳转到帖子发布页
      floatingActionButton: FloatingActionButton(
        heroTag: UniqueKey(),
        onPressed: (){
          if(Provider.of<UserProvider>(context, listen: false).isLoggedIn == false){
            Fluttertoast.showToast(msg: "请登录");
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PublishPostPage(param: "")),
            );
          }
        },
        child: Icon(Icons.edit, color: Theme.of(context).colorScheme.surface),
      ),
      // 社区页帖子瀑布流
      body: const PostsWaterfall<CommunityPostsProvider>(),
    );
  }
}