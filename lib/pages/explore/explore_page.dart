import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/pages/explore/makeexp_page.dart';
import 'package:seecooker/providers/explore_post_provider.dart';
import 'package:seecooker/widgets/chosen_line.dart';
import 'package:seecooker/widgets/my_search_bar.dart';
import 'package:seecooker/models/Category.dart';
import 'package:seecooker/utils/categoryies.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class CategoryItem extends StatelessWidget {
  final Category category;
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
                  category.name,
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                   Text(
                    category.tagline,
                    style: TextStyle(color: Colors.grey),
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
              SizedBox(
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
              )),
              SizedBox(
                height: 20,
              )
            ],
          ));
    },
    isScrollControlled: true,
    showDragHandle: true,
  );
}

class _ExplorePageState extends State<ExplorePage> {
  void _showCategoryIngredientsDialog(
      BuildContext context, String name, List<String> ingredients) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Container(
                  child: ChosenLine(
                    dishesFilter: ingredients,
                    title: "挑选$name",
                  ),
                  height: MediaQuery.of(context).size.height / 3),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('关闭'),
                ),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
          margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
          child: ListView(
            children: [
              MySearchBar(),
              SizedBox(height: 10),
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
                            categories[index].name,
                            categories[index].ingredients);
                      },
                    );
                  },
                ),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.shopping_bag),
          heroTag: UniqueKey(),
          onPressed: () => showCommentSection(context, false)),
    );
  }
}
