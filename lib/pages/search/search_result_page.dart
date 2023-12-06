import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/pages/search/search_page.dart';
import 'package:seecooker/providers/search/search_result_provider.dart';
import 'package:seecooker/widgets/recipe_list_item.dart';
import 'package:skeletons/skeletons.dart';

class SearchResultPage extends StatelessWidget {
  final String query;
  final _textEditingController = TextEditingController();

  SearchResultPage({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = query;

    return Provider(
      create: (BuildContext context) => SearchResultProvider(),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            scrolledUnderElevation: 0,
            title: TextField(
              onTap: () => goToSearch(context, query),
              cursorRadius: const Radius.circular(2),
              controller: _textEditingController,
              maxLength: 100,
              decoration: InputDecoration(
                hintText: '搜索食谱',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                counterText: '',
              ),
            ),
            actions: [
              const SizedBox(width: 4),
              IconButton(
                onPressed: () => goToSearch(context, query),
                icon: const Icon(Icons.search)
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: FutureBuilder(
            future: Provider.of<SearchResultProvider>(context).fetchSearchResult(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting){
                return Center(child: _buildSkeleton());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return Consumer<SearchResultProvider>(
                  builder: (context, provider, child) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return RecipeListItem(
                          recipeId: provider.itemAt(index).recipeId,
                          name: provider.itemAt(index).name,
                          cover: provider.itemAt(index).cover
                        );
                      },
                      itemCount: provider.length,
                    );
                  }
                );
              }
            }
          ),
        );
      }
    );
  }

  Widget _buildSkeleton() {
    return Column(
      children: [
        Container(
          height: 144,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(
                  width: 153.6,
                  height: 126,
                  borderRadius: BorderRadius.circular(12)
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  SkeletonLine(style: SkeletonLineStyle(width: 96, height: 24)),
                  const SizedBox(height: 8),
                  SkeletonLine(style: SkeletonLineStyle(width: 48, height: 20)),
                  const SizedBox(height: 8),
                  SkeletonLine(style: SkeletonLineStyle(width: 128, height: 24)),
                  const Spacer(),
                  SizedBox(
                    width: 128,
                    child: SkeletonListTile(
                      padding: EdgeInsets.zero,
                      leadingStyle: SkeletonAvatarStyle(
                          height: 24,
                          width: 24,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      titleStyle: const SkeletonLineStyle(
                        height: 20,
                        width: 72,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  void goToSearch(BuildContext context, String query) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SearchPage(query: query)),
    );
  }
}