import 'package:flutter/material.dart';
import 'package:seecooker/widgets/community_card.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var text = 'home';

  @override
  Widget build(BuildContext context) {
    return WaterfallFlow.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (BuildContext context, int index) {
        return index % 2 == 0
            ? const CommunityCard(
            coverUrl: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
            author: 'author',
            title: 'title',
            avatarUrl: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg')
            : const CommunityCard(
            coverUrl: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
            author: 'author',
            title: 'titletitletitletitletitletitletitletitletitletitle',
            avatarUrl: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg');
      },
      itemCount: 10,
    );
  }
}
