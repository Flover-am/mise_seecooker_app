import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/providers/recipe_detail_provider.dart';
import 'package:seecooker/widgets/author_info_bar.dart';
import 'package:seecooker/widgets/recipe_bar.dart';

class RecipeDetail extends StatefulWidget {
  const RecipeDetail({super.key, required this.id});

  final int id;

  @override
  State<StatefulWidget> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  SwiperController swiperController = SwiperController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecipeDetailProvider(),
      builder: (context, child) {
        var init = Provider.of<RecipeDetailProvider>(context, listen: false)
            .fetchRecipeDetail(widget.id);
        return FutureBuilder(
            future: init,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Consumer<RecipeDetailProvider>(
                  builder: (BuildContext context, RecipeDetailProvider value,
                      Widget? child) {
                    var model = value.model;
                    return Scaffold(
                      appBar: AppBar(
                        title: !snapshot.hasError
                            ? AuthorInfoBar(
                                authorAvatar: model.authorAvatar,
                                authorName: model.authorName,
                              )
                            : Container(),
                      ),

                      /// BODY
                      body: !snapshot.hasError
                          ? GestureDetector(
                              onTapDown: (details) {
                                var x = details.globalPosition.dx; // 获取点击的全局x坐标
                                var screenWidth = MediaQuery.of(context)
                                    .size
                                    .width; // 获取屏幕的宽度
                                if (x < screenWidth / 3) {
                                  swiperController.previous();
                                } else if (x > screenWidth * 2 / 3) {
                                  swiperController.next();
                                }
                              },
                              child: Container(
                                  child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Swiper(
                                  controller: swiperController,
                                  // viewportFraction: 0.8,
                                  scale: 0.8,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: model.stepContents.length + 1,
                                  loop: false,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    index = index - 1;
                                    if (index == -1) {
                                      return ListView(
                                        children: [
                                          ClipRRect(
                                              child: Image.network(model.cover,
                                                  fit: BoxFit.fitWidth)),
                                          RecipeHead(title: model.name,
                                              introduction: model.introduction),
                                          Ingredients(
                                            ingredients: model.ingredients,
                                          )
                                        ],
                                      );
                                    }
                                    return Container(
                                        margin: const EdgeInsets.all(15),
                                        child: ListView(
                                          children: [
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Image.network(
                                                    model.stepImages[index],
                                                    fit: BoxFit.fitWidth)),
                                            StepContentSection(
                                              content:
                                                  model.stepContents[index],
                                              index: index,
                                              allLength:
                                                  model.stepContents.length,
                                            )
                                          ],
                                        ));
                                  },
                                ),
                              )))
                          : Text("Error:${snapshot.error}",
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 20)),

                      /// BAR
                      bottomNavigationBar: !snapshot.hasError
                          ? const RecipeBar()
                          : const Text(""),
                    );
                  },
                );
              }
            });
      },
    );
  }
}

/// 简介文本块
class RecipeHead extends StatelessWidget {
  const RecipeHead(
      {super.key, required this.introduction, required this.title});

  final String introduction;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style: const TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold
          ),),
          Text("  $introduction"),
        ],
      ),
    );
  }
}

///
class Ingredients extends StatelessWidget {
  const Ingredients({super.key, required this.ingredients});

  final List<Map<String, String>> ingredients;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Text(
            "用料",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
                color: Theme.of(context).textTheme.titleLarge?.color),
          ),
        ),
        Column(
          children: List.generate(ingredients.length, (index) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(ingredients[index]["name"]!),
                      Text(ingredients[index]["amount"]!)
                    ],
                  ),
                ),
                Divider(
                  color: Theme.of(context).colorScheme.primary.withAlpha(10),
                  // 线的颜色
                  thickness: 1.5,
                  // 线的厚度
                  height: 20,
                  indent: 10,
                  endIndent: 10,
                )
              ],
            );
          }),
        )
      ],
    );
  }
}

class StepContentSection extends StatelessWidget {
  const StepContentSection(
      {super.key,
      required this.content,
      required this.index,
      required this.allLength});

  final String content;
  final int index;
  final int allLength;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(15, 15, 20, 5),
          child: Text("第 ${index + 1}/$allLength 步",
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        )
      ],
    );
  }
}
