import 'package:flutter/material.dart';

import '../pages/publish/post_page.dart';

class MySearchBar extends StatefulWidget {
  const MySearchBar({super.key});

  @override
  _MySearchBarState createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  List<String> _searchHistory = ['history 1', 'history 2', 'history 3', 'history 4', 'history 5', 'history 6'];

  Iterable<Widget> getSuggestions(SearchController controller) {
    var searchItem = ListTile(
      leading: const Icon(Icons.arrow_outward),
      title: Text('111'),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostPage(param: '111'))
        );
      },
    );
    var historyList = _searchHistory.map((item) => ListTile(
      leading: const Icon(Icons.history),
      title: Text(item),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostPage(param: item))
        );
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
          hintText: '搜索菜谱',
          onTap: () => { controller.openView() },
          onChanged: (_) => { controller.openView() },
          onSubmitted: (text) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostPage(param: text))
            );
          },
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return getSuggestions(controller);
      }
    );
  }
}