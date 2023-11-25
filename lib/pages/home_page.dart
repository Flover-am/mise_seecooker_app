import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/providers/home_recipes_provider.dart';
import 'package:seecooker/widgets/recipe_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<HomeRecipesProvider>(context, listen: false).fetchRecipes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return const RecipeList();
        }
      },
    );
  }
}

class RecipeList extends StatelessWidget {
  const RecipeList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeRecipesProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
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
              child: RecipeCard(
                id: index,
                title: provider.itemAt(index).title,
                coverUrl: provider.itemAt(index).coverUrl,
                author: provider.itemAt(index).author,
                like: provider.itemAt(index).like,
                rate: provider.itemAt(index).rate,
              ),
            );
          },
          itemCount: provider.length,
        );
      }
    );
  }
}
