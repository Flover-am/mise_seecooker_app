import 'dart:math';

import 'package:flutter/material.dart';

class SearchRecommendProvider extends ChangeNotifier {
  late List<String> _recommend;

  final List<String> mockList = [
    '黄焖鸡米饭',
    '红烧牛肉面',
    '鲜虾鱼板面',
    '麦辣鸡腿堡',
    '板烧鸡腿堡',
    '双层吉士汉堡'
  ];

  List<String> get recommend => _recommend;

  Future<void> fetchSearchRecommend() async {
    await Future.delayed(const Duration(seconds: 1));
    _recommend = mockList.sublist(0, 3);
  }

  Future<void> refreshSearchRecommend() async {
    // await Future.delayed(const Duration(seconds: 1));
    _recommend = mockList.sublist(Random().nextInt(3), 3 + Random().nextInt(3));
    _recommend.shuffle(Random());
    notifyListeners();
  }
}