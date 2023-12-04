import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/pages/explore/makeexp_page.dart';
import 'package:seecooker/providers/explore_post_provider.dart';
import 'package:seecooker/widgets/chose_line.dart';
import 'package:seecooker/widgets/my_search_bar.dart';

List<String> dishesFilter = [
  "土豆",
  "西红柿",
  "胡萝卜",
  "卷心菜",
  "洋葱",
  "白菜",
  "扁豆",
  "南瓜",
  "蘑菇",
  "茄子",
  "丝瓜",
  "黄瓜",
  "玉米",
  "萝卜",
  "芹菜",
  "香菜",
  "土豆",
  "豆芽",
  "西兰花",
  "婆婆丁"
];
List<String> meatFilter = [
  "鸡蛋",
  "猪肉",
  "五花肉",
  "牛肉",
  "鸡肉",
  "羊肉",
  "鱼肉",
  "牛排",
  "猪肝",
  "腰花",
  "排骨",
  "狗肉",
  "马肉"
];

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

void showCommentSection(BuildContext context, bool autofocus) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SizedBox(
          height: 320,
          child: Column(
            children: [
              ChoseLine(
                  title: '您已挑选',
                  dishesFilter:
                      Provider.of<ExplorePostProvider>(context, listen: false)
                          .showlist()),
              SizedBox(
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
            ],
          ));
    },
    isScrollControlled: true,
    showDragHandle: true,
  );
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
        margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
        child: ListView(
          children: [
            const MySearchBar(),
            ChoseLine(title: "挑 选 蔬 菜", dishesFilter: dishesFilter),
            ChoseLine(title: "挑 选 肉 类", dishesFilter: meatFilter),
            SizedBox(
              width: MediaQuery.of(context).size.width / 4,
              height: 45,
              child: FloatingActionButton(
                  child: const Text("我 已 挑 选",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                  onPressed: () => showCommentSection(context, false)),
            )
          ],
        ));
  }
}
