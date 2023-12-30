import 'package:flutter/material.dart';

class SearchAiProvider with ChangeNotifier {
  late String _response;

  final String query;

  SearchAiProvider(this.query);

  String get response => _response;

  Future<void> getAiResponse() async {
    await Future.delayed(const Duration(seconds: 1));

    _response = "下面是$query的答案啊阿斯顿八大关核武器的感情唯一的v请问如图围观人群v请问如图围观人v请问如图围观人v请问如图围观人v请问如图围观人v请问如图围观人v请问如图围观人v请问如图围观人v请问如图围观人v请问如图围观人";
  }

}