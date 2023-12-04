import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/pages/explore/makeexp_page.dart';
import 'package:seecooker/providers/explore_post_provider.dart';
import 'package:seecooker/widgets/chose_page.dart';
import 'package:seecooker/widgets/chosen_line.dart';
import 'package:seecooker/widgets/my_search_bar.dart';

import '../../utils/dishes.dart';



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
              Expanded(
                flex: 5,
                  child: ChosenLine(
                title: '您已挑选',
                dishesFilter:
                Provider.of<ExplorePostProvider>(context, listen: false)
                    .showlist()))
              ,
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
              SizedBox(height: 20,)
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
    return Scaffold(
      body: Container(
          margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
          child: ListView(
            children: [
              MySearchBar(),
              SizedBox(height: 10,),
        DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: '蔬菜'),
                  Tab(text: '肉类'),
                ],
                indicatorColor: Colors.blue, // 选项卡指示器颜色
              ),
              SizedBox(
                height: 500, // 适当设置高度
                child: TabBarView(
                  children: [
                    // 收藏页面内容
                    ChosePage(title: "挑选蔬菜",subtitle: "吃蔬菜打造健康饮食~", dishesFilter: dishesFilter),
                    ChosePage(title: "挑选肉类",subtitle: "给生活加点蛋白质！", dishesFilter: meatFilter)
                    // 发布页面内容
                  ],
                ),
              ),
            ],
          ),
        )
            ],
          )
      ),
      floatingActionButton:  FloatingActionButton(
          child: Icon(Icons.shopping_bag),
          onPressed: () => showCommentSection(context, false)),
    );

  }
  Widget _buildFoodCategoryPage(List<String> foodList) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 一行显示三个Chip
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 2.0, // 调整Chip的高度
      ),
      itemCount: foodList.length,
      itemBuilder: (BuildContext context, int index) {
        return Chip(
          label: Text(foodList[index]),
          // 在这里处理点击事件，可以添加选中效果
          // onPressed: () => handleChipTap(foodList[index]),
        );
      },
    );
  }
}
