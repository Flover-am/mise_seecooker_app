import 'dart:math';

import 'package:flutter/material.dart';
import 'package:seecooker/services/recipe_service.dart';

class SearchRecommendProvider extends ChangeNotifier {
  late List<String> _list;

  final List<String> mockList = [
    '黄焖鸡米饭',
    '红烧牛肉面',
    '鲜虾鱼板面',
    '麦辣鸡腿堡',
    '板烧鸡腿堡',
    '双层吉士汉堡'
  ];

  List<String> get list => _list;

  Future<void> fetchSearchRecommend() async {
    final res = await RecipeService.getRandomRecommend();
    if(!res.isSuccess()) {
      throw Exception('未获取到推荐菜谱: ${res.message}');
    }
    _list = res.data.toList().cast<String>();
  }

  Future<void> refreshSearchRecommend() async {
    final res = await RecipeService.getRandomRecommend();
    if(!res.isSuccess()) {
      throw Exception('未获取到推荐菜谱: ${res.message}');
    }
    _list = res.data.toList().cast<String>();
    notifyListeners();
  }
}