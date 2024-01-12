import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/pages/search/search_page.dart';
import 'package:seecooker/providers/recipe/search_recipes_provider.dart';
import 'package:seecooker/providers/search/search_ai_provider.dart';
import 'package:seecooker/utils/my_icons.dart';
import 'package:seecooker/widgets/recipes_list.dart';
import 'package:skeletons/skeletons.dart';

/// 搜索结果页
class SearchResultPage extends StatelessWidget {
  /// 搜索内容
  final String query;

  /// 搜索框输入控制器
  final _textEditingController = TextEditingController();

  SearchResultPage({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    // 首先设置搜索框内容
    _textEditingController.text = query;

    return MultiProvider(
      providers: [
        Provider(create: (context) => SearchRecipesProvider(query)),
        ChangeNotifierProvider(create: (context) => SearchAiProvider(query)),
      ],
      builder: (context, child) {
        // 调用大模型
        Future aiResponseFuture = Provider.of<SearchAiProvider>(context).fetchAiResponse();

        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            scrolledUnderElevation: 0,
            title: TextField(
              onTap: () => goToSearch(context, query),
              cursorRadius: const Radius.circular(2),
              controller: _textEditingController,
              maxLength: 100,
              decoration: InputDecoration(
                hintText: '搜索食谱',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                counterText: '',
              ),
            ),
            actions: [
              const SizedBox(width: 4),
              IconButton(
                onPressed: () => goToSearch(context, query),
                icon: const Icon(Icons.search)
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                AIResponseTextSection(future: aiResponseFuture)
              ];
            },
            body: RecipesList<SearchRecipesProvider>(
              emptyMessage: '抱歉，没有找到$query相关的食谱，换个关键词再试试吧 ~',
              enableRefresh: false,
              private: false,
            ),
          ),
        );
      }
    );
  }

  void goToSearch(BuildContext context, String query) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SearchPage(query: query)),
    );
  }
}

/// AI回答文本内容框
class AIResponseTextSection extends StatelessWidget {
  final Future future;

  const AIResponseTextSection({super.key, required this.future});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(MyIcons.ai, color: Color.fromARGB(255, 117, 169, 156), size: 16),
                const SizedBox(width: 4),
                Text('AI小助手', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: const Color.fromARGB(255, 117, 169, 156))),
                const Spacer(),
                Material(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: () {
                      try {
                        Clipboard.setData(ClipboardData(text: Provider.of<SearchAiProvider>(context, listen: false).response));
                        Fluttertoast.showToast(msg: '已复制到剪贴板');
                      } catch(e) {
                        log("$e");
                        Fluttertoast.showToast(msg: '复制失败');
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Icon(Icons.copy_rounded, size: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                          Text('复制', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting){
                  return const SkeletonLine(style: SkeletonLineStyle(borderRadius: BorderRadius.all(Radius.circular(4))));
                } else if (snapshot.hasError) {
                  log('${snapshot.error}');
                  return Text('悲报！AI小助手好像出错了', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)));
                } else {
                  return Consumer<SearchAiProvider>(
                    builder: (context, provider, child) {
                      return ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 144),
                        child: SingleChildScrollView(
                          child: AnimatedTextKit(
                            isRepeatingAnimation: false,
                            displayFullTextOnTap: true,
                            animatedTexts: [
                              TyperAnimatedText(provider.response, textStyle: TextStyle(fontSize: 14, height: 1.4)),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

}