/// 发现页面的第二页面，通过左右滑动切换、收藏推荐菜品的卡片
/// feat by： xhzai
/// time： 2024/1/11
///
///
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/pages/account/login_page.dart';
import 'package:seecooker/pages/recipe/recipe_detail_page.dart';
import 'package:seecooker/providers/explore/recommend_provider.dart';
import 'package:seecooker/utils/sa_token_util.dart';
import 'package:seecooker/widgets/refresh_place_holder.dart';
import 'package:seecooker/widgets/tinder_card.dart';

import 'package:seecooker/widgets/post_card.dart';
import 'package:tcard/tcard.dart';

import 'package:seecooker/providers/explore/explore_post_provider.dart';
import 'package:seecooker/widgets/exp_recipe_card.dart';
import 'package:seecooker/widgets/recipe_card.dart';

class MakeExpPage extends StatefulWidget {
  const MakeExpPage({super.key});

  @override
  State<MakeExpPage> createState() => _MakeExpPageState();
}

class _MakeExpPageState extends State<MakeExpPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("为您推荐"),
        ),
        body: FutureBuilder(
            future: Provider.of<RecommendProvider>(context, listen: false)
                .fetchRecommendRecipes(Provider.of<ExplorePostProvider>(context,
                listen: false).showlist()),
            builder: (context, snapshot) {
              if(Provider.of<RecommendProvider>(context, listen: false).length==0) {
                return const Center(
                  child: RefreshPlaceholder(
                    message: "抱歉，没有找到相关推荐",
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: RefreshPlaceholder(
                    message: "悲报！食谱在网络中迷路了",
                  ),
                );
              } else {
                return SwipeCard();
              }
            }
            )
    );
  }
}
class SwipeCard extends StatefulWidget{
  @override
  State<SwipeCard> createState() {
    return SwipeCardState();
  }
}
class SwipeCardState extends State<SwipeCard>{
  //获取卡面状态(开始向左、右滑)以实现和底部收藏、跳过ICON的交互
  bool being_right = false;
  bool being_left = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<RecommendProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Text("左滑跳过，右滑收藏", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8))),
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    //滑动卡面组件,实现类似探探的功能
                    TinderSwapCard(
                      swipeUp: false,
                      swipeDown: false,
                      orientation: AmassOrientation.bottom,
                      totalNum: provider.length,
                      stackNum: 3,
                      swipeEdge: 2.0,
                      maxWidth: MediaQuery.of(context).size.width ,
                      maxHeight: MediaQuery.of(context).size.width+200,
                      minWidth: (MediaQuery.of(context).size.width) *0.90,
                      minHeight: (MediaQuery.of(context).size.width+200) * 0.90,
                      cardBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () =>Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RecipeDetailPage(id: index))
                            ),
                            child: RecipeCard(
                              recipeId: provider.itemAt(index).recipeId,
                              name: provider.itemAt(index).name,
                              cover: provider.itemAt(index).cover,
                              introduction: provider.itemAt(index).introduction,
                              favorite:  provider.itemAt(index).favorite,
                              onFavorite: () => null,
                              favorable: false,
                            )
                        );
                      },
                      cardController: CardController(),
                      swipeUpdateCallback:
                          (DragUpdateDetails details, Alignment align) {
                        // 以5为触发条件，识别正在左滑还是右滑
                        if (align.x < -5) {
                          setState(() {
                            being_left = true;
                            being_right = false;
                          });
                        } else if (align.x > 5) {
                          setState(() {
                            being_right = true;
                            being_left = false;
                          });
                        }
                      },
                      swipeCompleteCallback:
                          (CardSwipeOrientation orientation, int index) async {
                        if (orientation.name == "left"){
                          setState(() {
                            being_left = being_right = false;
                          });

                        }
                        else if (orientation.name == "right") {
                          setState(() {
                            being_left = being_right = false;
                          });

                          try{
                            final res = await SaTokenUtil.getTokenName();
                          }
                          catch(e){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          }

                          // 探索界面不解除已收藏的菜品
                          if(!provider.itemAt(index).favorite){
                            provider.favorRecipe(provider.itemAt(index).recipeId);
                          }
                        }
                        else if(orientation.name == "recover")
                          setState(() {
                            being_left = being_right = false;
                          });

                        if(index == provider.length - 1){
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }

                      },
                    ),
                    Positioned(
                      bottom: 48,
                      left: 72,
                      child: being_left
                          ? Icon(Icons.arrow_back_rounded, color: Theme.of(context).colorScheme.primary, size: 42)
                          : const Icon(Icons.arrow_back_rounded, size: 42),
                    ),
                    Positioned(
                      bottom: 48,
                      right: 72,
                      child: being_right
                          ? Icon(Icons.favorite_outline_rounded, color: Theme.of(context).colorScheme.primary, size: 42)
                          : const Icon(Icons.favorite_outline_rounded, size: 42),
                    ),
                  ],
                ),


              )
              ,
            ],
          );
        });
  }

}
