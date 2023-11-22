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
            .fetchPostDetail(widget.id);
        return FutureBuilder(
            future: init,
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
                return Consumer<RecipeDetailProvider>(
                  builder: (BuildContext context, RecipeDetailProvider value,
                      Widget? child) {
                    var model = value.model;
                    return Scaffold(
                      appBar: AppBar(
                        title: AuthorInfoBar(
                          authorAvatar: model.authorAvatar,
                          authorName: model.authorName,
                        ),
                      ),

                      /// BODY
                      body: GestureDetector(
                          onTapDown: (details) {
                            var x = details.globalPosition.dx; // 获取点击的全局x坐标
                            var screenWidth =
                                MediaQuery.of(context).size.width; // 获取屏幕的宽度
                            if (x < screenWidth / 3) {
                              swiperController.previous();
                            } else if (x > screenWidth * 2 / 3) {
                              swiperController.next();
                            }
                          },
                          child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Swiper(
                                  controller: swiperController,
                                  // viewportFraction: 0.8,
                                  scale: 0.8,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: model.contents.length,
                                  loop: false,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image(
                                              image: AssetImage(
                                                  model.authorAvatar)),
                                        ),
                                        TextSection(
                                          content: model.contents[index]!,
                                          index: index,
                                          allLength: model.contents.length,
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ))),

                      /// BAR
                      bottomNavigationBar: const RecipeBar(),
                    );
                  },
                );
              }
            });
      },
    );
  }
}

class TextSection extends StatelessWidget {
  const TextSection(
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
