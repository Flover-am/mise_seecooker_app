import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/providers/recommend_provider.dart';
import 'package:seecooker/services/explore_service.dart';
import 'package:seecooker/widgets/tinder_card.dart';

import 'package:seecooker/widgets/post_card.dart';
import 'package:tcard/tcard.dart';

import '../../widgets/exp_recipe_card.dart';
import '../../widgets/recipe_card.dart';
import '../recipe/recipe_detail.dart';

class MakeExpPage extends StatefulWidget {
  const MakeExpPage({super.key});

  @override
  State<MakeExpPage> createState() => _MakeExpPageState();
}

class _MakeExpPageState extends State<MakeExpPage> {
  var text = 'mkexp';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("为您推荐："),
        ),
        body: FutureBuilder(
            future: Provider.of<RecommendProvider>(context, listen: false)
                .fetchPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
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
  bool being_right = false;
  bool being_left = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<RecommendProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    TinderSwapCard(
                      swipeUp: false,
                      swipeDown: false,
                      orientation: AmassOrientation.bottom,
                      totalNum: provider.length,
                      stackNum: 3,
                      swipeEdge: 2.0,
                      maxWidth: MediaQuery.of(context).size.width ,
                      maxHeight: MediaQuery.of(context).size.width+300,
                      minWidth: (MediaQuery.of(context).size.width) *0.90,
                      minHeight: (MediaQuery.of(context).size.width+300) * 0.90,
                      cardBuilder: (context, index) {
                        if (index == provider.length - 1) {
                          provider.fetchMorePosts();
                        }
                        return GestureDetector(
                            onTap: () =>Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RecipeDetail(id: index))
                            ),
                            child: ExpRecipeCard(
                              id: index,
                              title: provider.itemAt(index).name,
                              coverUrl: provider.itemAt(index).cover,
                              author: provider.itemAt(index).authorName,
                              introduction: provider.itemAt(index).introduction,
                              authorAvatar: provider.itemAt(index).authorAvatar,
                              // author: provider.itemAt(index).author,
                              // like: provider.itemAt(index).like,
                              // rate: provider.itemAt(index).rate,
                            )
                        );
                      },
                      cardController: CardController(),
                      swipeUpdateCallback:
                          (DragUpdateDetails details, Alignment align) {
                        if (align.x < 5) {
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
                          (CardSwipeOrientation orientation, int index) {
                        if (orientation.name == "left"){
                          setState(() {
                            being_left = being_right = false;
                          });
                          print("左滑！");
                        }
                        else if (orientation.name == "right") {
                          setState(() {
                            being_left = being_right = false;
                          });
                          ExploreService.addToFavorite(index);
                          print("右滑！");
                        }
                        else if(orientation.name == "recover")
                          setState(() {
                            being_left = being_right = false;
                          });

                      },
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: being_left
                          ? const Icon(Icons.arrow_back, color: Colors.red, size: 80)
                          : const Icon(Icons.arrow_back_outlined, size: 80),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: being_right
                          ? const Icon(Icons.star, color: Colors.red, size: 80)
                          : const Icon(Icons.star_outlined, size: 80),
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
