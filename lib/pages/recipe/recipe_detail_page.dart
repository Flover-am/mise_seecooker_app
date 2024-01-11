import 'dart:developer';

import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/models/recipe_detail.dart';
import 'package:seecooker/providers/recipe_detail_provider.dart';
import 'package:seecooker/widgets/author_info_bar.dart';
import 'package:skeletons/skeletons.dart';

class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage({super.key, required this.id});

  final int id;

  @override
  State<StatefulWidget> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  SwiperController swiperController = SwiperController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecipeDetailProvider(widget.id),
      builder: (context, child) {
        Future future = Provider.of<RecipeDetailProvider>(context, listen: false).fetchRecipeDetail();

        return FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                // TODO: refresh
                child: CircularProgressIndicator(),
              );
            }
            else if (snapshot.hasError){
              // TODO: error
              log("${snapshot.error}");
              log("${snapshot.stackTrace}");
              return Text('1');
            } else {
              return Consumer<RecipeDetailProvider>(
                builder: (context, provider, child) {
                  RecipeDetail model = provider.model;

                  for(var url in model.stepImages) {
                    precacheImage(ExtendedNetworkImageProvider(url), context);
                  }

                  return Scaffold(
                    appBar: AppBar(
                      title: AuthorInfoBar(
                        authorAvatar: model.authorAvatar,
                        authorName: model.authorName,
                      )
                    ),
                    body: GestureDetector(
                      onTapDown: (details) {
                        var x = details.globalPosition.dx; // 获取点击的全局x坐标
                        var screenWidth = MediaQuery.of(context).size.width; // 获取屏幕的宽度
                        if (x < screenWidth / 3) {
                          swiperController.previous();
                        } else if (x > screenWidth * 2 / 3) {
                          swiperController.next();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12)),
                        child: Swiper(
                          controller: swiperController,
                          scrollDirection: Axis.horizontal,
                          itemCount: model.stepContents.length + 1,
                          loop: false,
                          itemBuilder: (BuildContext context, int index) {
                            index = index - 1;
                            if (index == -1) {
                              return ListView(
                                padding: const EdgeInsets.all(16),
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: ExtendedImage.network(
                                      model.cover,
                                      fit: BoxFit.fitWidth,
                                      cache: true,
                                      enableLoadState: false,
                                    )
                                  ),
                                  RecipeHead(
                                    title: model.name,
                                    introduction: model.introduction
                                  ),
                                  model.ingredients != null
                                  ? Ingredients(ingredients: model.ingredients!)
                                  : Container()
                                ],
                              );
                            }
                            return Container(
                              margin: const EdgeInsets.all(16),
                              child: ListView(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: ExtendedImage.network(
                                      model.stepImages[index],
                                      fit: BoxFit.fitWidth,
                                      cache: true,
                                      enableLoadState: true,
                                        loadStateChanged: (ExtendedImageState state) {
                                          if (state.extendedImageLoadState case LoadState.loading) {
                                            return SkeletonLine(
                                              style: SkeletonLineStyle(
                                                  height: (MediaQuery.of(context).size.width - 48) /4 * 3,
                                                  borderRadius: BorderRadius.circular(12)
                                              ),
                                            );
                                          } else {
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
                                                child: ExtendedRawImage(
                                                  image: state.extendedImageInfo?.image,
                                                  fit: BoxFit.cover,
                                                )
                                            );
                                          }
                                        }
                                    ),
                                  ),
                                  StepContentSection(
                                    content: model.stepContents[index],
                                    index: index,
                                    allLength: model.stepContents.length,
                                  ),
                                ],
                              )
                            );
                          },
                        ),
                      ),
                    ),
                    bottomNavigationBar: RecipeBar(),
                  );
                },
              );
            }
          }
        );
      },
    );
  }
}

/// 简介文本内容
class RecipeHead extends StatelessWidget {
  const RecipeHead(
      {super.key, required this.introduction, required this.title});

  final String introduction;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 16, 12, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(introduction, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

/// 食材展示组件
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

/// 食谱步骤文本内容
class StepContentSection extends StatelessWidget {
  final String content;
  final int index;
  final int allLength;

  const StepContentSection({
    super.key,
    required this.content,
    required this.index,
    required this.allLength
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "第 ${index + 1}/$allLength 步",
            style: Theme.of(context).textTheme.labelLarge
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          child: Text(content, style: Theme.of(context).textTheme.titleMedium),
        )
      ],
    );
  }
}

/// 底部工具栏
class RecipeBar extends StatelessWidget {

  RecipeBar({super.key});

  final ValueNotifier<bool> _favorite = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<RecipeDetailProvider>(context, listen: false);
    var model = provider.model;
    _favorite.value = model.favorite;

    return SizedBox(
      height: 80,
      child: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IgnorePointer(
                  ignoring: model.scored,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        iconSize: 32,
                        visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity),
                        onPressed: () {
                          provider.changeScore(index + 1);
                        },
                        icon: index >= provider.newScore
                          ? const Icon(Icons.star_border_rounded, color: Colors.yellow)
                          : const Icon(Icons.star_rounded, color: Colors.yellow),
                        // icon: Icon(
                        //   index >= provider.newScore
                        //     ? Icons.star_border_rounded
                        //     : Icons.star_rounded
                        // )
                      );
                    }),
                  ),
                ),
                (!model.scored)
                  ? IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onPressed: () {
                        _showBottomSheet(context);
                        try {
                          provider.scoreRecipe();
                          Fluttertoast.showToast(msg: "评分成功");
                        } catch(e) {
                          Fluttertoast.showToast(msg: "$e");
                        }
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(0),
                        height: 35,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(child: Text('评价')),
                      )
                    )
                  : Text("${model.averageScore}")
              ],
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                bool res = false;
                try {
                  res = await provider.favorRecipe();
                  if(res == true) {
                    Fluttertoast.showToast(msg: '收藏成功');
                  } else {
                    Fluttertoast.showToast(msg: '取消收藏成功');
                  }
                } catch(e) {
                  log("$e");
                  Fluttertoast.showToast(msg: '请登录');
                }
                _favorite.value = res;
              },
              icon: ValueListenableBuilder<bool>(
                valueListenable: _favorite,
                builder: (context, value, child) {
                  if(value) {
                    return Icon(Icons.favorite_rounded, color: Theme.of(context).colorScheme.primary);
                  } else {
                    return Icon(Icons.favorite_outline_rounded);
                  }
                }
              )
            )
          ],
        ),
      ),
  );
  }

  void _showBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      elevation: 0,
      showDragHandle: true,
      builder: (BuildContext context) {
        return Consumer<RecipeDetailProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    iconSize: 32,
                    visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity),
                    onPressed: () {
                      provider.changeScore(index + 1);
                    },
                    icon: index >= provider.newScore
                      ? const Icon(Icons.star_border_rounded, color: Colors.yellow)
                      : const Icon(Icons.star_rounded, color: Colors.yellow),
                  );
                }
              ),
            ),
          );
          },
        );
      },
    );
  }
}
