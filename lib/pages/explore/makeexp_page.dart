import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/providers/recommend_provider.dart';
import 'package:seecooker/widgets/tinder_card.dart';

import 'package:seecooker/widgets/community_card.dart';

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
                flex: 2,
                  child: TinderSwapCard(
                swipeUp: false,
                swipeDown: false,
                orientation: AmassOrientation.bottom,
                totalNum: provider.length,
                stackNum: 3,
                swipeEdge: 2.0,
                maxWidth: MediaQuery.of(context).size.width +100,
                maxHeight: MediaQuery.of(context).size.width+400,
                minWidth: (MediaQuery.of(context).size.width+100) *0.9,
                minHeight: (MediaQuery.of(context).size.width+400) * 0.9,
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
                    author: '111',
                    like: 5,
                    rate: 5.6,
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
                    print("右滑！");
                  }
                  else if(orientation.name == "recover")
                    setState(() {
                      being_left = being_right = false;
                    });

                },
              ))
              ,
              Expanded(child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  being_left
                      ? const Icon(Icons.arrow_back, color: Colors.red,size: 80,):
                  const Icon(Icons.arrow_back_outlined,size: 80),
                  being_right
                      ? const Icon(Icons.star, color: Colors.red,size: 80)
                      : const Icon(Icons.star_outlined,size: 80),
                ],))

            ],
          );
        });
  }

}
