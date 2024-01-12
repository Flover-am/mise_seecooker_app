import 'package:flutter/material.dart';
import 'package:seecooker/services/recipe_service.dart';

class SearchAiProvider with ChangeNotifier {
  late String _response;

  final String query;

  SearchAiProvider(this.query);

  String get response => _response;

  Future<void> fetchAiResponse() async {
    final res = await RecipeService.getAiResponse(query);
    if(!res.isSuccess()) {
      throw Exception('未获取到大模型返回结果: ${res.message}');
    }
    _response = res.data;
  }

}