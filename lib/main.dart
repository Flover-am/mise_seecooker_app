import 'dart:io';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/pages/account/account_page.dart';
import 'package:seecooker/pages/explore/explore_page.dart';
import 'package:seecooker/pages/recipe/home_page.dart';
import 'package:seecooker/pages/community/community_page.dart';
import 'package:seecooker/pages/account/login_page.dart';
import 'package:seecooker/pages/publish/publish_recipe.dart';
import 'package:flutter/material.dart';
import 'package:seecooker/providers/community_posts_provider.dart';
import 'package:seecooker/providers/explore_post_provider.dart';
import 'package:seecooker/providers/user_provider.dart';
import 'package:seecooker/providers/recommend_provider.dart';
import 'package:seecooker/providers/home_recipes_provider.dart';
import 'package:seecooker/utils/color_schemes.dart';

import 'models/user.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExplorePostProvider()),
        ChangeNotifierProvider(create: (context) => CommunityPostsProvider()),
        ChangeNotifierProvider(create: (context) => HomeRecipesProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => RecommendProvider())
      ],
      child: const MyApp()
    )
  );
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black.withOpacity(0.002),
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'seecooker',
      theme: ThemeData(
        colorScheme: customLightColorScheme,
        useMaterial3: true,
        //visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity)
      ),
      darkTheme: ThemeData(
        colorScheme: customDarkColorScheme,
        useMaterial3: true,
        //visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity)
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with AutomaticKeepAliveClientMixin {
  int _currentPageIndex = 0;

  final List<Widget> _body = [
    const HomePage(),
    const ExplorePage(),
    const CommunityPage(),
    const AccountPage(),
  ];

  @override
  bool get wantKeepAlive => true; // keep page alive

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: IndexedStack(
        index: _currentPageIndex,
        children: _body,
      ),
      floatingActionButton: _currentPageIndex == 2
        ? FloatingActionButton(
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PostPage(param: '111',)),
            ),
          },
          child: const Icon(Icons.edit),
        )
        : null,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        //labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: _currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: '首页',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.explore),
            icon: Icon(Icons.explore_outlined),
            label: '发现',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.camera),
            icon: Icon(Icons.camera_outlined),
            label: '社区',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle),
            icon: Icon(Icons.account_circle_outlined),
            label: '我的',
          ),
        ],
      ),
    );
  }
}