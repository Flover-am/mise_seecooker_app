import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  var text = 'explore';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text),
    );
  }
}