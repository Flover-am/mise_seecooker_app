import 'package:flutter/material.dart';
import 'package:seecooker/widgets/community_waterfall.dart';
import 'package:seecooker/widgets/my_search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  var text = 'home';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // HomeSearchBar(),
        AppBar(
          title: MySearchBar(),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: const CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
              ),
            ),
          ],
        ),
        TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: '收藏'),
            Tab(text: '推荐'),
            Tab(text: '社区'),
          ],
        ),
        Expanded(
          child: TabBarView (
            controller: _tabController,
            children: const [
              Text('收藏'),
              Text('推荐'),
              CommunityWaterfall(),
            ],
          ),
        ),
      ],
    );
  }
}
