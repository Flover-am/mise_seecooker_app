import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:seecooker/models/NewRecipe.dart';
import 'package:seecooker/models/recipe.dart';
import 'package:seecooker/models/user.dart';
import 'package:seecooker/pages/account/login_page.dart';
import 'package:seecooker/providers/user_provider.dart';
import 'package:seecooker/services/recipe_service.dart';
import 'package:seecooker/utils/FileConverter.dart';

class PublishRecipe extends StatefulWidget {
  final String param;

  const PublishRecipe({super.key, required this.param});

  @override
  State<PublishRecipe> createState() => _PublishRecipeState();
}

class _PublishRecipeState extends State<PublishRecipe> {
  /// 是否有封面
  bool hasCover = false;
  final ImagePicker picker = ImagePicker();

  late XFile cover;
  List<bool> hasStepsCover = [false, false];
  late Map<int, XFile> stepsCover = {};
  ValueNotifier<int> countIngredient = ValueNotifier<int>(1);
  ValueNotifier<int> countStep = ValueNotifier<int>(2);

  /// 标题和简介的监听
  final titleController = TextEditingController();
  final introductionController = TextEditingController();

  /// 配料表的名字和用量的监听
  Map<int, TextEditingController> ingredientsNameController = {};
  Map<int, TextEditingController> ingredientsAmountController = {};

  /// 步骤介绍的监听
  Map<int, TextEditingController> stepContentsController = {};

  /// 主页面
  @override
  Widget build(BuildContext context) {
    var page = this;
    // // 检查用户是否已登录
    // if (!userModel.isLoggedIn) {
    //   // 如果未登录，则导航到LoginPage
    //   WidgetsBinding.instance!.addPostFrameCallback((_) {
    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (context) => const LoginPage()),
    //     );
    //   });
    //   print(userModel.isLoggedIn);
    //   //Navigator.pop(context);
    // }
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Fluttertoast.showToast(msg: "//TODO: 发布");
                },
                icon: const Icon(Icons.publish_rounded))
          ],
          title: Consumer<UserProvider>(
            builder: (context, user, child) => Stack(
              children: [
                Text('${user.username} post'),
              ],
            ),
          )),
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
                  style: const TextStyle(
                      fontSize: 25.0, fontWeight: FontWeight.w800),
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
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  child: TextField(
                    controller: introductionController,
                    decoration: const InputDecoration(
                      hintText: "输入这道美食背后的故事",
                      border: InputBorder.none,
                      // TODO: 修改样式
                    ),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      countIngredient.value += 1;
                    },
                  ),
                ),

                /// “做法”文字
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                  leading: Text("做法", style: titleStyle()),
                ),
                allSteps(),

                /// 步骤＋1 按钮
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
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

  /// 所有步骤
  Widget allSteps() {
    return ValueListenableBuilder(
        valueListenable: countStep,
        builder: (context, value, child) {
          return Column(
            children: List.generate(countStep.value, (index) {
              if (hasStepsCover.length <= index) {
                hasStepsCover.add(false);
              }
              TextEditingController? stepInfoCT = stepContentsController[index];
              if (stepInfoCT == null) {
                stepInfoCT = TextEditingController();
                stepContentsController[index] = stepInfoCT;
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
              selectStepCover(index);
              log("hasStepsCover:$hasStepsCover");
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(0xFF, 0xF6, 0xF6, 0xF6)),
              child: Center(
                  child: hasStepsCover[index]
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.file(File(stepsCover[index]!.path),
                              fit: BoxFit.fitWidth))
                      : Container(
                          height: 250,
                          alignment: Alignment.center,
                          child: const Text(
                            "+ 步骤图\n清晰的步骤图会让菜谱更加受欢迎 ～",
                            style: TextStyle(color: Color(0xFF909090)),
                            textAlign: TextAlign.center,
                          ),
                        )),
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

  /// 发布按钮
  Widget sendButton() {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: TextButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(const BeveledRectangleBorder())),
        child: const Text("发布菜谱",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        onPressed: () async {
          NewRecipe recipe = NewRecipe();
          if (!hasCover) {
            Fluttertoast.showToast(msg: "请上传封面～");
            return;
          }
          if (!hasStepsCover.any((element) => element == true)) {
            Fluttertoast.showToast(msg: "请上传步骤对应的图片哦～");
            return;
          }
          /// 配料
          recipe.introduction = introductionController.text;
          ingredientsNameController.forEach((key, value) {
            recipe.ingredients
                .add({value.text: ingredientsAmountController[key]!.text});
          });
          if(!recipe.ingredients.any(
                  (element) => element.keys.first!=""&& element.values.first!="")
          ){
            Fluttertoast.showToast(msg: "配料和用量不要为空～");
            return;
          }

          /// 标题
          recipe.name = titleController.text;

          /// 封面
          recipe.cover =  FileConverter.xFile2File(cover);


          /// 每一步的内容
          stepContentsController.forEach((key, value) {
            recipe.stepContents.add(value.text);
          });

          var a = 1;
          /// 每一步的图片
          stepsCover.forEach((key, value) async {
            File toAdd =  FileConverter.xFile2File(value);

            recipe.stepImages.add(toAdd);
          });
          log(recipe.stepImages.length.toString());
          var resp = await RecipeService.postRecipe(recipe);
          log(resp.toString());
          if (!resp.isSuccess()) {
            Fluttertoast.showToast(msg: "发布失败: ${resp.message}");
          } else {
            Fluttertoast.showToast(msg: "发布成功！");
            Navigator.pop(context);
          }
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
          selectCover();
          setState(() {
            // this.hasCover = true;
          });
        },
        child: Container(
          color: const Color.fromARGB(0xFF, 0xF6, 0xF6, 0xF6),
          child: Center(
            child: hasCover
                ? Image.file(
                    File(cover.path),
                    fit: BoxFit.fitWidth,
                  )
                : Container(
                    height: 300,
                    alignment: Alignment.center,
                    child: const Text(
                      "+ 添加你的美食封面 ～",
                      style: TextStyle(color: Color(0xFF909090)),
                    ),
                  ),
          ),
        ));
  }

  /// 标题样式
  TextStyle titleStyle() {
    return TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 23,
        color: Theme.of(context).textTheme.titleLarge?.color);
  }

  void selectCover() async {
    XFile image = (await picker.pickImage(source: ImageSource.gallery))!;
    setState(() {
      cover = image;
      hasCover = true;
      log("path: ${image.path}");
    });
  }

  void selectStepCover(index) async {
    XFile image = (await picker.pickImage(source: ImageSource.gallery))!;
    var tmp = hasStepsCover;

    setState(() {
      tmp[index] = true;
      stepsCover[index] = image;
      hasStepsCover = tmp;
      log("hasStepsCover2:$hasStepsCover");
    });
  }
}
