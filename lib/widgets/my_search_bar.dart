import 'package:flutter/material.dart';

class MySearchBar extends StatefulWidget {
  const MySearchBar({super.key});

  @override
  _MySearchBarState createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  List<String> _searchHistory = ['history 1'];

  // Iterable<Widget> getHistoryList(SearchController controller) {
  //   return _searchHistory.map((item) => ListTile(
  //     leading: const Icon(Icons.history),
  //     title: Text(item, style: TextStyle(color: Colors.grey)),
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: SearchBar(
        padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(12, 0, 12, 0)),
        leading: const Icon(Icons.search),
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.2)),
        hintText: '搜索菜谱',
      ),
    );
  }
}