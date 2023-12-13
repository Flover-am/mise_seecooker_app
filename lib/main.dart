import 'dart:io';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/pages/account/account_page.dart';
import 'package:seecooker/pages/explore/explore_page.dart';
import 'package:seecooker/pages/publish/publish_post.dart';
import 'package:seecooker/pages/recipe/home_page.dart';
import 'package:seecooker/pages/post/posts_page.dart';
import 'package:flutter/material.dart';
import 'package:seecooker/providers/community_posts_provider.dart';
import 'package:seecooker/providers/explore_post_provider.dart';
import 'package:seecooker/providers/user_provider.dart';
import 'package:seecooker/providers/recommend_provider.dart';
import 'package:seecooker/providers/home_recipes_provider.dart';
import 'package:seecooker/utils/color_schemes.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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
  //FlutterNativeSplash.remove();
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
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        useMaterial3: true,
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
    const PostsPage(),
    const HomePage(),
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
      bottomNavigationBar: NavigationBar(
        elevation: 0,
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        selectedIndex: _currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: Theme.of(context).colorScheme.surface),
            icon: Icon(Icons.home_outlined),
            label: '首页',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.explore, color: Theme.of(context).colorScheme.surface),
            icon: Icon(Icons.explore_outlined),
            label: '发现',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.camera, color: Theme.of(context).colorScheme.surface),
            icon: Icon(Icons.camera_outlined),
            label: '社区',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle, color: Theme.of(context).colorScheme.surface),
            icon: Icon(Icons.account_circle_outlined),
            label: '我的',
          ),
        ],
      ),
    );
  }
}