import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:seecooker/models/NewRecipe.dart';
import 'package:seecooker/providers/explore/Ingredients_provider.dart';
import 'package:seecooker/providers/recipe/new_recipe_provider.dart';
import 'package:seecooker/providers/user/user_provider.dart';
import 'package:seecooker/services/recipe_service.dart';
import 'package:seecooker/utils/FileConverter.dart';
import 'package:seecooker/widgets/text_select.dart';

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
  // final titleController = TextEditingController();
  // final introductionController = TextEditingController();

  /// 配料表的名字和用量的监听
  // Map<int, TextEditingController> ingredientsNameController = {};
  // Map<int, TextEditingController> ingredientsAmountController = {};
  Map<int, TextSelect> ingredientsName = {};
  Map<int, TextSelect> ingredientsAmount = {};

  /// 步骤介绍的监听
  // Map<int, TextEditingController> stepContentsController = {};

  /// 主页面
  @override
  Widget build(BuildContext context) {
    var page = this;

    return ChangeNotifierProvider(
      create: (context) => NewRecipeProvider(),
      builder: (context, child) {
        return Consumer<NewRecipeProvider>(builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
                actions: [
                  IconButton(
                      onPressed: () {
                        Fluttertoast.showToast(msg: "//TODO: 发布");
                        provider.model;
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
                        // controller: titleController,
                        onChanged: (value) {
                          provider.model.name = value;
                          // log(value);
                        },
                        decoration: const InputDecoration(
                          hintText: "添加菜谱标题",
                          hintStyle: TextStyle(fontSize: 25),
                          border: InputBorder.none,
                          // TODO: 修改样式
                        ),
                      ),
                      Divider(
                          thickness: 1,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha(10)),
                      Container(
                        margin: const EdgeInsets.only(bottom: 50),
                        child: TextField(
                          onChanged: (value) {
                            provider.model.introduction = value;
                            // log(value);
                          },
                          decoration: const InputDecoration(
                            hintText: "输入这道美食背后的故事",
                            border: InputBorder.none,
                            // TODO: 修改样式
                          ),
                        ),
                      ),

                      /// 用料 TEXT
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0.0),
                        leading: Text(
                          "用料",
                          style: titleStyle(),
                        ),
                      ),

                      /// 配料表
                      Consumer<IngredientsProvider>(
                          builder: (context, inProvider, child) =>
                              ValueListenableBuilder(
                                valueListenable: countIngredient,
                                builder: (context, value, child) {
                                  return Column(
                                    children: List.generate(
                                        countIngredient.value, (index) {
                                      if (index >=
                                          provider
                                              .model.ingredientsName.length) {
                                        provider.model.ingredientsName.add("1");
                                        provider.model.ingredientsAmount
                                            .add("2");
                                      }
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: TextSelect(
                                                    index: index,
                                                    onChange: provider
                                                        .changeIngredientName,
                                                    //  把showList()的的name属性（List<String>）合并成String的list
                                                    ops: inProvider
                                                        .showlist()
                                                        .map((e) => e.name)
                                                        .expand((element) =>
                                                            element)
                                                        .toList(),
                                                  )),
                                              SizedBox(
                                                height: 45,
                                                child: VerticalDivider(
                                                  // 在两个TextField之间画一条竖线
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withAlpha(10), // 线的颜色
                                                  thickness: 1, // 线的厚度
                                                  width: 20,
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: TextSelect(
                                                    index: index,
                                                    onChange: provider
                                                        .changeIngredientAmout,
                                                    ops: const [
                                                      "一个",
                                                      "两个",
                                                      "三个",
                                                      "四个",
                                                      "五个",
                                                      "六个",
                                                      "七个",
                                                      "八个",
                                                      "九个",
                                                      "十个"
                                                    ],
                                                  )),
                                            ],
                                          ),
                                          Divider(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withAlpha(10), // 线的颜色
                                            thickness: 1, // 线的厚度
                                          )
                                        ],
                                      );
                                    }),
                                  );
                                },
                              )),

                      /// 配料＋1 按钮
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0.0),
                        trailing: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            countIngredient.value += 1;
                          },
                        ),
                      ),

                      /// “做法”文字
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0.0),
                        leading: Text("做法", style: titleStyle()),
                      ),
                      ValueListenableBuilder(
                          valueListenable: countStep,
                          builder: (context, value, child) {
                            return Column(
                              children: List.generate(countStep.value, (index) {
                                if (index >=
                                    provider.model.stepContents.length) {
                                  provider.model.stepContents.add("");
                                }
                                return singleStep(index, (value) {
                                  provider.model.stepContents[index] = value;
                                  log(value);
                                });
                              }),
                            );
                          }),

                      /// 步骤＋1 按钮
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0.0),
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

                // const TextSelect(),
                Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                            const BeveledRectangleBorder())),
                    child: const Text("发布菜谱",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    onPressed: () async {
                      if (!hasCover) {
                        Fluttertoast.showToast(msg: "请上传封面～");
                        return;
                      }
                      if (!hasStepsCover.any((element) => element == true)) {
                        Fluttertoast.showToast(msg: "请上传步骤对应的图片哦～");
                        return;
                      }
                      //检测provider的model中的ingredientsAmount和ingredientsName是否有元素为“”
                      if (!provider.model.ingredientsName
                          .any((element) => element != "")) {
                        Fluttertoast.showToast(msg: "配料不要为空～");
                        return;
                      }
                      if (!provider.model.ingredientsAmount
                          .any((element) => element != "")) {
                        Fluttertoast.showToast(msg: "用量不要为空～");
                        return;
                      }
                      if (!provider.model.stepContents
                          .any((element) => element != "")) {
                        Fluttertoast.showToast(msg: "步骤描述不要为空～");
                        return;
                      }
                      stepsCover.forEach((key, value) {
                        provider.model.stepImages
                            .add(FileConverter.xFile2File(value));
                      });
                      provider.model.cover = FileConverter.xFile2File(cover);
                      provider.publish();
                    },
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  /// 单个步骤
  Widget singleStep(index, onchange) {
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
          decoration: const InputDecoration(
            hintText: '添加步骤说明～',
            border: InputBorder.none,
            // TODO: 修改样式
          ),
          onChanged: onchange,
        ),
        Divider(
            thickness: 1,
            color: Theme.of(context).colorScheme.primary.withAlpha(10)),
      ],
    );
  }

  Future<void> send() async {
    NewRecipe recipe = NewRecipe();
    if (!hasCover) {
      Fluttertoast.showToast(msg: "请上传封面～");
      return;
    }
    if (!hasStepsCover.any((element) => element == true)) {
      Fluttertoast.showToast(msg: "请上传步骤对应的图片哦～");
      return;
    }

    var resp = await RecipeService.publishRecipe(recipe).then((s) {
      return s;
    }, onError: (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "发布失败:${e.toString().split(":")[1]}");
    });
    ;
    ingredientsName.forEach((key, value) {
      // recipe.ingredientsName.add();
    });
    log(resp.toString());
    if (!resp.isSuccess()) {
      Fluttertoast.showToast(msg: "发布失败: ${resp.message}");
    } else {
      Fluttertoast.showToast(msg: "发布成功！");
      Navigator.pop(context);
    }
  }

  /// 封面
  Widget _buildCover(hasCover) {
    return GestureDetector(
        onTap: () {
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
