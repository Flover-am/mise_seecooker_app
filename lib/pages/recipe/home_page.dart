import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/pages/recipe/recipe_detail.dart';
import 'package:seecooker/providers/home_recipes_provider.dart';
import 'package:seecooker/widgets/recipe_card.dart';
import 'package:skeletons/skeletons.dart';
import 'package:seecooker/pages/search/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 140,
          scrolledUnderElevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            expandedTitleScale: 1.2,
            title: Text('食谱推荐', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
            background: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 16),
                  Text('亲爱的 用户名 ，', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('欢迎使用 seecooker ( \'◡\' )', style: Theme.of(context).textTheme.titleMedium),
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
              if (index == provider.length - 1) {
                provider.fetchMoreRecipes();
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
                child: GestureDetector(
                  child: RecipeCard(
                    recipeId: provider.itemAt(index).recipeId,
                    name: provider.itemAt(index).name,
                    cover: provider.itemAt(index).cover,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RecipeDetail(id: index)));
                  },
                ),
              );
            },
            childCount: provider.length,
          )
        );
      }
    );
  }
}
