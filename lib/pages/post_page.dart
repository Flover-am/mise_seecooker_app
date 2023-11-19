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
  var hasCover = false;
  /// 配料表的名字和用量的监听
  ValueNotifier<int> countIngredient = ValueNotifier<int>(1);
  ValueNotifier<bool> hasStepCover = ValueNotifier<bool>(false);
  /// 标题和简介的监听
  final titleController = TextEditingController();
  final summaryController = TextEditingController();

  Map<int, TextEditingController> ingredientsNameController = {};
  Map<int, TextEditingController> ingredientsAmountController = {};

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
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: '标题',
              // TODO: 修改样式
            ),
          ),

          /// 简介
          TextField(
            controller: summaryController,
            decoration: const InputDecoration(
              labelText: '简介',
              // TODO: 修改样式
            ),
          ),

          /// 用料 TEXT
          ListTile(
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
            leading: Text("做法", style: titleStyle()),
          ),
        ],
      ),
    );
  }

  // Widget singleStep(){
  //   return
  // }

  Widget singleStep(index) {

    return Column(
      children: [
        ListTile(
          leading: Text("步骤$index")
        ),
        GestureDetector(
            onTap: () {
              Fluttertoast.showToast(msg: "//TODO: 跳转到相册添加图片");
            },
            child: Container(
              height: 150,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              color: const Color.fromARGB(0xFF, 0xF6, 0xF6, 0xF6),
              child: Center(
                child: hasCover
                    ? Image.network(imageUrlTmp)
                    : const Text(
                  "+ 步骤图\n清晰的步骤图会让菜谱更加受欢迎 ～",
                  style: TextStyle(color: Color(0xFF909090)),
                ),
              ),
            ))

      ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            flex: 1,
            child: TextField(
              controller: nameCT,
              decoration: const InputDecoration(
                labelText: '食材：比如鸡蛋',
                // TODO: 修改样式
              ),
            )),
        const SizedBox(
          height: 45,
          child: VerticalDivider(
            // 在两个TextField之间画一条竖线
            color: Colors.grey, // 线的颜色
            thickness: 1, // 线的厚度
            width: 20,
          ),
        ),
        Expanded(
            flex: 1,
            child: TextField(
              controller: amountCT,
              decoration: const InputDecoration(
                labelText: '用量：比如一只',
                // TODO: 修改样式
              ),
            )),
      ],
    );
  }

  /// 封面
  Widget _buildCover(hasCover) {
    return GestureDetector(
        onTap: () {
          Fluttertoast.showToast(msg: "//TODO: 跳转到相册添加图片");
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
