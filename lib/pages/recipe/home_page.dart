import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/pages/recipe/recipe_detail.dart';
import 'package:seecooker/providers/recipe/home_recipes_provider.dart';
import 'package:seecooker/providers/user_provider.dart';
import 'package:seecooker/widgets/recipe_card.dart';
import 'package:skeletons/skeletons.dart';
import 'package:seecooker/pages/search/search_page.dart';

import '../publish/publish_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: UniqueKey(),
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PublishPage(param: "",)),
          ),
        },
        child: const Icon(Icons.restaurant_menu_outlined),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 220,
            scrolledUnderElevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(bottom: 16),
              expandedTitleScale: 1,
              title: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text('食谱推荐', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
              ),
              background: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 2000),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: child,
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/wave-haikei.png',),
                    //SizedBox(height: MediaQuery.of(context).padding.top + 16),
                    Consumer<UserProvider>(
                      builder: (context, provider, child) {
                        if(provider.username != '未登录') {
                          return Text('   亲爱的 ${provider.username} ，', style: Theme.of(context).textTheme.titleMedium);
                        } else {
                          return Text('  你好，', style: Theme.of(context).textTheme.headlineMedium);
                        }
                      },
                    ),
                    // Provider.of<UserProvider>(context, listen: false).username != '未登录'
                    // ? Text('  亲爱的 ${Provider.of<UserProvider>(context, listen: false).username} ，', style: Theme.of(context).textTheme.titleMedium)
                    // : Text('  你好，', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 12),
                    Text.rich(
                      TextSpan(
                        style: Theme.of(context).textTheme.headlineMedium,
                        children: [
                          const TextSpan(text: '  欢迎使用 '),
                          TextSpan(text: 'seecooker', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                          const TextSpan(text: ' ( \'◡\' )'),
                        ]
                      )
                    ),
                    //Text('欢迎使用 seecooker ( \'◡\' )', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
            ),
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
            ]
          ),
          FutureBuilder(
            future: Provider.of<HomeRecipesProvider>(context, listen: false).fetchRecipes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: _buildSkeleton(context),
                );
              } else if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              } else {
                return const RecipeList();
              }
            },
          ),
        ]
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: MediaQuery.of(context).size.width - 48,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            borderRadius: BorderRadius.circular(12)
          ),
        ),
        const SizedBox(height: 24),
        SkeletonLine(
          style: SkeletonLineStyle(
              height: 368,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              borderRadius: BorderRadius.circular(12)
          ),
        ),
      ],
    );
  }
}

class RecipeList extends StatelessWidget {
  const RecipeList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeRecipesProvider>(
      builder: (context, provider, child) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              // if (index == provider.length - 1) {
              //   provider.fetchMoreRecipes();
              // }
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
                child: GestureDetector(
                  child: RecipeCard(
                    recipeId: provider.itemAt(index).id,
                    name: provider.itemAt(index).name,
                    cover: provider.itemAt(index).cover,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RecipeDetail(id: provider.itemAt(index).id)));
                  },
                ),
              );
            },
            childCount: provider.count,
          )
        );
      }
    );
  }
}
