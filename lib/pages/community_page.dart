import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/models/community_posts.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../models/post.dart';
import '../widgets/community_card.dart';
import '../widgets/my_search_bar.dart';

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
        // HomeSearchBar(),
        AppBar(
          title: const MySearchBar(),
        ),
        Expanded(
          child: Consumer<CommunityPostsModel>(
            builder: (context, posts, child) => WaterfallFlow.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (BuildContext context, int index) {
                if(index == posts.length - 1){
                  posts.getMorePosts();
                }
                return CommunityCard(
                    thumbnailUrl: posts.itemAt(index).thumbnailUrl,
                    author: posts.itemAt(index).author,
                    title: posts.itemAt(index).title,
                    avatarUrl: posts.itemAt(index).avatarUrl
                );
              },
              itemCount: posts.length,
            ),
          )
        ),
      ],
    );
  }
}