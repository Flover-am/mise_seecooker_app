import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/models/Ingredients.dart';
import 'package:seecooker/pages/explore/makeexp_page.dart';
import 'package:seecooker/providers/explore/ingredients_provider.dart';
import 'package:seecooker/providers/explore/explore_post_provider.dart';
import 'package:seecooker/providers/user/user_provider.dart';
import 'package:seecooker/widgets/chosen_line.dart';
import 'package:seecooker/widgets/my_search_bar.dart';
import 'package:skeletons/skeletons.dart';

/// 探索页面
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {

  /// 选择具体菜品弹窗
  void _showCategoryIngredientsDialog(
      BuildContext context, String name, List<String> ingredients) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: ChosenLine(
                    dishesFilter: ingredients,
                    title: "挑选$name",
                  )),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('关闭'),
                ),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    Future future = Provider.of<IngredientsProvider>(context,
        listen: false)
        .getIngredients();
    // futrueBuilder以获取服务端食材数据
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(margin: const EdgeInsets.fromLTRB(10, 120, 10, 0), child: _buildSkeleton(context));
        } else if (snapshot.hasError) {
          log('Error: ${snapshot.stackTrace}');
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final categories = Provider.of<IngredientsProvider>(context,
              listen: false).showlist();
          return Scaffold(
            appBar: AppBar(
              title: Text("挑选食材"),
            ),
            body: Container(
                color: Theme.of(context).colorScheme.background,
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ListView(
                  children: [
                    MySearchBar(categories: categories),
                    const SizedBox(height: 8),
                    Text("  共${categories.length}种",style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8))),
                    for(int index=0;index<categories.length;index++)
                      CategoryItem(
                        category: categories[index],
                        onPressed: () {
                          _showCategoryIngredientsDialog(context,
                              categories[index].category,
                              categories[index].name);
                        },),
                  ],
                )
            ),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.shopping_bag, color: Theme.of(context).colorScheme.surface),
                onPressed: () {
                  if(Provider.of<UserProvider>(context, listen: false).isLoggedIn == false){
                    Fluttertoast.showToast(msg: "请登录");
                  } else {
                    showCommentSection(context, false);
                  }
                }),
          );
        }
      },
    );
  }
}

///食材分类的条形框，点击加号Button展开对应具体食材
class CategoryItem extends StatelessWidget {
  final Ingredients category;
  final VoidCallback onPressed;

  const CategoryItem({super.key, required this.category, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12), // 圆角半径
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
                  category.category,
                  style: Theme.of(context).textTheme.titleMedium,

                ),Text(
                      "${category.name[0]} ${category.name[1]}……",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
                ],),
                TextButton(onPressed: onPressed, child: const Icon(Icons.add))

              ],
            ),
      ),
    );
  }
}

///展开已选择配料的悬浮窗口，由界面右下角悬浮按钮点击触发
void showCommentSection(BuildContext context, bool autofocus) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SizedBox(
          height: 320,
          child: Column(
            children: [
              Expanded(
                  flex: 5,
                  child: ChosenLine(
                      title: '您已挑选',
                      dishesFilter: Provider.of<ExplorePostProvider>(context,
                              listen: false)
                          .showlist())),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: SizedBox(
                width: MediaQuery.of(context).size.width/1.1 ,
                height: 45,
                child: FilledButton(
                  onPressed: () => {
                    if(Provider.of<ExplorePostProvider>(context,
                        listen: false).length>0){
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => const MakeExpPage()),
                       )}
                    else{
                    Fluttertoast.showToast(msg: '请至少选择一道食材')}
                  },
                  child: Text('生成菜谱', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.surface)),
                )
              )
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ));
    },
    isScrollControlled: true,
    showDragHandle: true,
  );
}

///加载框
Widget _buildSkeleton(BuildContext context) {
  return Column(
    children: [
      const SizedBox(height: 8),
      SkeletonLine(
        style: SkeletonLineStyle(
            height: MediaQuery.of(context).size.width ,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            borderRadius: BorderRadius.circular(12)
        ),
      ),
    ],
  );
}
