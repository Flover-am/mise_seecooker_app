import 'dart:developer';

import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/models/recipe_detail.dart';
import 'package:seecooker/pages/account/other_account_page.dart';
import 'package:seecooker/providers/user/other_user_provider.dart';
import 'package:seecooker/providers/recipe_detail_provider.dart';
import 'package:seecooker/widgets/refresh_place_holder.dart';
import 'package:skeletons/skeletons.dart';

class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage({super.key, required this.id});

  final int id;

  @override
  State<StatefulWidget> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  SwiperController _swiperController = SwiperController();

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
              return _buildSkeleton();
            }
            else if (snapshot.hasError){
              log("${snapshot.error}");
              return Scaffold(
                body: RefreshPlaceholder(
                  message: "悲报！食谱在网络中迷路了",
                  onRefresh: () {
                    setState(() {
                      future = Provider.of<RecipeDetailProvider>(context, listen: false).fetchRecipeDetail();
                    });
                  },
                ),
              );
            } else {
              return Consumer<RecipeDetailProvider>(
                builder: (context, provider, child) {
                  RecipeDetail model = provider.model;

                  for(var url in model.stepImages) {
                    precacheImage(ExtendedNetworkImageProvider(url), context);
                  }

                  return Scaffold(
                    appBar: AppBar(
                      scrolledUnderElevation: 0,
                      title: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              OtherUserProvider otherUserProvider = Provider.of<OtherUserProvider>(context,listen: false);
                              await otherUserProvider.getUserById(model.authorId);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => OtherAccountPage()),
                              );
                            },
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.transparent,
                              backgroundImage: ExtendedNetworkImageProvider(
                                model.authorAvatar,
                                cache: true,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              model.authorName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      )
                    ),
                    body: GestureDetector(
                      onTapDown: (details) {
                        var x = details.globalPosition.dx; // 获取点击的全局x坐标
                        var screenWidth = MediaQuery.of(context).size.width; // 获取屏幕的宽度
                        if (x < screenWidth / 3) {
                          _swiperController.previous();
                        } else if (x > screenWidth * 2 / 3) {
                          _swiperController.next();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12)),
                        child: Swiper(
                          controller: _swiperController,
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
                    bottomNavigationBar: RecipeBar(
                      onBack: () {
                        _swiperController.move(0);
                      },
                    ),
                  );
                },
              );
            }
          }
        );
      },
    );
  }

  Widget _buildSkeleton(){
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SkeletonLine(
            style: SkeletonLineStyle(
              height: 256,
              padding: EdgeInsets.all(16),
              borderRadius: BorderRadius.circular(12)
            ),
          ),
          const SkeletonLine(
            style: SkeletonLineStyle(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              height: 32
            ),
          )
        ],
      ),
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
          const SizedBox(height: 8),
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

  final void Function() onBack;

  RecipeBar({super.key, required this.onBack});

  final ValueNotifier<bool> _favorite = ValueNotifier(false);

  final ValueNotifier<int> _score = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<RecipeDetailProvider>(context, listen: false);
    var model = provider.model;
    _favorite.value = model.favorite;

    return SizedBox(
      height: 80,
      child: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                if(model.scored){
                  Fluttertoast.showToast(msg: "只允许评分一次");
                } else {
                  _showBottomSheet(context);
                }
              },
              icon: model.scored
                ? const Icon(Icons.star_rounded, color: Colors.yellow, size: 28)
                : const Icon(Icons.star_border_rounded, color: Colors.yellow, size: 28)
            ),
            Text("${model.averageScore}分", style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(width: 12),
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
                    return const Icon(Icons.favorite_outline_rounded);
                  }
                }
              )
            ),
            const Spacer(),
            IconButton(
              onPressed: onBack,
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.keyboard_double_arrow_left_rounded, size: 28)
            )
          ],
        ),
      ),
  );
  }

  void _showBottomSheet(BuildContext ctx) {
    RecipeDetailProvider provider = Provider.of<RecipeDetailProvider>(ctx, listen: false);

    showModalBottomSheet(
      context: ctx,
      elevation: 0,
      showDragHandle: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(64, 0, 64, 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('留下你的评分吧~', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.outline)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(5, (index) {
                  return ValueListenableBuilder<int>(
                    valueListenable: _score,
                    builder: (context, value, child) {
                      return IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        iconSize: 36,
                        visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity),
                        onPressed: () {
                          _score.value = index + 1;
                        },
                        icon: index >= value
                            ? const Icon(Icons.star_border_rounded, color: Colors.yellow)
                            : const Icon(Icons.star_rounded, color: Colors.yellow),
                      );
                    },
                  );
                }
              ),
        ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text("取消", style: TextStyle(color: Theme.of(context).colorScheme.outline))
                  ),
                  TextButton(
                    onPressed: () async {
                      if(_score.value == 0) {
                        Fluttertoast.showToast(msg: "评分至少一分");
                      } else {
                        try {
                          await provider.scoreRecipe(_score.value);
                          Navigator.pop(context);
                          Fluttertoast.showToast(msg: "评分成功");
                        } catch(e) {
                          log("$e");
                          if(e.toString() == "Exception: 请登录"){
                            Fluttertoast.showToast(msg: "请登录");
                          } else {
                            Fluttertoast.showToast(msg: "$e");
                          }
                        }
                      }
                    },
                    child: const Text("确认")
                  )
                ],
              )
            ],
          ),
          );
      },
    );
  }
}
