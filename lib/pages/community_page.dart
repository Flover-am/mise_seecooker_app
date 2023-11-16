import 'package:flutter/material.dart';

import '../widgets/community_waterfall.dart';
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
        const Expanded(
            child: CommunityWaterfall()
        ),
      ],
    );
  }
}