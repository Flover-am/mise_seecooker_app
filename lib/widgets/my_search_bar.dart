import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/models/Ingredients.dart';
import 'package:seecooker/providers/explore/explore_post_provider.dart';

/// 探索页面搜索框
class MySearchBar extends StatefulWidget {
  const MySearchBar({super.key ,required this.categories});
  final List<Ingredients> categories;
  @override
  _MySearchBarState createState() => _MySearchBarState(categories: this.categories);
}

class _MySearchBarState extends State<MySearchBar> {
  List<String> _searchHistory = [];
  String search = "0";
  String suggest = "没有对应食材";
  _MySearchBarState({required this.categories});
  final List<Ingredients> categories;
  Iterable<Widget> getSuggestions(SearchController controller) {
    setState(() {
      if(FindDish(search, categories)!="") {
        suggest=FindDish(search, categories);
      }
    });
    var searchItem = ListTile(
      leading: const Icon(Icons.arrow_outward),
      title: Text(suggest),
      onTap: () {
        if(!Provider.of<ExplorePostProvider>(context, listen: false).contain(FindDish(search, categories))) {
          Provider.of<ExplorePostProvider>(context, listen: false).add(FindDish(search, categories));
        }
      },
    );
    var historyList = _searchHistory.map((item) => ListTile(
      leading: const Icon(Icons.history),
      title: Text(item),
      onTap: () {
        if(!Provider.of<ExplorePostProvider>(context, listen: false).contain(item)) {
          Provider.of<ExplorePostProvider>(context, listen: false).add(FindDish(item,categories));
        }
      },
    ));
    var clearItem = ListTile(
      leading: const Icon(Icons.delete_outlined),
      title: Text('清除历史记录'),
      onTap: () {
        setState(() {
          _searchHistory.clear();
        });
        controller.closeView('111');
      },
    );
    return [searchItem, ...historyList, if(_searchHistory.isNotEmpty) clearItem];
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
        isFullScreen: false,
        viewBackgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        viewElevation: 0,
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            elevation: const MaterialStatePropertyAll<double>(0),
            backgroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).colorScheme.surfaceVariant),
            padding: const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16)),
            controller: controller,
            leading: const Icon(Icons.search),
            hintText: '搜索食材',
            onSubmitted: (text) {
              if(FindDish(text,categories)!=""){
                if(!Provider.of<ExplorePostProvider>(context, listen: false).contain(FindDish(text,categories))) {
                  Provider.of<ExplorePostProvider>(context, listen: false).add(FindDish(text,categories));
                  Fluttertoast.showToast(
                      msg: "成功添加${FindDish(text,categories)}！",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 16.0);
                }
                else {
                  Fluttertoast.showToast(
                      msg: "您已添加过${FindDish(text,categories)}！",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 16.0);
                }
              }
              else{
                Fluttertoast.showToast(
                    msg: "没有找到该食材！",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    fontSize: 16.0);
              }
            },
          );
        },
        suggestionsBuilder: (BuildContext context, SearchController controller) {
          return getSuggestions(controller);
        }
    );
  }
}

/// 搜索原材料
String FindDish(String dish, List<Ingredients> categories){
  if(dish=="") {
    return "";
  }
  for(var category in categories){
    for(String ingredient in category.name) {
      if(ingredient==dish)
        return ingredient;
    }
  }
  return "";
}
