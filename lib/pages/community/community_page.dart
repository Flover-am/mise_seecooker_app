import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/pages/search/search_page.dart';
import 'package:seecooker/providers/community_posts_provider.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../../widgets/community_card.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
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
        Expanded(
          child: FutureBuilder(
            future: Provider.of<CommunityPostsProvider>(context, listen: false).fetchPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  // TODO: build skeleton
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return const CommunityWaterfall();
              }
            }
          )
        ),
      ],
    );
  }
}

class CommunityWaterfall extends StatelessWidget {
  const CommunityWaterfall({super.key});

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
              child: CommunityCard(
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