import 'package:flutter/material.dart';
import 'package:seecooker/pages/publish/publish_post_page.dart';
import 'package:seecooker/pages/search/search_page.dart';
import 'package:seecooker/providers/post/community_posts_provider.dart';
import 'package:seecooker/widgets/posts_waterfall.dart';
import 'package:seecooker/pages/publish/publish_page.dart';

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
      floatingActionButton: FloatingActionButton(
        heroTag: UniqueKey(),
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PublishPostPage(param: "")),
          ),
        },
        child: Icon(Icons.edit, color: Theme.of(context).colorScheme.surface),
      ),
      body: const PostsWaterfall<CommunityPostsProvider>(),
    );
  }
}