import 'package:flutter/material.dart';
import 'package:seecooker/utils/shared_preferences_util.dart';

class SearchHistoryProvider extends ChangeNotifier{
  late List<String> _history;

  List<String> get history => _history;

  Future<void> fetchSearchHistory() async {
    // await Future.delayed(const Duration(seconds: 1));
    _history = await SharedPreferencesUtil.getStringList('history');
  }

  Future<bool> updateSearchHistory(String query) async {
    if(_history.contains(query)) {
      _history.removeAt(_history.indexOf(query));
    }
    _history.insert(0, query);
    if(_history.length > 10) {
      _history = _history.sublist(0, 10);
    }
    return SharedPreferencesUtil.setStringList('history', _history);
  }

  Future<bool> clearSearchHistory() async {
    _history.clear();
    notifyListeners();
    return SharedPreferencesUtil.remove('history');
  }
}