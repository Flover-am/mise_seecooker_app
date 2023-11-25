import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/pages/search_result_page.dart';
import 'package:seecooker/providers/search_history_provider.dart';
import 'package:skeletons/skeletons.dart';

class SearchPage extends StatelessWidget {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchHistoryProvider(),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            scrolledUnderElevation: 0,
            title: TextField(
              cursorRadius: const Radius.circular(2),
              autofocus: true,
              controller: _textEditingController,
              focusNode: _focusNode,
              maxLength: 100,
              decoration: InputDecoration(
                hintText: '搜索食谱',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                counterText: '',
              ),
              onSubmitted: (value) {
                _focusNode.unfocus();
                if(value.isNotEmpty) {
                  goToSearchResult(context, value);
                } else {
                  Fluttertoast.showToast(msg: '请输入内容');
                }
              },
            ),
            actions: [
              const SizedBox(width: 4),
              IconButton(
                onPressed: () {
                  _focusNode.unfocus();
                  if(_textEditingController.text.isNotEmpty) {
                    goToSearchResult(context, _textEditingController.text);
                  } else {
                    Fluttertoast.showToast(msg: '请输入内容');
                  }
                },
                icon: const Icon(Icons.search)
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FutureBuilder(
              future: Provider.of<SearchHistoryProvider>(context, listen: false).fetchSearchHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 36,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 36,
                          width: 64,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Consumer<SearchHistoryProvider>(
                    builder: (context, provider, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 8),
                              const Icon(Icons.history),
                              const SizedBox(width: 4),
                              Text('搜索历史', style: Theme.of(context).textTheme.titleMedium,),
                              const Spacer(),
                              IconButton(
                                onPressed: provider.history.isNotEmpty
                                  ? () => provider.clearSearchHistory()
                                  : null,
                                icon: const Icon(Icons.delete_outline),
                                //visualDensity: VisualDensity.compact,
                              )
                            ],
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: provider.history.map((item) =>
                                ActionChip(
                                  label: Text(item),
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    goToSearchResult(context, item);
                                  },
                                )
                            ).toList(),
                          ),
                        ],
                      );
                    },
                  );
                }
              }
            ),
          ),
        );
      },
    );
  }

  void goToSearchResult(BuildContext context, String query){
    Provider.of<SearchHistoryProvider>(context, listen: false).updateSearchHistory(query);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SearchResultPage(query: query)),
    );
  }
}