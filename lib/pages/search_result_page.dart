import 'package:flutter/material.dart';

class SearchResultPage extends StatelessWidget {
  final String query;

  const SearchResultPage({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(query)
      ),
    );
  }

}