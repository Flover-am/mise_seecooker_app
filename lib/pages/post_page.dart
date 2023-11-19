import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostPage extends StatefulWidget {
  final String param;

  const PostPage({super.key, required this.param});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  /// 是否有封面
  bool hasCover = false;
  List<bool> hasStepsCover = [false, false];

  ValueNotifier<int> countIngredient = ValueNotifier<int>(1);
  ValueNotifier<int> countStep = ValueNotifier<int>(2);

  /// 标题和简介的监听
  final titleController = TextEditingController();
  final summaryController = TextEditingController();

  /// 配料表的名字和用量的监听
  Map<int, TextEditingController> ingredientsNameController = {};
  Map<int, TextEditingController> ingredientsAmountController = {};

  /// 步骤介绍的监听
  Map<int, TextEditingController> stepInfoController = {};

  static const imageUrlTmp =
      "https://iknow-pic.cdn.bcebos.com/79f0f736afc3793104af684afbc4b74542a91189?x-bce-process=image%2Fresize%2Cm_lfit%2Cw_600%2Ch_800%2Climit_1%2Fquality%2Cq_85%2Fformat%2Cf_auto";

  /// 主页面
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('post'),
      ),
      body: ListView(
        // 整个页面
        children: [
          /// 封面
          _buildCover(hasCover),

          /// 标题
          /// 简介
          Container(
            margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: "添加菜谱标题",
                    hintStyle: TextStyle(fontSize: 25),
                    border: InputBorder.none,
                    // TODO: 修改样式
                  ),
                ),
                Divider(
                    thickness: 1,
                    color: Theme.of(context).colorScheme.primary.withAlpha(10)),
                TextField(
                  controller: summaryController,
                  decoration: const InputDecoration(
                    hintText: "输入这道美食背后的故事",
                    border: InputBorder.none,
                    // TODO: 修改样式
                  ),
                ),

                /// 用料 TEXT
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                  leading: Text(
                    "用料",
                    style: titleStyle(),
                  ),
                ),

                /// 配料表
                allIngredient()

                /// 配料＋1 按钮
                ,
                ListTile(
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      countIngredient.value += 1;
                    },
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                  leading: Text("做法", style: titleStyle()),
                ),
                allSteps(),
                ListTile(
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      countStep.value += 1;
                    },
                  ),
                ),
              ],
            ),
          ),
          sendButton()
        ],
      ),
    );
  }

  Widget allSteps() {
    return ValueListenableBuilder(
        valueListenable: countStep,
        builder: (context, value, child) {
          return Column(
            children: List.generate(countStep.value, (index) {
              hasStepsCover = List.filled(countStep.value, false);
              TextEditingController? stepInfoCT = stepInfoController[index];
              if (stepInfoCT == null) {
                stepInfoCT = TextEditingController();
                stepInfoController[index] = stepInfoCT;
              }
              return singleStep(index, stepInfoCT);
            }),
          );
        });
  }

  /// 单个步骤
  Widget singleStep(index, stepInfoCT) {
    return Column(
      children: [
        ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 2),
            leading: Text(
              "步骤${index + 1}",
              style: const TextStyle(fontSize: 15),
            )),
        GestureDetector(
            onTap: () {
              Fluttertoast.showToast(msg: "//TODO: 跳转到相册添加图片");
            },
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(0xFF, 0xF6, 0xF6, 0xF6)),
              child: Center(
                child: hasStepsCover[index]
                    ? Image.network(imageUrlTmp)
                    : const Text(
                        "+ 步骤图\n清晰的步骤图会让菜谱更加受欢迎 ～",
                        style: TextStyle(color: Color(0xFF909090)),
                        textAlign: TextAlign.center,
                      ),
              ),
            )),
        TextField(
          controller: stepInfoCT,
          decoration: const InputDecoration(
            hintText: '添加步骤说明～',
            border: InputBorder.none,

            // TODO: 修改样式
          ),
        ),
        Divider(
            thickness: 1,
            color: Theme.of(context).colorScheme.primary.withAlpha(10)),
      ],
    );
  }

  Widget sendButton() {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(const BeveledRectangleBorder())
        ),
        child: const Text("发布菜谱",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        onPressed: () {
          Fluttertoast.showToast(msg: "//TODO: Send !");
        },
      ),
    );
  }

  /// 食材列表
  Widget allIngredient() {
    return ValueListenableBuilder(
      valueListenable: countIngredient,
      builder: (context, value, child) {
        return Column(
          children: List.generate(countIngredient.value, (index) {
            TextEditingController? nameCT = ingredientsNameController[index];
            TextEditingController? amountCT =
                ingredientsAmountController[index];
            if (nameCT == null) {
              nameCT = TextEditingController();
              ingredientsNameController[index] = nameCT;
            }
            if (amountCT == null) {
              amountCT = TextEditingController();
              ingredientsAmountController[index] = amountCT;
            }
            return singleIngredient(nameCT, amountCT);
          }),
        );
      },
    );
  }

  /// 单个食材ROw
  Widget singleIngredient(
      TextEditingController nameCT, TextEditingController amountCT) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: TextField(
                  controller: nameCT,
                  decoration: const InputDecoration(
                    hintText: '食材：比如鸡蛋',
                    border: InputBorder.none,

                    // TODO: 修改样式
                  ),
                )),
            SizedBox(
              height: 45,
              child: VerticalDivider(
                // 在两个TextField之间画一条竖线
                color:
                    Theme.of(context).colorScheme.primary.withAlpha(5), // 线的颜色
                thickness: 1, // 线的厚度
                width: 20,
              ),
            ),
            Expanded(
                flex: 1,
                child: TextField(
                  controller: amountCT,
                  decoration: const InputDecoration(
                    hintText: '用量：比如一只',
                    border: InputBorder.none,

                    // TODO: 修改样式
                  ),
                )),
          ],
        ),
        Divider(
            thickness: 1,
            color: Theme.of(context).colorScheme.primary.withAlpha(10)),
      ],
    );
  }

  /// 封面
  Widget _buildCover(hasCover) {
    return GestureDetector(
        onTap: () {
          Fluttertoast.showToast(msg: "//TODO: 跳转到相册添加图片");
          setState(() {
            this.hasCover = true;
          });
        },
        child: Container(
          height: 200,
          color: const Color.fromARGB(0xFF, 0xF6, 0xF6, 0xF6),
          child: Center(
            child: hasCover
                ? Image.network(imageUrlTmp)
                : const Text(
                    "+ 添加你的美食封面 ～",
                    style: TextStyle(color: Color(0xFF909090)),
                  ),
          ),
        ));
  }

  /// 标题样式
  TextStyle titleStyle() {
    return const TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  }
}
