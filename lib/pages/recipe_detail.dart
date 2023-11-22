import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class RecipeDetail extends StatefulWidget {
  const RecipeDetail({super.key});

  @override
  State<StatefulWidget> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  String author = 'XiaoHu';
  String authorAvatar = 'assets/images/tmp/avatar.png';
  int starAmount = 0;

  Map<int, String> contents = {
    0: "活虾清洗干净后 ，从头部去除内脏和虾线，去壳留虾仁和虾头。\n油热放入葱姜丝，虾头锅里煸出虾油，放入水烧开，加入食盐，胡椒粉调味，煮开后翻滚几分钟后，放入虾仁，青菜叶，关火（虾仁烫熟肉质会比较鲜嫩），放入适量鸡精。\n    面条单独起锅煮熟捞入碗中，倒入做好的鲜汤，加入一个煎蛋，完美。",
    1: "1️⃣、香菇、土豆切丁，辣椒切段，热锅入油，放入葱姜爆香，倒入肉末翻炒变色➕1勺料酒翻炒，倒入香菇丁土豆丁翻炒均匀",
    2: "2️⃣、加入生抽2勺➕老抽1勺➕蚝油2勺➕盐和糖半勺➕适量胡椒粉，翻炒均匀上色，加入一碗温水，煮几分钟\n    3️⃣、放入辣椒🌶️淋入适量水淀粉，翻炒至浓稠即可",
    3: "👍盛碗米饭拌上香菇土豆肉沫，真的太香了"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(authorAvatar),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(author)),
          ],
        ),
      ),
      /// BODY
      body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
            child: Swiper(
              scrollDirection: Axis.horizontal,
              itemCount: contents.length,
              loop: false,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image(image: AssetImage(authorAvatar)),
                    ),
                    TextSection(content: contents[index]!)
                  ],
                );
              },
            ),
          )),
      /// BAR
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return Container(
                        height: 40,
                        width: 35,
                        child: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            iconSize: 35,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                starAmount = index;
                              });
                            },
                            icon: Icon(index > starAmount
                                ? Icons.favorite_border
                                : Icons.favorite)),
                      );
                    }),
                  ),
                  IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onPressed: () {},
                      icon: Container(
                        padding: const EdgeInsets.all(1),
                        height: 40,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(child: Text('评价')),
                      ))
                ],
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.star_border),
                  iconSize: 35)
            ],
          ),
        ),
      ),
    );
  }
}

class TextSection extends StatelessWidget {
  const TextSection({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
