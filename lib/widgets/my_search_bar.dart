import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:seecooker/providers/explore_post_provider.dart';
import 'package:seecooker/utils/dishes.dart';


class MySearchBar extends StatefulWidget {
  const MySearchBar({super.key});

  @override
  _MySearchBarState createState() => _MySearchBarState();
}

String FindDish(String dish){
  if(dish=="") {
    return "";
  }
  for(String veg in dishesFilter) {
    if(veg.contains(dish)) {
      return veg;
    }
  }
  for(String veg in meatFilter) {
    if(veg.contains(dish)) {
      return veg;
    }
  }
  return "";
}
class _MySearchBarState extends State<MySearchBar> {
  List<String> _searchHistory = [];
  String search = "0";
  String suggest = "没有对应食材";
  Iterable<Widget> getSuggestions(SearchController controller) {
    setState(() {
      if(FindDish(search)!="") {
        suggest=FindDish(search);
      }
    });
    var searchItem = ListTile(
      leading: const Icon(Icons.arrow_outward),
      title: Text(suggest),
      onTap: () {
        if(!Provider.of<ExplorePostProvider>(context, listen: false).contain(FindDish(search))) {
          Provider.of<ExplorePostProvider>(context, listen: false).add(FindDish(search));
        }
      },
    );
    var historyList = _searchHistory.map((item) => ListTile(
      leading: const Icon(Icons.history),
      title: Text(item),
      onTap: () {
        if(!Provider.of<ExplorePostProvider>(context, listen: false).contain(item)) {
          Provider.of<ExplorePostProvider>(context, listen: false).add(FindDish(item));
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
          trailing: [const CircleAvatar(
            radius: 12,
            backgroundImage: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
          )],
          hintText: '搜索食材',
          onSubmitted: (text) {
            if(FindDish(text)!=""){
              if(!Provider.of<ExplorePostProvider>(context, listen: false).contain(FindDish(text))) {
                Provider.of<ExplorePostProvider>(context, listen: false).add(FindDish(text));
                Fluttertoast.showToast(
                    msg: "成功添加${FindDish(text)}！",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    fontSize: 16.0);
              }
              else {
                Fluttertoast.showToast(
                    msg: "您已添加过${FindDish(text)}！",
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