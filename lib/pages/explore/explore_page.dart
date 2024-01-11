/// 发现界面的第一界面，用户在此挑选配料生成推荐菜品
/// feat by： xhzai
/// time： 2024/1/11
///
///
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/models/Ingredients.dart';
import 'package:seecooker/pages/explore/makeexp_page.dart';
import 'package:seecooker/providers/explore/Ingredients_provider.dart';
import 'package:seecooker/providers/explore/explore_post_provider.dart';
import 'package:seecooker/widgets/chosen_line.dart';
import 'package:seecooker/widgets/my_search_bar.dart';
import 'package:skeletons/skeletons.dart';


class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}


///食材分类的条形框，点击加号Button展开对应具体食材

class CategoryItem extends StatelessWidget {
  final Ingredients category;
  final VoidCallback onPressed;

  CategoryItem({required this.category, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
                  category.category,
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ],),
                SizedBox(width: MediaQuery.of(context).size.width/5,height: MediaQuery.of(context).size.height/16,child:  ElevatedButton(
                  onPressed: onPressed,
                  child: Icon(Icons.add),
                ),)
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
                width: MediaQuery.of(context).size.width / 2,
                height: 45,
                child: FloatingActionButton(
                    child: const Text("生 成 菜 谱",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                    onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MakeExpPage()),
                          ),
                        }),
              )
              ),
              const SizedBox(
                height: 20,
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
            body: Container(
                margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: ListView(
                  children: [
                    MySearchBar(categories: categories),
                    const SizedBox(height: 10),
                    Container(
                      height: MediaQuery.of(context).size.height /
                          1.4, // Set a fixed or maximum height
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CategoryItem(
                            category: categories[index],
                            onPressed: () {
                              _showCategoryIngredientsDialog(
                                  context,
                                 categories[index].category,
                                  categories[index].name);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                )
            ),
            floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.shopping_bag),
                onPressed: () => showCommentSection(context, false)),
          );
        }
      },
    );
  }
}
