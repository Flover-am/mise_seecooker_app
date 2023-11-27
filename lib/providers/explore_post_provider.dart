import 'package:flutter/cupertino.dart';

import '../models/post.dart';

class ExplorePostProvider extends ChangeNotifier {
  final List<String> _list = [];

  int get length => _list.length;
  bool contain(String s) => _list.contains(s);
  String itemAt(int index) => _list[index];
  List<String> showlist() => _list;
  Future<void> add(String v) async {
    _list.add(v);
    notifyListeners();
  }
  Future<void> remove(String v) async {
    _list.remove(v);
    notifyListeners();
  }
}