import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/pages/search/search_page.dart';
import 'package:seecooker/providers/community_posts_provider.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:seecooker/widgets/post_card.dart';
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
        //centerTitle: true,
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
            MaterialPageRoute(builder: (context) => const PublishPage(param: "",)),
          ),
        },
        child: const Icon(Icons.edit),
      ),
      body: FutureBuilder(
        future: Provider.of<CommunityPostsProvider>(context, listen: false).fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: _buildSkeleton(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return RefreshIndicator(
              onRefresh: Provider.of<CommunityPostsProvider>(context, listen: false).fetchPosts,
              child: const PostWaterfall()
            );
          }
        }
      ),
    );
  }

  Widget _buildSkeleton() {
    return WaterfallFlow.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        return const PostCardSkeleton();
      },
      itemCount: 4,
    );
  }
}

class PostWaterfall extends StatelessWidget {
  const PostWaterfall({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityPostsProvider>(
      builder: (context, provider, child) {
        return WaterfallFlow.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            if (index == provider.length - 1) {
              provider.fetchMorePosts();
            }

            precacheImage(ExtendedNetworkImageProvider(provider.itemAt(index).cover), context);

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
              child: PostCard(
                postId: provider.itemAt(index).postId,
                cover: provider.itemAt(index).cover,
                posterName: provider.itemAt(index).posterName,
                title: provider.itemAt(index).title,
                posterAvatar: provider.itemAt(index).posterAvatar
              ),
            );
          },
          itemCount: provider.length,
        );
      }
    );
  }
}